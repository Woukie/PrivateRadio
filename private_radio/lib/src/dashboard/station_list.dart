import 'package:flutter/material.dart';
import 'package:private_radio/src/dashboard/dashboard_provider.dart';
import 'package:private_radio/src/dashboard/station_list_item.dart';
import 'package:private_radio/src/serializable/station_data.dart';
import 'package:provider/provider.dart';

class StationList extends StatelessWidget {
  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          elevation: 0,
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }

  const StationList({
    super.key,
    required this.tabIndex,
    required this.searchTerm,
  });

  final int tabIndex;
  final String searchTerm;

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardController =
        Provider.of<DashboardProvider>(context);

    // Avoid overwriting stations by cloning
    final List<StationData> stationData =
        List.from(dashboardController.stations.stationData);

    if (tabIndex == 1) {
      stationData.removeWhere((station) => !station.favourate);
    } else if (tabIndex == 2) {
      stationData.removeWhere((station) => station.lastPlayed == null);
      stationData.sort(
        (stationA, stationB) =>
            stationB.lastPlayed!.compareTo(stationA.lastPlayed!),
      );
    }

    String searchTermLowerCase = searchTerm.toLowerCase();

    if (searchTerm != "") {
      stationData.removeWhere(
        (station) => !station.name.toLowerCase().contains(searchTermLowerCase),
      );
    }

    return stationData.isEmpty
        ? Center(
            child: Text(
              searchTerm != ""
                  ? "Couldn't find any stations matching that search query"
                  : "No stations here!",
            ),
          )
        : tabIndex == 0
            ? ReorderableListView(
                proxyDecorator: proxyDecorator,
                padding: const EdgeInsets.only(bottom: 6),
                children: _listItems(stationData),
                onReorder: (int oldIndex, int newIndex) {
                  dashboardController.moveStation(oldIndex, newIndex);
                },
              )
            : ListView(
                padding: const EdgeInsets.only(bottom: 6),
                children: _listItems(stationData),
              );
  }

  List<Widget> _listItems(List<StationData> stationData) {
    return [
      for (int index = 0; index < stationData.length; index += 1)
        StationListItem(
          key: Key(index.toString()),
          stationData: stationData[index],
        ),
    ];
  }
}
