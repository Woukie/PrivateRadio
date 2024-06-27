import 'package:json_annotation/json_annotation.dart';

part 'station_data.g.dart';

@JsonSerializable()
class StationData {
  String name, image, url;
  String id;
  DateTime? lastPlayed;

  StationData({
    this.name = "",
    this.image = "",
    this.url = "",
    required this.id,
  });

  @override
  String toString() {
    return "'$name' ($id): {url: '$url', image: '$image'}";
  }

  factory StationData.fromJson(Map<String, dynamic> json) =>
      _$StationDataFromJson(json);
  Map<String, dynamic> toJson() => _$StationDataToJson(this);
}
