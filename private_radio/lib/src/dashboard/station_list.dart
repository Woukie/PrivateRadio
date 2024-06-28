import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:private_radio/src/api/api_provider.dart';
import 'package:private_radio/src/dashboard/dashboard_provider.dart';
import 'package:private_radio/src/dashboard/station_list_item.dart';
import 'package:private_radio/src/serializable/station_data.dart';
import 'package:provider/provider.dart';

class StationList extends StatelessWidget {
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

    List<StationData> stationData;

    if (tabIndex == 1) {
      stationData = dashboardController.getFavouriteStations();
    } else if (tabIndex == 2) {
      ApiProvider apiProvider = Provider.of<ApiProvider>(context);

      stationData = apiProvider.apiStations;

      apiProvider.fetchNextPage();
    } else {
      stationData = List.from(dashboardController.stations.stationData);
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
        : tabIndex <= 1 && searchTerm == ""
            ? ReorderableListView(
                proxyDecorator: (child, idk, animation) => ProxyDecorator(
                  animation: animation,
                  child: child,
                ),
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                children: _listItems(stationData),
                onReorder: (int oldIndex, int newIndex) {
                  tabIndex == 0
                      ? dashboardController.moveStation(oldIndex, newIndex)
                      : dashboardController.moveFavouriteStation(
                          oldIndex, newIndex);
                },
              )
            : ListView(
                padding: const EdgeInsets.all(6),
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

class ProxyDecorator extends StatelessWidget {
  const ProxyDecorator({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: (animation.value / 25) + 1,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ).animate().boxShadow(borderRadius: BorderRadius.circular(12)),
              ),
              child ?? Container(),
            ],
          ),
        );
      },
      child: child,
    );
  }

  final Animation animation;
  final Widget child;
}
