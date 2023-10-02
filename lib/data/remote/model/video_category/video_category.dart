import 'package:json_annotation/json_annotation.dart';

part 'video_category.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VideoCategory {
  @JsonKey(defaultValue: null)
  late String? type;

  VideoCategory();

  factory VideoCategory.fromJson(Map<String, dynamic> json) =>
      _$VideoCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$VideoCategoryToJson(this);
}
