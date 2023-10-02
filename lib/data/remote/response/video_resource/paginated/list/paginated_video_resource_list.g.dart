// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_video_resource_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedVideoResourceList _$PaginatedVideoResourceListFromJson(
        Map<String, dynamic> json) =>
    PaginatedVideoResourceList()
      ..currentPage = json['current_page'] as int?
      ..lastPage = json['last_page'] as int?
      ..perPage = json['per_page'] as int?
      ..total = json['total'] as int?
      ..from = json['from'] as int?
      ..country = json['country'] as String?
      ..data = (json['data'] as List<dynamic>?)
              ?.map((e) => VideoResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

Map<String, dynamic> _$PaginatedVideoResourceListToJson(
        PaginatedVideoResourceList instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
      'from': instance.from,
      'country': instance.country,
      'data': instance.data,
    };
