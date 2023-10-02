import 'package:json_annotation/json_annotation.dart';
import '../../../model/tv_series_season/tv_series_season.dart';
import '../../../model/video_resource/video_resource.dart';

part 'tv_series_details_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TvSeriesDetailsResponse {
  @JsonKey(defaultValue: null)
  late VideoResource? tvSeriesDetails;

  @JsonKey(defaultValue: null)
  late List<TvSeriesSeason>? seasonDetails;

  @JsonKey(defaultValue: null)
  late int? totalSeason;

  TvSeriesDetailsResponse();

  factory TvSeriesDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$TvSeriesDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TvSeriesDetailsResponseToJson(this);
}
