// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stations _$StationsFromJson(Map<String, dynamic> json) => Stations(
      stationData: (json['stationData'] as List<dynamic>?)
              ?.map((e) => StationData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      favourites: (json['favourites'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$StationsToJson(Stations instance) => <String, dynamic>{
      'stationData': instance.stationData,
      'favourites': instance.favourites,
    };
