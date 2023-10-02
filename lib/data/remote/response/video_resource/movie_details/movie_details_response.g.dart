// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailsResponse _$MovieDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    MovieDetailsResponse()
      ..movieDetails = json['movie_details'] == null
          ? null
          : VideoResource.fromJson(
              json['movie_details'] as Map<String, dynamic>);

Map<String, dynamic> _$MovieDetailsResponseToJson(
        MovieDetailsResponse instance) =>
    <String, dynamic>{
      'movie_details': instance.movieDetails,
    };
