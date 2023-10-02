// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoResource _$VideoResourceFromJson(Map<String, dynamic> json) =>
    VideoResource()
      ..id = json['id'] as int?
      ..title = json['title'] as String?
      ..slug = json['slug'] as String?
      ..released = json['released'] as String?
      ..production = json['production'] as String?
      ..year = json['year'] as String?
      ..country = json['country'] as String?
      ..language = json['language'] as String?
      ..genre = json['genre'] as String?
      ..director = json['director'] as String?
      ..actors = json['actors'] as String?
      ..plot = json['plot'] as String?
      ..imdbrating = json['imdbrating'] as String?
      ..rottentomatoesrating = json['rottentomatoesrating'] as String?
      ..metacriticrating = json['metacriticrating'] as String?
      ..trailerValue = json['trailer_value'] as String?
      ..posterUrlValue = json['poster_url_value'] as String?
      ..coverUrlValue = json['cover_url_value'] as String?
      ..imdbId = json['imdb_id'] as String?
      ..totalDownload = json['total_download'] as int?
      ..totalView = json['total_view'] as int?
      ..downloadLink = json['download_link'] as String?
      ..printType = json['print_type'] as String?
      ..type = json['type'] as String?
      ..imdbTitle = json['imdb_title'] as String?
      ..videoType = json['video_type'] as String?
      ..duration = json['duration'] as String?
      ..status = json['status'] as int?
      ..createdAt = json['created_at'] as String?
      ..updatedAt = json['updated_at'] as String?;

Map<String, dynamic> _$VideoResourceToJson(VideoResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'released': instance.released,
      'production': instance.production,
      'year': instance.year,
      'country': instance.country,
      'language': instance.language,
      'genre': instance.genre,
      'director': instance.director,
      'actors': instance.actors,
      'plot': instance.plot,
      'imdbrating': instance.imdbrating,
      'rottentomatoesrating': instance.rottentomatoesrating,
      'metacriticrating': instance.metacriticrating,
      'trailer_value': instance.trailerValue,
      'poster_url_value': instance.posterUrlValue,
      'cover_url_value': instance.coverUrlValue,
      'imdb_id': instance.imdbId,
      'total_download': instance.totalDownload,
      'total_view': instance.totalView,
      'download_link': instance.downloadLink,
      'print_type': instance.printType,
      'type': instance.type,
      'imdb_title': instance.imdbTitle,
      'video_type': instance.videoType,
      'duration': instance.duration,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
