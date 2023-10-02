// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regular_video_resource_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegularVideoResourceListResponse _$RegularVideoResourceListResponseFromJson(
        Map<String, dynamic> json) =>
    RegularVideoResourceListResponse()
      ..apiName = json['api_name'] as String?
      ..details = (json['details'] as List<dynamic>?)
              ?.map((e) => VideoResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

Map<String, dynamic> _$RegularVideoResourceListResponseToJson(
        RegularVideoResourceListResponse instance) =>
    <String, dynamic>{
      'api_name': instance.apiName,
      'details': instance.details,
    };
