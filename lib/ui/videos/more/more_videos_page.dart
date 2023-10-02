import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:shimmer/shimmer.dart';

import '../../../base/widget/central_empty_list_placeholder.dart';
import '../../../base/widget/central_error_placeholder.dart';
import '../../../constants.dart';
import '../../../data/local/state/states.dart';
import '../../../data/remote/model/video_resource/video_resource.dart';
import '../../../util/helper/text.dart';
import '../details/video_details_page.dart';
import '../details/video_details_page_bindings.dart';
import 'more_videos_page_controller.dart';

class MoreVideosPage extends GetView<MoreVideosPageController> {
  MoreVideosPage({required this.appBarTitle});

  final String appBarTitle;
  final itemWidth = ((Get.width - (12.0 * 3)) / 3);
  final itemHeight = ((Get.width - (12.0 * 3)) / 3) * 1.5;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: systemUiOverlayStyleGlobal,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorPrimary,
          elevation: 0.0,
          leading: BackButton(
            color: colorHighlight,
          ),
          titleSpacing: 0.0,
          title: Text(
            appBarTitle,
            style: textStyleAppBar.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        backgroundColor: colorPrimary,
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: Obx(
        () {
          switch (controller.uiState.value) {
            case UiState.onInitialization:
              {
                return SizedBox.shrink();
              }

            case UiState.onLoading:
              if (controller.currentPage == 1) {
                return ShimmerVideosBodyWidget();
              } else {
                return buildVideoListWithLoader(isLoading: true);
              }

            case UiState.onResult:
              return buildVideoListWithLoader();

            case UiState.onResultEmpty:
              return CentralEmptyListPlaceholder();

            case UiState.onError:
              return CentralErrorPlaceholder(
                message: controller.errorMessage,
              );

            default:
              return ShimmerVideosBodyWidget();
          }
        },
      ),
    );
  }

  GetBuilder<MoreVideosPageController> buildVideoListWithLoader({
    bool isLoading = false,
  }) {
    final itemCount = controller.itemList.length +
        (controller.currentPage < controller.lastPage ? 1 : 0);
    return GetBuilder<MoreVideosPageController>(
      id: "list_view_items",
      builder: (viewController) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: NotificationListener(
                onNotification: (ScrollNotification notification) {
                  return _videoListNotificationListener(
                    notification,
                    viewController,
                    controller.url,
                  );
                },
                child: AlignedGridView.count(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    if (controller.currentPage < controller.lastPage &&
                        index == itemCount - 1) {
                      if (isLoading) {
                        return Container(
                          width: itemWidth,
                          height: itemHeight,
                          child: Center(
                            child: SpinKitThreeBounce(
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    } else {
                      return buildVideoListItem(
                        itemWidth,
                        itemHeight,
                        index,
                        controller.itemList[index],
                      );
                    }
                  },
                  itemCount: itemCount,
                  crossAxisCount: 3,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _videoListNotificationListener(
    ScrollNotification notification,
    MoreVideosPageController viewController,
    String url,
  ) {
    if (!(controller.uiState.value == UiState.onLoading) &&
        notification.metrics.pixels == notification.metrics.maxScrollExtent) {
      if (controller.currentPage < controller.lastPage) {
        controller.currentPage += 1;
        controller.getVideoItems();
      }
    }

    return false;
  }

  Widget buildVideoListItem(
    double itemWidth,
    double itemHeight,
    int index,
    VideoResource item,
  ) {
    String? moviePosterUrl = item.posterUrlValue;

    if (moviePosterUrl != null && moviePosterUrl.trim().isNotEmpty) {
      moviePosterUrl = moviePosterUrl.trim().startsWith(baseApiUrlVideos)
          ? moviePosterUrl.trim()
          : join(
              baseMediaUrlVideos,
              moviePosterUrl.trim(),
            );
    } else {
      moviePosterUrl = defaultString;
    }

    return GestureDetector(
      onTap: () {
        if (TextUtil.isNotEmpty(item.slug) &&
            TextUtil.isNotEmpty(item.videoType)) {
          Get.to(
            () => VideoDetailsPage(),
            binding: VideoDetailsPageBindings(
              slug: item.slug!,
              videoType: item.videoType!,
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          const Radius.circular(8.0),
        ),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          width: itemWidth,
          height: itemHeight,
          imageUrl: moviePosterUrl,
          placeholder: (context, url) => Container(
            color: Colors.white,
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}

class ShimmerVideosBodyWidget extends StatelessWidget {
  const ShimmerVideosBodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade500,
      highlightColor: Colors.white,
      enabled: true,
      child: AlignedGridView.count(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        crossAxisCount: 3,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        itemCount: 25,
        itemBuilder: (BuildContext context, int index) {
          return ShimmerVideoItemWidget();
        },
      ),
    );
  }
}

class ShimmerVideoItemWidget extends StatelessWidget {
  const ShimmerVideoItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemWidth = ((Get.width - (12.0 * 3)) / 3);
    final itemHeight = ((Get.width - (12.0 * 3)) / 3) * 1.5;

    return Container(
      width: itemWidth,
      height: itemHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
    );
  }
}
