// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_video_resource_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedVideoResourceListResponse _$PaginatedVideoResourceListResponseFromJson(
        Map<String, dynamic> json) =>
    PaginatedVideoResourceListResponse()
      ..catName = json['cat_name'] as String?
      ..details = json['details'] == null
          ? null
          : PaginatedVideoResourceList.fromJson(
              json['details'] as Map<String, dynamic>);

Map<String, dynamic> _$PaginatedVideoResourceListResponseToJson(
        PaginatedVideoResourceListResponse instance) =>
    <String, dynamic>{
      'cat_name': instance.catName,
      'details': instance.details,
    };
