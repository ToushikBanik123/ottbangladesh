import 'package:json_annotation/json_annotation.dart';

import '../../../model/video_resource/video_resource.dart';
part 'regular_video_resource_list_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RegularVideoResourceListResponse {
  @JsonKey(defaultValue: null)
  late String? apiName;

  @JsonKey(defaultValue: [])
  late List<VideoResource>? details;

  RegularVideoResourceListResponse();

  factory RegularVideoResourceListResponse.fromJson(Map<String, dynamic> json) =>
      _$RegularVideoResourceListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegularVideoResourceListResponseToJson(this);
}
