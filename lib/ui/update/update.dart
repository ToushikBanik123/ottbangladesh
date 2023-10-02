import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ottapp/ui/update/update_controller.dart';

import '../../base/widget/central_error_placeholder.dart';
import '../../base/widget/central_progress_indicator.dart';
import '../../base/widget/custom_filled_button.dart';
import '../../constants.dart';
import '../../data/remote/repository/remote_repository.dart';
import '../video_player/video_player_controller.dart';

class UpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: systemUiOverlayStyleGlobal,
      child: Scaffold(
        backgroundColor: colorPrimary,
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: FutureBuilder(
          future: RemoteRepository.on().getDynamicResponse(updateAppUrl),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                (snapshot.data as List<dynamic>?) != null &&
                (snapshot.data as List<dynamic>?)!.isNotEmpty) {
              final map = ((snapshot.data as List<dynamic>?)!.first as Map);

              final videoUrl = (map["videourl"] as String? ?? defaultString);

              final message = (map["msg"] as String? ?? defaultString);

              final updateUrl =
                  (map["updatelinkbutton"] as String? ?? defaultString);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<VideoPlayerViewController>(
                    id: "video_player",
                    init: VideoPlayerViewController(
                      initialChannelUrl: videoUrl,
                      isLive: false,
                    ),
                    builder: (viewController) {
                      return buildVideoPlayer(viewController);
                    },
                  ),
                  Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(
                      top: 32.0,
                      bottom: 16.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    color: Colors.black.withOpacity(0.2),
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      message,
                      style: textStyleRegular.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  GetBuilder<UpdatePageController>(
                    init: UpdatePageController(),
                    builder: (viewController) {
                      return CustomFilledButton(
                        title: "Update",
                        onTap: () {
                          viewController.launchUpdateUrl(updateUrl);
                        },
                      );
                    },
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              return CentralErrorPlaceholder(
                message: "${snapshot.error}",
              );
            }

            return CentralProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget buildVideoPlayer(VideoPlayerViewController viewController) {
    return Container(
      width: double.maxFinite,
      height: viewController.videoPlayerHeight,
      child: viewController.hasError
          ? CentralErrorPlaceholder(
              message: "Could not play. Something went wrong.",
            )
          : (viewController.isVideoLoading ||
                  viewController.chewieController == null)
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Loading"),
                  ],
                )
              : Center(
                  child: Chewie(
                    controller: viewController.chewieController!,
                  ),
                ),
    );
  }
}
