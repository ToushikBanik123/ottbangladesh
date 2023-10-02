import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base/widget/central_error_placeholder.dart';
import '../../constants.dart';
import '../../data/remote/repository/remote_repository.dart';
import '../../util/helper/network/api.dart';
import '../../util/helper/text.dart';
import '../video_player/video_player.dart';
import 'live_tv_controller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AppVersion {
  final String? vNumber;
  final String? updateUrl;

  AppVersion({required this.vNumber, required this.updateUrl});

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      vNumber: json['v_number'],
      updateUrl: json['update_url'],
    );
  }
}

class LiveTvPage extends StatefulWidget {
  @override
  State<LiveTvPage> createState() => _LiveTvPageState();
}

class _LiveTvPageState extends State<LiveTvPage> {
  Future<AppVersion> fetchAppVersion() async {
    final apiUrl = 'http://tvapp.ctgtv.live/android_apps/v';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return AppVersion.fromJson(data);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  final String fixedVNumber = "V1.3";
  // Replace with your app's fixed version number
  Future<void> checkAndUpdateAppVersion(BuildContext context) async {
    try {
      final AppVersion apiAppVersion = await fetchAppVersion();
      final String? apiVNumber = apiAppVersion.vNumber;

      // Compare the API version number with the fixed version number
      if (apiVNumber != fixedVNumber) {
        // Show the update popup
        showUpdatePopup(context, apiAppVersion!);
      }
    } catch (error) {
      print('Error fetching API data: $error');
    }
  }

  // void showCancelPopup(BuildContext context) {
  void showUpdatePopup(BuildContext context, AppVersion newVersion) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Available"),
          content: Text(
              "A new version (${newVersion.vNumber}) is available. Do you want to update now?"),
          actions: [
            // TextButton(
            //   onPressed: () {
            //     // Perform any actions you want when "Cancel" is pressed
            //     Navigator.of(context).pop(); // Close the popup
            //   },
            //   child: Text("Cancel"),
            // ),
            TextButton(
              onPressed: () async {
                // final phoneNumber = '9339492053';
                String url = newVersion.updateUrl!;
                // String url = "https://www.google.co.in";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not launch YouTube'),
                    ),
                  );
                }
              },
              child: Text(
                "Update",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Call checkAndUpdateAppVersion when the widget is initialized
    // checkAndUpdateAppVersion(context);
  }

