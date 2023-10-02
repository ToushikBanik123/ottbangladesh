import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter_loggy_dio/flutter_loggy_dio.dart';
import '../../../constants.dart';
import '../../../util/helper/network/api.dart';
import '../../local/helper/path_provider.dart';
import '../response/video_category_list_response.dart';
import '../response/video_resource/movie_details/movie_details_response.dart';
import '../response/video_resource/paginated/paginated_video_resource_list_response.dart';
import '../response/video_resource/regular/regular_video_resource_list_response.dart';
import '../response/video_resource/tv_series_details/tv_series_details_response.dart';

class RemoteRepository {
  RemoteRepository._internal();

  static final RemoteRepository _instance = RemoteRepository._internal();

  static Dio? secondaryClient;

  static RemoteRepository on() {
    if (ApiUtil.globalClient == null) {
      final cacheInterceptor = DioCacheInterceptor(
        options: CacheOptions(
          store: HiveCacheStore(AppPathProvider.path),
          policy: CachePolicy.forceCache,
          hitCacheOnErrorExcept: [401, 403],
          maxStale: const Duration(
            days: 3,
          ),
          priority: CachePriority.normal,
        ),
      );

      ApiUtil.globalClient = Dio(
        BaseOptions(
          baseUrl: baseApiUrlLiveTv,
          headers: {
            HttpHeaders.acceptHeader: responseOfJsonType,
          },
        ),
      );

      ApiUtil.globalClient!.interceptors.add(
        LoggyDioInterceptor(requestBody: false, responseBody: true),
      );
      ApiUtil.globalClient!.interceptors.add(cacheInterceptor);

      secondaryClient = Dio(
        BaseOptions(
          baseUrl: baseApiUrlVideos,
          headers: {
            HttpHeaders.acceptHeader: responseOfJsonType,
          },
        ),
      );

      secondaryClient!.interceptors.add(
        LoggyDioInterceptor(requestBody: false, responseBody: true),
      );

      secondaryClient!.interceptors.add(cacheInterceptor);
    }

    return _instance;
  }

  // Homepage
  Future<dynamic> getBanners() async {
    final response = await ApiUtil.getRequest(
      endPoint: bannerUrl,
    );

    return response.data;
  }

  Future<dynamic> getDynamicResponse(
    String url, [
    bool isSecondary = false,
  ]) async {
    final response = await ApiUtil.getRequest(
      endPoint: url,
      client: isSecondary ? secondaryClient : null,
    );

    return response.data;
  }

  Future<VideoCategoryListResponse> getMovieCategories() async {
    final response = await ApiUtil.getRequest(
      endPoint: videosPageMovieCategoriesUrl,
      client: secondaryClient,
    );

    return VideoCategoryListResponse.fromJson(response.data);
  }

  Future<PaginatedVideoResourceListResponse> getPaginatedVideoList(
    String url, {
    int pageNo = 1,
  }) async {
    final response = await ApiUtil.getRequest(
      endPoint: ApiUtil.appendParamIntoPostfix(
        url,
        keyPage,
        pageNo.toString(),
      ),
      client: secondaryClient,
    );

    return PaginatedVideoResourceListResponse.fromJson(response.data);
  }

  Future<RegularVideoResourceListResponse> getRegularVideoResourceList(
    String url,
  ) async {
    final response = await ApiUtil.getRequest(
      endPoint: url,
      client: secondaryClient,
    );

    return RegularVideoResourceListResponse.fromJson(response.data);
  }

  Future<VideoCategoryListResponse> getTvSeriesCategories() async {
    final response = await ApiUtil.getRequest(
      endPoint: videosPageTvSeriesCategoriesUrl,
      client: secondaryClient,
    );

    return VideoCategoryListResponse.fromJson(response.data);
  }

  Future<MovieDetailsResponse> getMovieDetails(
    String slug,
  ) async {
    final response = await ApiUtil.getRequest(
      endPoint: ApiUtil.appendPathIntoPostfix(
        movieDetailsUrl,
        slug,
      ),
      client: secondaryClient,
    );

    return MovieDetailsResponse.fromJson(response.data);
  }

  Future<TvSeriesDetailsResponse> getTvSeriesDetails(
    String slug,
  ) async {
    final response = await ApiUtil.getRequest(
      endPoint: ApiUtil.appendPathIntoPostfix(
        tvSeriesDetailsUrl,
        slug,
      ),
      client: secondaryClient,
    );

    return TvSeriesDetailsResponse.fromJson(response.data);
  }
}
