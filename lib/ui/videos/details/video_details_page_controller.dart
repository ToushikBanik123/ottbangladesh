import 'dart:collection';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/local/state/states.dart';
import '../../../data/remote/model/tv_series_episode/tv_series_episode.dart';
import '../../../data/remote/repository/remote_repository.dart';
import '../../../data/remote/response/video_resource/movie_details/movie_details_response.dart';
import '../../../data/remote/response/video_resource/tv_series_details/tv_series_details_response.dart';
import '../../../util/helper/text.dart';
import '../../../util/lib/toast.dart';
import '../../video_player/video_player_controller.dart';

class VideoDetailsPageController extends GetxController {
  final movieItemWidth = ((Get.width - (12.0 * 3)) / 3.5);
  final movieItemHeight = ((Get.width - (12.0 * 3)) / 3.5) * (244 / 163);
  final tvSeriesItemWidth = ((Get.width - (12.0 * 3)) / 3.5);
  final tvSeriesItemHeight = ((Get.width - (12.0 * 3)) / 3.5) * 1.0;

  final String videoType;
  String slug;

  VideoDetailsPageController({
    required this.videoType,
    required this.slug,
  });

  late bool isMovie;
  late double itemWidth, itemHeight;
  late String errorMessage;
  late int selectedEpisodeIndex;
  late String? downloadPath;

  late HashMap<String, bool> endOfListMap;

  late MovieDetailsResponse? movieDetailsResponse;
  late TvSeriesDetailsResponse? tvSeriesDetailsResponse;
  late Rx<UiState> uiState;
  late RxInt selectedSeasonIndex;

  @override
  void onInit() {
    isMovie = videoType == "Movie";

    if (isMovie) {
      itemWidth = movieItemWidth;
      itemHeight = movieItemHeight;
    } else {
      itemWidth = tvSeriesItemWidth;
      itemHeight = tvSeriesItemHeight;
    }

    endOfListMap = HashMap<String, bool>();
    uiState = UiState.onInitialization.obs;
    errorMessage = "Something went wrong";
    movieDetailsResponse = null;
    tvSeriesDetailsResponse = null;
    selectedEpisodeIndex = -1;
    selectedSeasonIndex = RxInt(-1);

    _setDownloadPath();
    super.onInit();
  }

  @override
  void onReady() {
    fetchData();
    super.onReady();
  }

  void fetchData() {
    if (isMovie) {
      _getMovieDetails();
    } else {
      _getTvSeriesDetails();
    }
  }

  @override
  void onClose() {
    uiState.close();
    selectedSeasonIndex.close();
    super.onClose();
  }

  Future<void> _setDownloadPath() async {
    Directory? _path = await getExternalStorageDirectory();
    if (_path == null) {
      downloadPath = null;
      Get.log("Did not find download path :: null");
      return;
    }

    String _localPath = _path.path + Platform.pathSeparator + 'Download';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    downloadPath = _localPath;
    Get.log("Got it :: $downloadPath}");
  }

  Future<void> downloadTheFile() async {}

  void updateView(String id) {
    update([id]);
  }

  Future<void> _getMovieDetails() async {
    try {
      uiState.value = UiState.onLoading;
      final response = await Future.delayed(
        Duration(milliseconds: 500),
        () => RemoteRepository.on().getMovieDetails(slug),
      );

      movieDetailsResponse = response;
      uiState.value = UiState.onResult;
    } catch (e) {
      Get.log("Error: ${e.toString()}");
      errorMessage = e.toString();
      uiState.value = UiState.onError;
    }
  }

  Future<void> _getTvSeriesDetails() async {
    try {
      uiState.value = UiState.onLoading;
      final response = await Future.delayed(
        Duration(milliseconds: 500),
        () => RemoteRepository.on().getTvSeriesDetails(slug),
      );

      if (response.seasonDetails != null &&
          response.seasonDetails!.isNotEmpty) {
        tvSeriesDetailsResponse = response;
        selectedSeasonIndex.value = 0;

        if (response.seasonDetails![0].seasonResources != null &&
            response.seasonDetails![0].seasonResources!.isNotEmpty) {
          selectedEpisodeIndex = 0;
        }
        uiState.value = UiState.onResult;
      } else {
        uiState.value = UiState.onResultEmpty;
      }
    } catch (e) {
      Get.log("Error: ${e.toString()}");
      errorMessage = e.toString();
      uiState.value = UiState.onError;
    }
  }

  void selectSeason(int index) {
    selectedSeasonIndex.value = index;

    if (tvSeriesDetailsResponse != null &&
        tvSeriesDetailsResponse!.seasonDetails != null &&
        tvSeriesDetailsResponse!.seasonDetails![index].seasonResources !=
            null &&
        tvSeriesDetailsResponse!
            .seasonDetails![index].seasonResources!.isNotEmpty) {
      selectedEpisodeIndex = 0;

      final episode =
          tvSeriesDetailsResponse!.seasonDetails![index].seasonResources!.first;
      if (TextUtil.isNotEmpty(episode.path)) {
        Get.find<VideoPlayerViewController>().changeChannel(episode.path!);
      } else {
        ToastUtil.show("Invalid url");
        Get.find<VideoPlayerViewController>().pausePlayer();
      }
    } else {
      selectedEpisodeIndex = -1;
      Get.find<VideoPlayerViewController>().pausePlayer();
      // Show there is no video available
    }
  }

  void selectEpisode(TvSeriesEpisode episode, int index) {
    selectedEpisodeIndex = index;
    updateView("list_view_episodes");

    if (TextUtil.isNotEmpty(episode.path)) {
      Get.find<VideoPlayerViewController>().changeChannel(episode.path!);
    } else {
      ToastUtil.show("Invalid url");
      Get.find<VideoPlayerViewController>().pausePlayer();
    }
  }

  void changeVideoItem(String slug) {
    this.slug = slug;

    movieDetailsResponse = null;
    tvSeriesDetailsResponse = null;
    selectedEpisodeIndex = -1;
    selectedSeasonIndex.value = -1;
    fetchData();
  }
}
