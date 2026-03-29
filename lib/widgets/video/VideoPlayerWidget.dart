import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/stateManager/LikeChangeNotifier.dart';
import 'package:flutter_instagram/stateManager/video/MuteManager.dart';
import 'package:flutter_instagram/util/firestore/FireStoreManager.dart';
import 'package:flutter_instagram/widgets/IconNumberButton.dart';
import 'package:flutter_instagram/widgets/ImageNumberButton.dart';
import 'package:flutter_instagram/widgets/video/VolumeIconWidget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../data/ReelsData.dart';
import 'CustomVideoController.dart';

class VideoPlayerWidget extends StatefulWidget {
  //stateless로 만들기
  late final CustomVideoController videoController;
  final ReelsData reelsData;

  VideoPlayerWidget({super.key, required this.reelsData}) {
    videoController = CustomVideoController(videoUrl: reelsData.video);
  }

  @override
  State<StatefulWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late CustomVideoController _controller;
  late Size _size;

  /// 볼륨 상태 변경 true = mute
  ValueNotifier<bool>? _volumeNotifier;

  /// indicator, 시간 갱신
  ValueNotifier<Duration>? _timelineNotifier;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoController;
    _volumeNotifier = ValueNotifier(MuteManager.instance.isMute);
    _timelineNotifier = ValueNotifier(Duration.zero);

    _controller.addListener(_listener);
  }

  void _listener() {
    _timelineNotifier?.value = _controller.getVideoValue.position;
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    _volumeNotifier?.dispose();
    _timelineNotifier?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return ValueListenableBuilder<bool>(
      valueListenable: _controller.videoStateNotifier,
      builder: (_, isLoaded, __) {
        if (isLoaded) {
          return SizedBox(
            width: _size.width,
            height: _size.height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller.videoController.value.aspectRatio,
                    child: VideoPlayer(_controller.videoController),
                  ),
                ),

                Positioned.fill(
                  child: VolumeIconWidget(
                    clickAction: () {
                      widget.videoController.setMute();
                    },
                  ),
                ),
                Align(alignment: Alignment.bottomCenter, child: _bottomBar()),
                Align(
                  alignment: Alignment.bottomRight,
                  child: _rightBar(reelsData: widget.reelsData),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: userInfo(
                    context,
                    "https://picsum.photos/600/600",
                    widget.reelsData,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(color: Colors.black);
        }
      },
    );
  }

  // Widget _volumeButton() {
  //   return ValueListenableBuilder<bool>(
  //     valueListenable: _volumeNotifier!,
  //     builder: (_, isMute, _) {
  //       return VolumeIconWidget(soundMute: isMute);
  //     },
  //   );
  // }

  Widget _bottomBar() {
    return SizedBox(
      width: _size.width,
      height: 5,
      child: Column(
        children: [
          ValueListenableBuilder<Duration>(
            valueListenable: _timelineNotifier!,
            builder: (_, duration, _) {
              return SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                  trackHeight: 2,
                ),
                child: Slider(
                  activeColor: Colors.grey,
                  inactiveColor: Colors.black12,

                  thumbColor: Colors.white.withAlpha(0),
                  min: 0.0,
                  max: 1.0,
                  value:
                      (duration.inMilliseconds /
                              _controller
                                  .getVideoValue
                                  .duration
                                  .inMilliseconds) <
                          1.0
                      ? (duration.inMilliseconds /
                            _controller.getVideoValue.duration.inMilliseconds)
                      : 0.0,
                  onChanged: (value) {
                    double touchedPosition =
                        value *
                        _controller.getVideoValue.duration.inMilliseconds;

                    _controller.seekTo(
                      Duration(milliseconds: touchedPosition.round()),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _rightBar({required ReelsData reelsData}) {
  bool isLike = false;

  void likeAction() {
    if (isLike) {
      FireStoreManager.instance.clickedLike(reelsData.id, -1);
      // likeManager.changeLike(reelsData.id, false);
    } else {
      FireStoreManager.instance.clickedLike(reelsData.id, 1);
      // likeManager.changeLike(reelsData.id, true);
    }
    isLike = !isLike;
  }

  void chatOpen() {}
  void regramAction() {}
  void dmAction() {}
  void etcAction() {}
  void musicAction() {}

  return SizedBox(
    width: 50,
    height: 400,
    child: Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      spacing: 20,
      children: [
        ImageNumberButton(
          key: ValueKey('likes'),
          normalImageName: 'assets/like.png',
          chageImage: Image.asset(
            'assets/like_fill.png',
            width: 25,
            height: 25,
            fit: BoxFit.fitWidth,
          ),
          // number: likeManager.likeMap[reelsData.id] ?? 0,
          number: 0,
          onPressed: likeAction,
        ),
        IconNumberButton(
          iconData: Icons.chat_bubble_outline,
          number: reelsData.chatCount,
          onPressed: chatOpen,
        ),
        IconNumberButton(
          iconData: Icons.read_more,
          number: reelsData.rePost,
          onPressed: regramAction,
        ),
        IconNumberButton(
          iconData: Icons.mark_chat_unread_outlined,
          number: reelsData.dm,
          onPressed: dmAction,
        ),
        IconButton(
          onPressed: etcAction,
          icon: Icon(size: 25, Icons.more_horiz, color: Colors.white),
        ),
        musicImage(
          imageUrl: "https://picsum.photos/600/600",
          tapGesture: musicAction,
        ),
      ],
    ),
  );
}

Widget musicImage({
  required String imageUrl,
  required VoidCallback tapGesture,
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: (context, imageProvider) => GestureDetector(
      onTap: tapGesture,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
    ),
    placeholder: (context, url) => CircularProgressIndicator(),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

Widget profileImage({
  required String imageUrl,
  required VoidCallback tapGesture,
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: (context, imageProvider) => GestureDetector(
      onTap: tapGesture,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
    ),
    placeholder: (context, url) => CircularProgressIndicator(),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

Widget userInfo(BuildContext context, String imageUrl, ReelsData reelsData) {
  void profileImageAction() {}
  void follow() {}
  return SizedBox(
    width: MediaQuery.of(context).size.width - 50,
    height: 120,
    child: Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          spacing: 10,
          children: [
            profileImage(imageUrl: imageUrl, tapGesture: profileImageAction),
            Text(
              reelsData.nickname,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            OutlinedButton(
              onPressed: follow,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white, width: 1),
                fixedSize: Size(100, 30),
              ),
              child: Text(
                '팔로우',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        Text(
          reelsData.contents,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}