  @override
  Widget build(BuildContext context) {
    checkAndUpdateAppVersion(context);
    return AnnotatedRegion(
      value: systemUiOverlayStyleGlobal,
      child: Scaffold(
        backgroundColor: colorPrimary,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     showCancelPopup(context); // Show the popup
              //   },
              //   child: Text("Show Cancel Popup"),
              // ),

              buildBannerList(),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: buildTvChannelSegment(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBannerList() {
    return GetBuilder<LiveTvController>(
      id: "section_banner",
      init: LiveTvController(),
      builder: (viewController) {
        return FutureBuilder(
          future: Future.delayed(
            Duration(seconds: 1),
            () => RemoteRepository.on().getBanners(),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bannerList = (snapshot.data as List<dynamic>?);

              if (bannerList != null && bannerList.isNotEmpty) {
                return Container(
                  height: viewController.bannerHeight,
                  child: Stack(
                    children: [
                      GetBuilder<LiveTvController>(
                        id: "banner_view",
                        init: LiveTvController(),
                        builder: (viewController) {
                          final ratio = Get.width / viewController.bannerHeight;
                          return CarouselSlider.builder(
                            itemCount: bannerList.length,
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
                                  bannerList.length,
                                );
                              },
                            ),
                            itemBuilder: (
                              BuildContext context,
                              int itemIndex,
                              int realIndex,
                            ) {
                              return buildBanner(bannerList[realIndex]);
                            },
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: GetBuilder<LiveTvController>(
                          init: LiveTvController(),
                          builder: (viewController) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: Image.asset(
                                "images/logo.png",
                                height: 50.0,
                                fit: BoxFit.fitHeight,
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GetBuilder<LiveTvController>(
                          id: "dot_indicator",
                          init: LiveTvController(),
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
                                  dotsCount: bannerList.length,
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
    String? bannerImageUrl = (banner as Map)["channel_logo"];

    if (bannerImageUrl != null && bannerImageUrl.trim().isNotEmpty) {
      bannerImageUrl = bannerImageUrl.trim().startsWith(baseAppUrlLiveTv)
          ? bannerImageUrl.trim()
          : join(
              baseMediaUrlLiveTv,
              bannerImageUrl.trim(),
            );
    } else {
      bannerImageUrl = defaultString;
    }

    return GetBuilder<LiveTvController>(
      init: LiveTvController(),
      builder: (viewController) {
        return GestureDetector(
          onTap: () {},
          child: Stack(
            children: [
              Center(
                child: CachedNetworkImage(
                  height: viewController.bannerHeight,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                  imageUrl: bannerImageUrl!,
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
            ],
          ),
        );
      },
    );
  }

  Widget buildTvChannelSegment() {
    // Get tv channel categories
    return FutureBuilder(
      future: Future.delayed(
        Duration(milliseconds: 500),
        () => RemoteRepository.on().getDynamicResponse(tvChannelCategoriesUrl),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> categoryList = [];
          categoryList.add(null);
          categoryList.addAll(((snapshot.data as List<dynamic>?) ?? []));

          if (categoryList.isNotEmpty) {
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return buildTvChannelSegmentItem(categoryList[index], index);
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

        return ShimmerLiveTvBodyWidget();
      },
    );
  }

  Widget buildTvChannelSegmentItem(Map? category, int index) {
    final itemWidth = ((Get.width - 32.0 - 24.0) / 3.0);
    final itemHeight = itemWidth * 0.65;

    final url = category != null
        ? ApiUtil.appendPathIntoPostfix(
            tvChannelsUrl,
            category["cat_slug"],
          )
        : featuredTvChannelsUrl;

    // Get tv channels of the segment
    return FutureBuilder(
      future: Future.delayed(
        Duration(seconds: 1),
        () => RemoteRepository.on().getDynamicResponse(url),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final channelList = ((((snapshot.data as Map)["result"]
                  as Map)["List"] as List<dynamic>?) ??
              null);
          final categoryName = ((((snapshot.data as Map)["result"]
                  as Map)["cat_name"] as String?) ??
              defaultString);

          if (channelList != null && channelList.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryName,
                  style: textStyleFocused,
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                GetBuilder<LiveTvController>(
                  id: "view_$url",
                  init: LiveTvController(),
                  builder: (viewController) {
                    return Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      height: itemHeight,
                      child: Stack(
                        children: [
                          NotificationListener(
                            onNotification: (ScrollNotification notification) {
                              return _tvChannelListNotificationListener(
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
                                return buildChannelListItem(
                                  itemWidth,
                                  itemHeight,
                                  index,
                                  channelList[index],
                                );
                              },
                              separatorBuilder: (
                                BuildContext context,
                                int index,
                              ) {
                                return SizedBox(width: 12.0);
                              },
                              itemCount: channelList.length,
                            ),
                          ),
                          Align(
                            child: ((viewController.endOfListMap
                                            .containsKey(url) &&
                                        viewController.endOfListMap[url] ==
                                            true) ||
                                    (channelList.length <= 3))
                                ? SizedBox.shrink()
                                : Container(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black.withOpacity(0.6),
                                      size: 20.0,
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

        return ShimmerChannelSegmentItemWidget();
      },
    );
  }

  bool _tvChannelListNotificationListener(
    ScrollNotification notification,
    LiveTvController viewController,
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

  Widget buildChannelListItem(
    double itemWidth,
    double itemHeight,
    int index,
    Map channelItem,
  ) {
    String? channelLogoUrl = channelItem["channel_logo"] as String?;

    if (channelLogoUrl != null && channelLogoUrl.trim().isNotEmpty) {
      channelLogoUrl = channelLogoUrl.trim().startsWith(baseAppUrlLiveTv)
          ? channelLogoUrl.trim()
          : join(
              baseMediaUrlLiveTv,
              channelLogoUrl.trim(),
            );
    } else {
      channelLogoUrl = defaultString;
    }

    return GestureDetector(
      onTap: () {
        final streamingUrl = channelItem["straming_url"] as String?;

        if (TextUtil.isNotEmpty(streamingUrl))
          Get.to(
            () => VideoPlayerPage(
              initialChannelUrl: streamingUrl!,
            ),
          );
      },
      child: Column(
        children: [
          Container(
            width: itemWidth,
            height: itemWidth * 0.65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: Center(
              child: CachedNetworkImage(
                fit: BoxFit.contain,
                width: itemWidth / 2.75,
                height: itemWidth / 2.75,
                imageUrl: channelLogoUrl,
                placeholder: (context, url) => SizedBox.shrink(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
        ],
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
    return GetBuilder<LiveTvController>(
      init: LiveTvController(),
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

class ShimmerLiveTvBodyWidget extends StatelessWidget {
  const ShimmerLiveTvBodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return ShimmerChannelSegmentItemWidget();
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 16.0);
      },
      itemCount: 5,
    );
  }
}

class ShimmerChannelSegmentItemWidget extends StatelessWidget {
  const ShimmerChannelSegmentItemWidget({
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
          ShimmerChannelCategoryWidget(),
          Container(
            margin: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                ShimmerChannelItemWidget(),
                ShimmerChannelItemWidget(),
                ShimmerChannelItemWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerChannelCategoryWidget extends StatelessWidget {
  const ShimmerChannelCategoryWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (Get.width / 2) - 16.0,
      height: 16.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
    );
  }
}

class ShimmerChannelItemWidget extends StatelessWidget {
  const ShimmerChannelItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemWidth = ((Get.width - 32.0 - 24.0) / 3.0);
    final itemHeight = itemWidth * 0.65;

    return Column(
      children: [
        Container(
          width: itemWidth,
          height: itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
