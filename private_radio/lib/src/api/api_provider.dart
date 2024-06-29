import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:private_radio/src/serializable/station_data.dart';
import 'package:http/http.dart' as http;

class ApiProvider with ChangeNotifier {
  final List<StationData> _apiStations = List.empty(growable: true);
  bool _loadingNextPage = false, _endOfList = false;
  int _nextPage = 0;

  bool get loadingNextPage => _loadingNextPage;
  List<StationData> get apiStations => List.of(_apiStations);

  Future<void> fetchNextPage() async {
    if (_loadingNextPage || _endOfList) return;
    _loadingNextPage = true;

    http.Response response = await http.get(
      Uri.parse(
        'https://eu-west-2.aws.data.mongodb-api.com/app/data-yydgvpy/endpoint/top?page=$_nextPage',
      ),
    );

    List<dynamic> stationsJson = jsonDecode(response.body);

    if (stationsJson.isEmpty) {
      _endOfList = true;
    } else {
      _nextPage++;
    }

    _apiStations.addAll([
      for (var station in stationsJson)
        StationData.fromJson(
          station..["id"] = "",
        )
    ]);

    _loadingNextPage = false;

    notifyListeners();
  }
}
