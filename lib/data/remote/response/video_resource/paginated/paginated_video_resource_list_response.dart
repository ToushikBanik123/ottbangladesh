import 'package:json_annotation/json_annotation.dart';

import 'list/paginated_video_resource_list.dart';
part 'paginated_video_resource_list_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaginatedVideoResourceListResponse {
  @JsonKey(defaultValue: null)
  late String? catName;

  @JsonKey(defaultValue: null)
  late PaginatedVideoResourceList? details;

  PaginatedVideoResourceListResponse();

  factory PaginatedVideoResourceListResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginatedVideoResourceListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedVideoResourceListResponseToJson(this);
}
