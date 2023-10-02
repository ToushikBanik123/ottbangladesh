// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_series_season.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvSeriesSeason _$TvSeriesSeasonFromJson(Map<String, dynamic> json) =>
    TvSeriesSeason()
      ..seasonName = json['season_name'] as String?
      ..seasonResources = (json['season_resources'] as List<dynamic>?)
          ?.map((e) => TvSeriesEpisode.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$TvSeriesSeasonToJson(TvSeriesSeason instance) =>
    <String, dynamic>{
      'season_name': instance.seasonName,
      'season_resources': instance.seasonResources,
    };
