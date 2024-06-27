import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:private_radio/src/serializable/station_data.dart';
import 'package:private_radio/src/serializable/stations.dart';

class DashboardProvider with ChangeNotifier {
  late final Stations _stations;
  late final AudioPlayer _player;
  String? _selectedStation;
  bool _loaded = false;

  Stations get stations => _stations;
  bool get loaded => _loaded;
  AudioPlayer get player => _player;
  String? get selectedStation => _selectedStation;

  DashboardProvider() {
    _player = AudioPlayer();

    _player.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace stackTrace) {
        if (kDebugMode) {
          print('A stream error occurred: $e');
        }
      },
    );

    _player.playerStateStream.listen((playerState) {
      notifyListeners();
    });
  }

  Future<void> load() async {
    final path = (await getApplicationDocumentsDirectory()).path;
    File stationsFile = File('$path/stations.json');

    if (await stationsFile.exists()) {
      Map<String, dynamic> stationsJson =
          jsonDecode(await stationsFile.readAsString());
      _stations = Stations.fromJson(stationsJson);
    } else {
      _stations = Stations(stationData: List.empty(growable: true));
    }

    if (kDebugMode) {
      int stationCount = stations.stationData.length;
      print("loaded $stationCount station${stationCount == 1 ? "" : "s"}");
    }

    _loaded = true;

    notifyListeners();
  }

  Future<void> save() async {
    final path = (await getApplicationDocumentsDirectory()).path;
    File stationsFile = File('$path/stations.json');

    await stationsFile.writeAsString(jsonEncode(_stations.toJson()));

    if (kDebugMode) {
      int stationCount = stations.stationData.length;
      print("saved $stationCount station${stationCount == 1 ? "" : "s"}");
    }
  }

  StationData? getSelectedStationData() {
    for (var station in stations.stationData) {
      if (station.id == selectedStation) return station;
    }

    return null;
  }

  Future<void> createStation(StationData stationData) async {
    _stations.stationData.insert(0, stationData);

    await save();
    notifyListeners();
  }

  Future<void> deleteStation(StationData deleteStation) async {
    _stations.stationData.removeWhere(
      (station) => station.id == deleteStation.id,
    );

    if (_selectedStation == deleteStation.id) {
      _selectedStation = null;
      await player.stop();
      notifyListeners();
    }

    await save();
    notifyListeners();
  }

  Future<void> editStation(StationData newStation) async {
    StationData station = _stations.stationData
        .firstWhere((station) => station.id == newStation.id);

    station.image = newStation.image;
    station.name = newStation.name;
    station.url = newStation.url;

    if (_selectedStation == newStation.id) {
      _selectedStation = null;
      await player.stop();
      notifyListeners();
    }

    await save();
    notifyListeners();
  }

  void moveStation(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final StationData stationData = _stations.stationData.removeAt(oldIndex);
    _stations.stationData.insert(newIndex, stationData);

    notifyListeners();
    save();
  }

  Future<void> toggleFavourate(StationData stationData) async {
    int stationIndex = _stations.stationData.indexOf(stationData);

    _stations.stationData[stationIndex].toggleFavourate();

    await save();
    notifyListeners();
  }

  Future<void> selectStation(String? stationId) async {
    _selectedStation = stationId;

    if (stationId == null) {
      await player.stop();
      notifyListeners();
      return;
    }

    StationData stationData = _stations.stationData.firstWhere(
      (station) => station.id == stationId,
    );

    stationData.lastPlayed = DateTime.now().toUtc();

    if (kDebugMode) {
      print("selected station: ");
      print(stationData.toString());
    }

    await player.stop();
    notifyListeners();

    await save();

    try {
      await player.setUrl(stationData.url);
      await player.play();
      if (kDebugMode) print("Successfully playing audio");
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Could not play audio");
    }
  }

  Future<void> togglePlaying() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }

    notifyListeners();
  }
}
