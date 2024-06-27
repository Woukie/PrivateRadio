import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
                proxyDecorator: (child, idk, animation) => ProxyDecorator(
                  animation: animation,
                  child: child,
                ),
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                children: _listItems(stationData),
                onReorder: (int oldIndex, int newIndex) {
                  dashboardController.moveStation(oldIndex, newIndex);
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
