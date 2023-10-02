import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:shimmer/shimmer.dart';

import '../../../base/widget/central_error_placeholder.dart';
import '../../../constants.dart';
import '../../../data/remote/model/video_category/video_category.dart';
import '../../../data/remote/model/video_resource/video_resource.dart';
import '../../../data/remote/repository/remote_repository.dart';
import '../../../data/remote/response/video_category_list_response.dart';
import '../../../data/remote/response/video_resource/paginated/paginated_video_resource_list_response.dart';
import '../../../data/remote/response/video_resource/regular/regular_video_resource_list_response.dart';
import '../../../util/helper/network/api.dart';
import '../../../util/helper/text.dart';
import '../details/video_details_page.dart';
import '../details/video_details_page_bindings.dart';
import '../more/more_videos_page.dart';
import '../more/more_videos_page_bindings.dart';
import 'tv_series_page_controller.dart';

class TvSeriesPage extends StatelessWidget {
  final itemWidth = ((Get.width - (12.0 * 3)) / 3.5);
  final itemHeight = ((Get.width - (12.0 * 3)) / 3.5) * 1.0;

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
            buildBannerList(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildUncategorizedVideoSegmentItem(latestTenTvSeriesUrl),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: buildUncategorizedVideoSegmentItem(
                      mostPopularTvSeriesUrl,
                    ),
                  ),
                  buildDynamicVideoSegment(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBannerList() {
    return GetBuilder<TvSeriesPageController>(
      id: "section_banner",
      init: TvSeriesPageController(),
      builder: (viewController) {
        return FutureBuilder(
          future: Future.delayed(
            const Duration(seconds: 1),
            () => RemoteRepository.on().getDynamicResponse(
              videosPageBannerUrl,
              true,
            ),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bannerList = (snapshot.data as List<dynamic>?) ?? [];
              final List<dynamic> finalBannerList = [];
              bannerList.forEach((element) {
                if ((element as Map<String, dynamic>)['video_type'] !=
                    'Movie') {
                  finalBannerList.add(element);
                }
              });

              if (finalBannerList.isNotEmpty) {
                return Container(
                  height: viewController.bannerHeight,
                  child: Stack(
                    children: [
                      GetBuilder<TvSeriesPageController>(
                        id: "banner_view",
                        init: TvSeriesPageController(),
                        builder: (viewController) {
                          final ratio = Get.width / viewController.bannerHeight;
                          return CarouselSlider.builder(
                            itemCount: finalBannerList.length,
                            options: CarouselOptions(
                              scrollPhysics: BouncingScrollPhysics(),
                              height: viewController.bannerHeight,
                              aspectRatio: ratio,
                              enableInfiniteScroll: false,
                              reverse: false,
                              autoPlay: false,
                              enlargeCenterPage: false,
                              viewportFraction: 1.0,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index, reason) {
                                viewController.onBannerChanged(
                                  index,
                                  finalBannerList.length,
                                );
                              },
                            ),
                            itemBuilder: (
                              BuildContext context,
                              int itemIndex,
                              int realIndex,
                            ) {
                              return buildBanner(finalBannerList[realIndex]);
                            },
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: GetBuilder<TvSeriesPageController>(
                          init: TvSeriesPageController(),
                          builder: (viewController) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: Image.asset(
                                "images/logo.png",
                                height: 32.0,
                                fit: BoxFit.fitHeight,
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GetBuilder<TvSeriesPageController>(
                          id: "dot_indicator",
                          init: TvSeriesPageController(),
                          builder: (viewController) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 16.0,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DotsIndicator(
                                  mainAxisSize: MainAxisSize.max,
                                  dotsCount: finalBannerList.length,
                                  position: viewController.selectedPageIndex
                                      .toDouble(),
                                  decorator: DotsDecorator(
                                    color: const Color(0xFFD8CFBF),
                                    activeColor: const Color(0xFFFBB217),
                                    size: const Size(20.0, 6.0),
                                    activeSize: const Size(20.0, 6.0),
                                    activeShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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

            return ShimmerBannerWidget();
          },
        );
      },
    );
  }

  Widget buildBanner(banner) {
    final title = (banner as Map)["title"];
    final year = (banner)["year"];
    final slug = (banner) ["slug"];
    final videoType = (banner) ["video_type"];

    return GetBuilder<TvSeriesPageController>(
      init: TvSeriesPageController(),
      builder: (viewController) {
        return GestureDetector(
          onTap: () {
            if (TextUtil.isNotEmpty(slug) &&
                TextUtil.isNotEmpty(videoType)) {
              Get.to(
                    () => VideoDetailsPage(),
                binding: VideoDetailsPageBindings(
                  slug: slug!,
                  videoType: videoType!,
                ),
              );
            }
          },
          child: Stack(
            children: [
              Center(
                child: CachedNetworkImage(
                  height: viewController.bannerHeight,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                  imageUrl:
                      (join(baseMediaUrlVideos, (banner)["cover_url_value"])),
                  placeholder: (context, url) => SizedBox.shrink(),
                  errorWidget: (context, url, error) => SizedBox.shrink(),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: viewController.bannerHeight / 4.0,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        colorPrimary,
                        Colors.transparent,
                      ], // red to yellow/ repeats the gradient over the canvas
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  height: viewController.bannerHeight / 4.0,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[
                        colorPrimary,
                        Colors.transparent,
                      ], // red to yellow/ repeats the gradient over the canvas
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 16.0, bottom: 36.0),
                  child: Text(
                    "$title ${year != null ? "($year)" : defaultString}",
                    style: textStyleAppBar.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildDynamicVideoSegment() {
    // Get movie categories
    return FutureBuilder<VideoCategoryListResponse>(
      future: Future.delayed(
        Duration(milliseconds: 500),
        () => RemoteRepository.on().getTvSeriesCategories(),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final categoryList = (snapshot.data?.list ?? null);

          if (categoryList != null && categoryList.isNotEmpty) {
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return buildVideoSegmentItem(categoryList[index], index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 16.0);
              },
              itemCount: categoryList.length,
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

        return ShimmerVideosBodyWidget();
      },
    );
  }

  Widget buildVideoSegmentItem(VideoCategory videoCategory, int index) {
    final url = ApiUtil.appendPathIntoPostfix(
      videosPageTvSeriesByCategoryUrl,
      videoCategory.type,
    );

    // Get movies of the segment
    return FutureBuilder<PaginatedVideoResourceListResponse>(
      future: RemoteRepository.on().getPaginatedVideoList(url),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final categoryName = snapshot.data?.catName;
          final movieList = snapshot.data?.details?.data;

          if (movieList != null && movieList.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "$categoryName",
                      style: textStyleFocused,
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => MoreVideosPage(
                            appBarTitle: "$categoryName",
                          ),
                          binding: MoreVideosPageBindings(
                            url: ApiUtil.appendPathIntoPostfix(
                              videosPageMoreTvSeriesByCategoryUrl,
                              videoCategory.type,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            "MORE",
                            style: textStyleFocused.copyWith(
                              fontSize: 14.0,
                              color: colorHighlight,
                            ),
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: colorHighlight,
                            size: 14.0,
                          ).marginOnly(left: 4.0),
                        ],
                      ),
                    ),
                  ],
                ).marginSymmetric(horizontal: 16.0),
                GetBuilder<TvSeriesPageController>(
                  id: "view_$url",
                  init: TvSeriesPageController(),
                  builder: (viewController) {
                    return Container(
                      margin: const EdgeInsets.only(
                        top: 16.0,
                        left: 12.0,
                      ),
                      height: itemHeight,
                      child: Stack(
                        children: [
                          NotificationListener(
                            onNotification: (ScrollNotification notification) {
                              return _movieListNotificationListener(
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
                                return buildMovieListItem(
                                  itemWidth,
                                  itemHeight,
                                  index,
                                  movieList[index],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(width: 12.0);
                              },
                              itemCount: movieList.length,
                            ),
                          ),
                          Align(
                            child: ((viewController.endOfListMap
                                            .containsKey(url) &&
                                        viewController.endOfListMap[url] ==
                                            true) ||
                                    (movieList.length <= 4))
                                ? SizedBox.shrink()
                                : Container(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white.withOpacity(0.8),
                                      size: 28.0,
                                    ),
                                    /*margin: const EdgeInsets.only(bottom: 68.0),*/
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

        return ShimmerVideoSegmentItemWidget();
      },
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
          final movieList = snapshot.data?.details;

          if (movieList != null && movieList.isNotEmpty) {
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
                GetBuilder<TvSeriesPageController>(
                  id: "view_$url",
                  init: TvSeriesPageController(),
                  builder: (viewController) {
                    return Container(
                      margin: const EdgeInsets.only(
                        top: 16.0,
                        left: 12.0,
                      ),
                      height: itemHeight,
                      child: Stack(
                        children: [
                          NotificationListener(
                            onNotification: (ScrollNotification notification) {
                              return _movieListNotificationListener(
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
                                return buildMovieListItem(
                                  itemWidth,
                                  itemHeight,
                                  index,
                                  movieList[index],
                                );
                              },
                              separatorBuilder: (
                                BuildContext context,
                                int index,
                              ) {
                                return SizedBox(width: 12.0);
                              },
                              itemCount: movieList.length,
                            ),
                          ),
                          Align(
                            child: ((viewController.endOfListMap
                                            .containsKey(url) &&
                                        viewController.endOfListMap[url] ==
                                            true) ||
                                    (movieList.length <= 4))
                                ? SizedBox.shrink()
                                : Container(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white.withOpacity(0.8),
                                      size: 28.0,
                                    ),
                                    /*margin: const EdgeInsets.only(bottom: 68.0),*/
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

        return ShimmerVideoSegmentItemWidget();
      },
    );
  }

  bool _movieListNotificationListener(
    ScrollNotification notification,
    TvSeriesPageController viewController,
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

  Widget buildMovieListItem(
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
        borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          width: itemWidth,
          height: itemHeight,
          imageUrl: moviePosterUrl,
          placeholder: (context, url) => SizedBox.shrink(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}

class ShimmerBannerWidget extends StatelessWidget {
  const ShimmerBannerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TvSeriesPageController>(
      init: TvSeriesPageController(),
      builder: (viewController) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade500,
          highlightColor: Colors.white,
          enabled: true,
          child: Container(
            height: viewController.bannerHeight,
            width: double.maxFinite,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

class ShimmerVideosBodyWidget extends StatelessWidget {
  const ShimmerVideosBodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return ShimmerVideoSegmentItemWidget();
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 40.0);
      },
      itemCount: 5,
    );
  }
}

class ShimmerVideoSegmentItemWidget extends StatelessWidget {
  const ShimmerVideoSegmentItemWidget({
    Key? key,
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
                  ShimmerVideoItemWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ShimmerVideoItemWidget(),
                  ),
                  ShimmerVideoItemWidget(),
                  ShimmerVideoItemWidget().marginOnly(left: 12.0),
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
  const ShimmerVideoItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemWidth = ((Get.width - (12.0 * 3)) / 3.5);
    final itemHeight = ((Get.width - (12.0 * 3)) / 3.5) * 1.0;

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
