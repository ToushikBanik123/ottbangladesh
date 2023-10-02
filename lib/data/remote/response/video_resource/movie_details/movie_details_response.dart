import 'package:json_annotation/json_annotation.dart';
import '../../../model/video_resource/video_resource.dart';

part 'movie_details_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieDetailsResponse {
  @JsonKey(defaultValue: null)
  late VideoResource? movieDetails;

  MovieDetailsResponse();

  factory MovieDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailsResponseToJson(this);
}
