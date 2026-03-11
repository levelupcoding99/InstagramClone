import 'package:flutter/material.dart';
import 'package:flutter_instagram/widgets/video/VolumeIconWidget.dart';
import 'package:video_player/video_player.dart';

import 'CustomVideoController.dart';

class VideoPlayerWidget extends StatefulWidget {
  final CustomVideoController videoController;
  final Widget? placeHolder;
  final Size? widgetSize;

  const VideoPlayerWidget({
    super.key,
    required this.videoController,
    this.placeHolder,
    this.widgetSize,
  });

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
    _volumeNotifier = ValueNotifier(_controller.muteSound);
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
    _size = widget.widgetSize ?? MediaQuery.of(context).size;

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

                Positioned.fill(child: _volumeButton()),
                Align(alignment: Alignment.bottomCenter, child: _bottomBar()),
              ],
            ),
          );
        } else {
          return widget.placeHolder ?? Container(color: Colors.black);
        }
      },
    );
  }

  Widget _volumeButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _volumeNotifier!,
      builder: (_, isMute, _) {
        return VolumeIconWidget(soundMute: isMute);
      },
    );
  }

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
