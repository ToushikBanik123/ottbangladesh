import 'package:json_annotation/json_annotation.dart';

import '../tv_series_episode/tv_series_episode.dart';
part 'tv_series_season.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TvSeriesSeason {

  @JsonKey(defaultValue: null)
  late String? seasonName;

  @JsonKey(defaultValue: null)
  late List<TvSeriesEpisode>? seasonResources;

  TvSeriesSeason();

  factory TvSeriesSeason.fromJson(Map<String, dynamic> json) =>
      _$TvSeriesSeasonFromJson(json);

  Map<String, dynamic> toJson() => _$TvSeriesSeasonToJson(this);
}
