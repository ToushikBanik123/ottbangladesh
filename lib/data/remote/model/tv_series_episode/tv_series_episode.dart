import 'package:json_annotation/json_annotation.dart';

part 'tv_series_episode.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TvSeriesEpisode {

  @JsonKey(defaultValue: null)
  late String? path;

  @JsonKey(defaultValue: null)
  late String? name;

  TvSeriesEpisode();

  factory TvSeriesEpisode.fromJson(Map<String, dynamic> json) =>
      _$TvSeriesEpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$TvSeriesEpisodeToJson(this);
}
