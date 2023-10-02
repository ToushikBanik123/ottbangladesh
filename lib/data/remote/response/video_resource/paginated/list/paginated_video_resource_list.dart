import 'package:json_annotation/json_annotation.dart';
import '../../../../model/video_resource/video_resource.dart';

part 'paginated_video_resource_list.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaginatedVideoResourceList {
  @JsonKey(defaultValue: null)
  late int? currentPage;

  @JsonKey(defaultValue: null)
  late int? lastPage;

  @JsonKey(defaultValue: null)
  late int? perPage;

  @JsonKey(defaultValue: null)
  late int? total;

  @JsonKey(defaultValue: null)
  late int? from;

  @JsonKey(defaultValue: null)
  late String? country;

  @JsonKey(defaultValue: [])
  late List<VideoResource>? data;

  PaginatedVideoResourceList();

  factory PaginatedVideoResourceList.fromJson(Map<String, dynamic> json) =>
      _$PaginatedVideoResourceListFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedVideoResourceListToJson(this);
}
