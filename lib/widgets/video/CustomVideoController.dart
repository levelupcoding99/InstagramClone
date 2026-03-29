import 'package:flutter/material.dart';
import 'package:flutter_instagram/stateManager/video/MuteManager.dart';
import 'package:video_player/video_player.dart';

class CustomVideoController {
  final bool autoPlay = true;
  final bool isLooping = true;

  late VideoPlayerController videoController;
  final String videoUrl;

  /// video loading후 상태변경 용도로 사용
  late ValueNotifier<bool> videoStateNotifier;

  /// video 관련 값들, ex: duration(동영상 전체 길이), position(현재 위치)
  VideoPlayerValue get getVideoValue => videoController.value;

  CustomVideoController({required this.videoUrl}) {
    videoStateNotifier = ValueNotifier(false);

    initVideoController().whenComplete(() {
      if (autoPlay) {
        playVideo();
      }
    });
  }

  //Q 이건 videoController.valu값이 바뀔떄마다  불리는 걸까?
  double get aspectRatio {
    if (videoController.value.isInitialized) {
      return videoController.value.aspectRatio;
    }
    return 16 / 9;
  }

  Future<void> initVideoController() async {
    videoController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    await videoController.setVolume(MuteManager.instance.isMute ? 0.0 : 1.0);
    await videoController.setLooping(isLooping);
    await videoController.initialize();

    videoStateNotifier.value = getVideoValue.isInitialized;

    debugPrint('[video] init done : ${videoStateNotifier.value}');
  }

  Future<void> playVideo() async {
    if (!(getVideoValue.isPlaying)) {
      await videoController.play();
    }
  }

  Future<void> setMute() async {
    MuteManager.instance.isMute = !MuteManager.instance.isMute;
    await videoController.setVolume(MuteManager.instance.isMute ? 0 : 1);
  }

  Future<void> setVolume(double volume) async {
    await videoController.setVolume(volume);
  }

  /// 특정 위치에서 시작
  Future<void> seekTo(Duration duration) async {
    await videoController.seekTo(duration);
  }

  /// controller 초기화
  Future<void> dispose() async {
    await videoController.dispose();
    videoStateNotifier.dispose();
  }

  /// full mode일때만 사용
  /// timeline 업데이트에 사용
  void addListener(Function() listener) {
    videoController.addListener(listener);
  }

  /// dispose에 사용 필요
  void removeListener(Function() listener) {
    videoController.removeListener(listener);
  }
}
