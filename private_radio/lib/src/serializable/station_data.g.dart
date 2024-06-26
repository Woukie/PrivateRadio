// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationData _$StationDataFromJson(Map<String, dynamic> json) => StationData(
      name: json['name'] as String? ?? "",
      image: json['image'] as String? ?? "",
      url: json['url'] as String? ?? "",
      favourate: json['favourate'] as bool? ?? false,
      id: json['id'] as String,
    )..lastPlayed = json['lastPlayed'] == null
        ? null
        : DateTime.parse(json['lastPlayed'] as String);

Map<String, dynamic> _$StationDataToJson(StationData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'url': instance.url,
      'favourate': instance.favourate,
      'id': instance.id,
      'lastPlayed': instance.lastPlayed?.toIso8601String(),
    };
