import 'package:json_annotation/json_annotation.dart';

part 'video_resource.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VideoResource {
  @JsonKey(defaultValue: null)
  late int? id;

  @JsonKey(defaultValue: null)
  late String? title;

  @JsonKey(defaultValue: null)
  late String? slug;

  @JsonKey(defaultValue: null)
  late String? released;

  @JsonKey(defaultValue: null)
  late String? production;

  @JsonKey(defaultValue: null)
  late String? year;

  @JsonKey(defaultValue: null)
  late String? country;

  @JsonKey(defaultValue: null)
  late String? language;

  @JsonKey(defaultValue: null)
  late String? genre;

  @JsonKey(defaultValue: null)
  late String? director;

  @JsonKey(defaultValue: null)
  late String? actors;

  @JsonKey(defaultValue: null)
  late String? plot;

  @JsonKey(defaultValue: null)
  late String? imdbrating;

  @JsonKey(defaultValue: null)
  late String? rottentomatoesrating;

  @JsonKey(defaultValue: null)
  late String? metacriticrating;

  @JsonKey(defaultValue: null)
  late String? trailerValue;

  @JsonKey(defaultValue: null)
  late String? posterUrlValue;

  @JsonKey(defaultValue: null)
  late String? coverUrlValue;

  @JsonKey(defaultValue: null)
  late String? imdbId;

  @JsonKey(defaultValue: null)
  late int? totalDownload;

  @JsonKey(defaultValue: null)
  late int? totalView;

  @JsonKey(defaultValue: null)
  late String? downloadLink;

  @JsonKey(defaultValue: null)
  late String? printType;

  @JsonKey(defaultValue: null)
  late String? type;

  @JsonKey(defaultValue: null)
  late String? imdbTitle;

  @JsonKey(defaultValue: null)
  late String? videoType;

  @JsonKey(defaultValue: null)
  late String? duration;

  @JsonKey(defaultValue: null)
  late int? status;

  @JsonKey(defaultValue: null)
  late String? createdAt;

  @JsonKey(defaultValue: null)
  late String? updatedAt;

  VideoResource();

  factory VideoResource.fromJson(Map<String, dynamic> json) =>
      _$VideoResourceFromJson(json);

  Map<String, dynamic> toJson() => _$VideoResourceToJson(this);
}
