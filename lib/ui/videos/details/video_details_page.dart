import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:shimmer/shimmer.dart';

import '../../../base/widget/central_error_placeholder.dart';
import '../../../constants.dart';
import '../../../data/local/state/states.dart';
import '../../../data/remote/model/video_resource/video_resource.dart';
import '../../../data/remote/repository/remote_repository.dart';
import '../../../data/remote/response/video_resource/regular/regular_video_resource_list_response.dart';
import '../../../util/helper/text.dart';
import '../../video_player/video_player_controller.dart';
import 'video_details_page_controller.dart';

class VideoDetailsPage extends GetView<VideoDetailsPageController> {
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
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () {
                switch (controller.uiState.value) {
                  case UiState.onInitialization:
                    {
                      return SizedBox.shrink();
                    }

                  case UiState.onResult:
                    {
                      return controller.isMovie
                          ? TopMovieVideoSectionWidget()
                          : TopTvSeriesVideoSectionWidget();
                    }

                  case UiState.onResultEmpty:
                    {
                      return NoVideoFoundWidget(message: "No video found");
                    }

                  case UiState.onError:
                    {
                      return CentralErrorPlaceholder(
                        message: controller.errorMessage,
                      );
                    }

                  case UiState.onLoading:
                    {
                      return ShimmerBannerWidget();
                    }

                  default:
                    {
                      return ShimmerBannerWidget();
                    }
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildUncategorizedVideoSegmentItem(
                    controller.isMovie
                        ? latestTenMoviesUrl
                        : latestTenTvSeriesUrl,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: buildUncategorizedVideoSegmentItem(
                      controller.isMovie
                          ? mostPopularMoviesUrl
                          : mostPopularTvSeriesUrl,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUncategorizedVideoSegmentItem(String url) {
    // Get movies of the segment
    return FutureBuilder<RegularVideoResourceListResponse>(
      future: Future.delayed(
        Duration(milliseconds: 500),
        () => RemoteRepository.on().getRegularVideoResourceList(url),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final categoryName = snapshot.data?.apiName;
          final videoList = snapshot.data?.details;

          if (videoList != null && videoList.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$categoryName",
                  style: textStyleFocused,
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ).marginOnly(left: 16.0),
                GetBuilder<VideoDetailsPageController>(
                  id: "view_$url",
                  builder: (viewController) {
                    return Container(
                      margin: const EdgeInsets.only(
                        top: 16.0,
                        left: 12.0,
                      ),
                      height: controller.itemHeight,
                      child: Stack(
                        children: [
                          NotificationListener(
                            onNotification: (ScrollNotification notification) {
                              return _videoListNotificationListener(
                                notification,
                                viewController,
                                url,
                              );
                            },
                            child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return buildVideoListItem(
                                  index,
                                  videoList[index],
                                );
                              },
                              separatorBuilder: (
                                BuildContext context,
                                int index,
                              ) {
                                return SizedBox(width: 12.0);
                              },
                              itemCount: videoList.length,
                            ),
                          ),
                          Align(
                            child: ((viewController.endOfListMap
                                            .containsKey(url) &&
                                        viewController.endOfListMap[url] ==
                                            true) ||
                                    (videoList.length <= 4))
                                ? SizedBox.shrink()
                                : Container(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white.withOpacity(0.8),
                                      size: 28.0,
                                    ),
                                  ),
                            alignment: Alignment.centerRight,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        }

        if (snapshot.hasError) {
          return CentralErrorPlaceholder(
            message: "${snapshot.error}",
          );
        }

        return ShimmerVideoSegmentItemWidget(
          isMovie: controller.isMovie,
        );
      },
    );
  }

  bool _videoListNotificationListener(
    ScrollNotification notification,
    VideoDetailsPageController viewController,
    String url,
  ) {
    bool isEndOfListRightNow = notification.metrics.pixels >=
        (notification.metrics.maxScrollExtent -
            (notification.metrics.viewportDimension / 2));

    if (viewController.endOfListMap.containsKey(url)) {
      if (viewController.endOfListMap[url] == isEndOfListRightNow) {
        // Do nothing
      } else {
        viewController.endOfListMap[url] = isEndOfListRightNow;
        viewController.updateView("view_$url");
      }
    } else {
      viewController.endOfListMap[url] = isEndOfListRightNow;
      viewController.updateView("view_$url");
    }

    return false;
  }

  Widget buildVideoListItem(
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
      onTap: () async {
        if (TextUtil.isNotEmpty(item.slug) &&
            TextUtil.isNotEmpty(item.videoType)) {
          controller.changeVideoItem(item.slug!);
        }
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          const Radius.circular(8.0),
        ),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          width: controller.itemWidth,
          height: controller.itemHeight,
          imageUrl: moviePosterUrl,
          placeholder: (context, url) => SizedBox.shrink(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}

class NoVideoFoundWidget extends StatelessWidget {
  final String message;

  const NoVideoFoundWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ratio = 16 / 9;
    final bannerHeight = (1 / ratio) * Get.width;

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          color: Colors.black,
          height: bannerHeight,
          width: Get.width,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                this.message,
                style: textStyleFocused.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class TopMovieVideoSectionWidget extends StatelessWidget {
  const TopMovieVideoSectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewController = Get.find<VideoDetailsPageController>();
    final item = viewController.movieDetailsResponse?.movieDetails;

    if (item != null && TextUtil.isNotEmpty(item.downloadLink)) {
      return Column(
        children: [
          TopVideoPlayerWidget(url: item.downloadLink!),
          Container(
            margin: const EdgeInsets.all(16.0),
            child: VideoTitleBarWidget(item: item),
          ),
        ],
      );
    } else {
      return NoVideoFoundWidget(message: "No video found");
    }
  }
}

class TopVideoPlayerWidget extends StatelessWidget {
  const TopVideoPlayerWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        GetBuilder<VideoPlayerViewController>(
          id: "video_player",
          init: VideoPlayerViewController(
            initialChannelUrl: url,
            isLive: false,
          ),
          builder: (viewController) {
            return Container(
              width: double.maxFinite,
              height: viewController.videoPlayerHeight,
              color: Colors.black,
              child: viewController.hasError
                  ? CentralErrorPlaceholder(
                      message: viewController.errorMessage,
                    )
                  : (viewController.isVideoLoading ||
                          viewController.chewieController == null)
                      ? Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
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
          },
        ),
        IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class TopTvSeriesVideoSectionWidget extends StatelessWidget {
  const TopTvSeriesVideoSectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewController = Get.find<VideoDetailsPageController>();
    final ratio = 16 / 9;
    final bannerHeight = (1 / ratio) * Get.width;
    final item = viewController.tvSeriesDetailsResponse?.tvSeriesDetails;
    final seasonDetails = viewController.tvSeriesDetailsResponse?.seasonDetails;

    if (item != null &&
        seasonDetails != null &&
        seasonDetails.isNotEmpty &&
        seasonDetails.first.seasonResources != null &&
        seasonDetails.first.seasonResources!.isNotEmpty &&
        TextUtil.isNotEmpty(seasonDetails.first.seasonResources!.first.path)) {
      String episodeUrl = seasonDetails.first.seasonResources!.first.path!;
      return Column(
        children: [
          TopVideoPlayerWidget(url: episodeUrl),
          Container(
            margin: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                VideoTitleBarWidget(item: item),
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  width: double.maxFinite,
                  height: 32,
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final season = seasonDetails[index];
                      return GestureDetector(
                        onTap: () {
                          viewController.selectSeason(index);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: colorHighlight,
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(15.0),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 24.0,
                          ),
                          child: Center(
                            child: Text(
                              "${season.seasonName}",
                              style: textStyleSectionTitle,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 8.0);
                    },
                    itemCount: seasonDetails.length,
                  ),
                ),
                Obx(
                  () {
                    final season =
                        seasonDetails[viewController.selectedSeasonIndex.value];

                    if (season.seasonResources == null ||
                        season.seasonResources!.isEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(top: 24.0),
                        color: Colors.black,
                        height: bannerHeight / 2,
                        width: Get.width,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              "No episode found",
                              style: textStyleFocused.copyWith(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        margin: const EdgeInsets.only(top: 24.0),
                        width: double.maxFinite,
                        child: GetBuilder<VideoDetailsPageController>(
                          id: "list_view_episodes",
                          builder: (_) {
                            return MasonryGridView.count(
                              mainAxisSpacing: 20.0,
                              crossAxisSpacing: 12.0,
                              crossAxisCount: 4,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                final episode = season.seasonResources![index];
                                return GestureDetector(
                                  onTap: () {
                                    viewController.selectEpisode(
                                      episode,
                                      index,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                            color: viewController
                                                        .selectedEpisodeIndex ==
                                                    index
                                                ? colorHighlight
                                                : Colors.white),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 12.0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${episode.name}",
                                        style: textStyleRegular.copyWith(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: season.seasonResources!.length,
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return NoVideoFoundWidget(message: "No video found");
    }
  }
}

class VideoTitleBarWidget extends StatelessWidget {
  const VideoTitleBarWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  final VideoResource? item;

  @override
  Widget build(BuildContext context) {
    final viewController = Get.find<VideoDetailsPageController>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${item?.title ?? defaultString}" +
              "${item?.year != null ? " (${item?.year})" : defaultString}",
          style: textStyleAppBar.copyWith(
            color: Colors.white,
          ),
          textAlign: TextAlign.start,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        GestureDetector(
          onTap: () {
            viewController.downloadTheFile();
          },
          child: Image.asset(
            "images/ic_download_file.png",
            height: 20.0,
            fit: BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }
}

class ShimmerBannerWidget extends StatelessWidget {
  const ShimmerBannerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bannerHeight = (9 / 16) * Get.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade500,
      highlightColor: Colors.white,
      enabled: true,
      child: Container(
        height: bannerHeight,
        width: double.maxFinite,
        color: Colors.white,
      ),
    );
  }
}

class ShimmerVideosBodyWidget extends StatelessWidget {
  final bool isMovie;

  const ShimmerVideosBodyWidget({
    Key? key,
    required this.isMovie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return ShimmerVideoSegmentItemWidget(
          isMovie: isMovie,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 40.0);
      },
      itemCount: 5,
    );
  }
}

class ShimmerVideoSegmentItemWidget extends StatelessWidget {
  final bool isMovie;

  const ShimmerVideoSegmentItemWidget({
    Key? key,
    required this.isMovie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade500,
      highlightColor: Colors.white,
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerVideoCategoryWidget(),
          Container(
            margin: const EdgeInsets.only(top: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ShimmerVideoItemWidget(
                    isMovie: isMovie,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ShimmerVideoItemWidget(
                      isMovie: isMovie,
                    ),
                  ),
                  ShimmerVideoItemWidget(
                    isMovie: isMovie,
                  ),
                  ShimmerVideoItemWidget(
                    isMovie: isMovie,
                  ).marginOnly(left: 12.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerVideoCategoryWidget extends StatelessWidget {
  const ShimmerVideoCategoryWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      width: (Get.width / 2) - 16.0,
      height: 16.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
    );
  }
}

class ShimmerVideoItemWidget extends StatelessWidget {
  final bool isMovie;

  const ShimmerVideoItemWidget({
    Key? key,
    required this.isMovie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieItemWidth = ((Get.width - (12.0 * 3)) / 3.5);
    final movieItemHeight = ((Get.width - (12.0 * 3)) / 3.5) * (244 / 163);
    final tvSeriesItemWidth = ((Get.width - (12.0 * 3)) / 3.5);
    final tvSeriesItemHeight = ((Get.width - (12.0 * 3)) / 3.5) * 1.0;
    double itemWidth, itemHeight;

    if (isMovie) {
      itemWidth = movieItemWidth;
      itemHeight = movieItemHeight;
    } else {
      itemWidth = tvSeriesItemWidth;
      itemHeight = tvSeriesItemHeight;
    }

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
