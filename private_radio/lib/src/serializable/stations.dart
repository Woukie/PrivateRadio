import 'package:json_annotation/json_annotation.dart';

import 'station_data.dart';

part 'stations.g.dart';

@JsonSerializable()
class Stations {
  @JsonKey(defaultValue: [])
  List<StationData> stationData;
  @JsonKey(defaultValue: [])
  List<String> favourites;

  Stations({
    required this.stationData,
    required this.favourites,
  });

  factory Stations.fromJson(Map<String, dynamic> json) =>
      _$StationsFromJson(json);
  Map<String, dynamic> toJson() => _$StationsToJson(this);
}
