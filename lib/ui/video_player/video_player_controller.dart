import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:video_player/video_player.dart';

import '../../base/widget/central_error_placeholder.dart';

class VideoPlayerViewController extends GetxController {
  final String initialChannelUrl;
  final bool isLive;

  VideoPlayerViewController({
    required this.initialChannelUrl,
    this.isLive = true,
  });

  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;

  late double videoPlayerHeight;
  late double ratio;
  late bool isVideoLoading;
  late bool hasError;
  late String errorMessage;
  late String currentChannelUrl;
  late StreamSubscription<NativeDeviceOrientation> _streamSubscription;

  @override
  void onInit() {
    super.onInit();

    _streamSubscription = NativeDeviceOrientationCommunicator()
        .onOrientationChanged(useSensor: true)
        .listen(
      (event) {
        if (event == NativeDeviceOrientation.portraitDown ||
            event == NativeDeviceOrientation.portraitUp) {
          chewieController?.exitFullScreen();
        } else {
          chewieController?.enterFullScreen();
        }
      },
    );

    chewieController = null;
    videoPlayerController = null;
    isVideoLoading = false;
    hasError = false;
    errorMessage = "Could not play. Something went wrong.";
    currentChannelUrl = this.initialChannelUrl;

    ratio = 16 / 9;
    videoPlayerHeight = ((1 / ratio) * Get.width);
  }

  @override
  void onReady() {
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    handleVideoPlayer();
  }

  Future<void> pausePlayer() async {
    await chewieController?.pause();
  }

  Future<void> resumePlayer() async {
    await chewieController?.pause();
/*    chewieController?.dispose();
    chewieController = null;
    videoPlayerController?.dispose();
    videoPlayerController = null;*/

    handleVideoPlayer();
  }

  Future<void> handleVideoPlayer() async {
    ChewieController? oldChewieController;
    VideoPlayerController? oldVideoPlayerController;

    if (chewieController != null) {
      oldChewieController = chewieController;
    }

    if (videoPlayerController != null) {
      oldVideoPlayerController = videoPlayerController;
    }

    chewieController = null;
    videoPlayerController = null;

    isVideoLoading = true;
    hasError = false;
    updateView("video_player");

    oldChewieController?.dispose();
    await oldVideoPlayerController?.dispose();

    videoPlayerController = VideoPlayerController.network(currentChannelUrl);

    try {
      await videoPlayerController?.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        allowedScreenSleep: false,
        isLive: this.isLive,
        aspectRatio: ratio,
        placeholder: Container(
          color: Colors.black,
        ),
        errorBuilder: (context, errorMessage) {
          return CentralErrorPlaceholder(message: errorMessage);
        },
        showOptions: !this.isLive,
      );

      hasError = false;
    } catch (e) {
      logError("VideoPlayerController :: ", e);

      if (e is PlatformException &&
          e.message != null &&
          e.message!.isNotEmpty &&
          e.message ==
              "Video player had error com.google.android" +
                  ".exoplayer2.ExoPlaybackException: Source error") {
        errorMessage = "The channel source is broken";
      } else {
        errorMessage = "Could not play. Something went wrong.";
      }

      if (chewieController != null) {
        oldChewieController = chewieController;
      }

      if (videoPlayerController != null) {
        oldVideoPlayerController = videoPlayerController;
      }

      videoPlayerController = null;
      chewieController = null;

      hasError = true;
    } finally {
      isVideoLoading = false;
      updateView("video_player");
      oldChewieController?.dispose();
      await oldVideoPlayerController?.dispose();
    }
  }

  @override
  void onClose() async {
    await chewieController?.pause();
    chewieController?.dispose();
    await videoPlayerController?.dispose();
    await _streamSubscription.cancel();

    super.onClose();
  }

  Future<void> changeChannel(String url) async {
    bool shouldTrigger = false;

    if (!isVideoLoading && !hasError) {
      // Player is playing
      shouldTrigger = true;
    } else if (!isVideoLoading && hasError) {
      // Error happened previously
      shouldTrigger = true;
    } else if (isVideoLoading && !hasError) {
      // Currently loading
      shouldTrigger = false;
    } else {
      // WTF case
      shouldTrigger = false;
    }

    if (shouldTrigger) {
      currentChannelUrl = url;
      updateView("list_view_channels");
      resumePlayer();
    }
  }

  void updateView(String id) {
    update([id]);
  }
}
