import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:ottapp/ui/tv/live_tv.dart' as liveTv;
import 'package:ottapp/ui/video_player/video_player_controller.dart';
import 'package:path/path.dart';
import 'package:shimmer/shimmer.dart';

import '../../base/widget/central_error_placeholder.dart';
import '../../constants.dart';
import '../../data/remote/repository/remote_repository.dart';
import '../../util/helper/network/api.dart';

class VideoPlayerPage extends StatelessWidget {
  final String initialChannelUrl;
  final bool isLiveTv;

  VideoPlayerPage({
    required this.initialChannelUrl,
    this.isLiveTv = true,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              GetBuilder<VideoPlayerViewController>(
                id: "video_player",
                didUpdateWidget: (controller, state) {
                  logDebug("didUpdateWidget");
                },
                didChangeDependencies: (state) {
                  logDebug("didChangeDependencies");
                },
                init: VideoPlayerViewController(
                  initialChannelUrl: this.initialChannelUrl,
                  isLive: this.isLiveTv,
                ),
                builder: (viewController) {
                  return buildVideoPlayer(viewController);
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
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildMessageSection(),
                    buildAdSection(),
                    if (this.isLiveTv) buildTvChannelSegment(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<dynamic> buildMessageSection() {
    return FutureBuilder(
      future: RemoteRepository.on().getDynamicResponse(billingMessageUrl),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            ((snapshot.data as Map)["result"] as List<dynamic>?) != null &&
            (snapshot.data as Map)["result"]!.isNotEmpty &&
            (((snapshot.data as Map)["result"]!.first as Map)["status"]
                as bool)) {
          final message = (((snapshot.data as Map)["result"]!.first
                  as Map)["msg"] as String? ??
              defaultString);

          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            color: Colors.black.withOpacity(0.2),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              message,
              style: textStyleRegular.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  FutureBuilder<dynamic> buildAdSection() {
    return FutureBuilder(
      future: RemoteRepository.on().getDynamicResponse(adUrl),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            ((snapshot.data as Map)["result"] as List<dynamic>?) != null &&
            (snapshot.data as Map)["result"]!.isNotEmpty &&
            (((snapshot.data as Map)["result"]!.first as Map)["status"]
                as bool)) {
          final imageUrl = (((snapshot.data as Map)["result"]!.first
                  as Map)["ad_img"] as String? ??
              defaultString);

          return FutureBuilder<ui.Image>(
            future: _getImage(imageUrl),
            builder: (
              context,
              snapshot,
            ) {
              if (snapshot.hasData && snapshot.data != null) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: AspectRatio(
                    aspectRatio: snapshot.data!.width / snapshot.data!.height,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Future<ui.Image> _getImage(String url) {
    Completer<ui.Image> completer = Completer<ui.Image>();

    NetworkImage(url)
        .resolve(
          ImageConfiguration(),
        )
        .addListener(
          ImageStreamListener(
            (info, _) => completer.complete(info.image),
          ),
        );

    return completer.future;
  }

  Widget buildTvChannelSegment() {
    // Get tv channel categories
    return GetBuilder<VideoPlayerViewController>(
      id: "list_view_channels",
      init: VideoPlayerViewController(
        initialChannelUrl: this.initialChannelUrl,
        isLive: this.isLiveTv,
      ),
      builder: (viewController) {
        return FutureBuilder(
          future: Future.delayed(
            Duration(milliseconds: 500),
            () => RemoteRepository.on().getDynamicResponse(
              tvChannelCategoriesUrl,
            ),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> categoryList = [];
              categoryList.add(null);
              categoryList.addAll(((snapshot.data as List<dynamic>?) ?? []));

              if (categoryList.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return buildTvChannelSegmentItem(
                        categoryList[index],
                        index,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 16.0);
                    },
                    itemCount: categoryList.length,
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

            return ShimmerListWidget();
          },
        );
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
                GetBuilder<VideoPlayerViewController>(
                  id: "view_$url",
                  init: VideoPlayerViewController(
                    initialChannelUrl: this.initialChannelUrl,
                    isLive: this.isLiveTv,
                  ),
                  builder: (viewController) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: MasonryGridView.count(
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 12.0,
                        crossAxisCount: 3,
                        itemCount: channelList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return buildChannelListItem(
                            itemWidth,
                            itemHeight,
                            index,
                            channelList[index],
                          );
                        },
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

    return GetBuilder<VideoPlayerViewController>(
      init: VideoPlayerViewController(
        initialChannelUrl: this.initialChannelUrl,
        isLive: this.isLiveTv,
      ),
      builder: (viewController) {
        final channelUrl =
            channelItem["straming_url"] as String? ?? defaultString;

        bool isSelected = channelUrl == viewController.currentChannelUrl;

        return GestureDetector(
          onTap: () {
            viewController.changeChannel(channelUrl);
          },
          child: Column(
            children: [
              Container(
                width: itemWidth,
                height: itemWidth * 0.65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                  border: isSelected
                      ? const Border.fromBorderSide(
                          const BorderSide(
                            width: 3,
                            color: colorHighlight,
                          ),
                        )
                      : null,
                ),
                child: Center(
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    width: itemWidth / 2.0,
                    height: itemWidth / 2.0,
                    imageUrl: channelLogoUrl!,
                    placeholder: (context, url) => SizedBox.shrink(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildVideoPlayer(VideoPlayerViewController viewController) {
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
  }
}

class ShimmerListWidget extends StatelessWidget {
  const ShimmerListWidget({
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
        return SizedBox(height: 40.0);
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
          liveTv.ShimmerChannelCategoryWidget(),
          Container(
            margin: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: [
                ShimmerChannelRowWidget(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: ShimmerChannelRowWidget(),
                ),
                ShimmerChannelRowWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerChannelRowWidget extends StatelessWidget {
  const ShimmerChannelRowWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        liveTv.ShimmerChannelItemWidget(),
        liveTv.ShimmerChannelItemWidget(),
        liveTv.ShimmerChannelItemWidget(),
      ],
    );
  }
}
