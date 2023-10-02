// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_series_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvSeriesDetailsResponse _$TvSeriesDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    TvSeriesDetailsResponse()
      ..tvSeriesDetails = json['tv_series_details'] == null
          ? null
          : VideoResource.fromJson(
              json['tv_series_details'] as Map<String, dynamic>)
      ..seasonDetails = (json['season_details'] as List<dynamic>?)
          ?.map((e) => TvSeriesSeason.fromJson(e as Map<String, dynamic>))
          .toList()
      ..totalSeason = json['total_season'] as int?;

Map<String, dynamic> _$TvSeriesDetailsResponseToJson(
        TvSeriesDetailsResponse instance) =>
    <String, dynamic>{
      'tv_series_details': instance.tvSeriesDetails,
      'season_details': instance.seasonDetails,
      'total_season': instance.totalSeason,
    };
