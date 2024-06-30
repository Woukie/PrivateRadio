import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:private_radio/src/api/api_provider.dart';
import 'package:private_radio/src/dashboard/dashboard_provider.dart';
import 'package:private_radio/src/dashboard/station_list_item.dart';
import 'package:private_radio/src/serializable/station_data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class StationList extends StatefulWidget {
  const StationList({
    super.key,
    required this.tabIndex,
    required this.searchTerm,
    required this.tabController,
  });

  final int tabIndex;
  final String searchTerm;
  final TabController tabController;

  @override
  State<StationList> createState() => _StationListState();
}

class _StationListState extends State<StationList> {
  late final ScrollController _controller;
  String oldSearchTerm = "";
  CancelableOperation? searchOperation;
  List<StationData> stationData = List.empty(growable: true);

  @override
  void initState() {
    _controller = ScrollController();

    Provider.of<ApiProvider>(context, listen: false).fetchNextPage();

    _controller.addListener(() {
      if (_controller.position.maxScrollExtent - _controller.offset < 300) {
        Provider.of<ApiProvider>(context, listen: false).fetchNextPage();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardController =
        Provider.of<DashboardProvider>(context);

    if (widget.tabIndex == 1) {
      stationData = dashboardController.getFavouriteStations();
    } else if (widget.tabIndex == 2) {
      ApiProvider apiProvider = Provider.of<ApiProvider>(context);

      if (widget.searchTerm == "") {
        stationData = apiProvider.apiStations;
      }
    } else {
      stationData = List.from(dashboardController.stations.stationData);
    }

    String searchTermLowerCase = widget.searchTerm.toLowerCase();

    if (widget.searchTerm != "") {
      if (widget.tabIndex == 2) {
        if (oldSearchTerm != widget.searchTerm) {
          searchOperation?.cancel();

          searchOperation = CancelableOperation.fromFuture(
            http.get(Uri.parse(
              'https://eu-west-2.aws.data.mongodb-api.com/app/data-yydgvpy/endpoint/search?term=${widget.searchTerm}',
            )),
            onCancel: () => {debugPrint('Cancelled Search')},
          );

          searchOperation?.value.then((value) {
            List<dynamic> stationsJson = jsonDecode(value.body);

            setState(() {
              stationData = ([
                for (var station in stationsJson)
                  StationData.fromJson(
                    station..["id"] = "",
                  )
              ]);
            });
          });
        }
      } else {
        stationData.removeWhere(
          (station) =>
              !station.name.toLowerCase().contains(searchTermLowerCase),
        );
      }
    }
    oldSearchTerm = widget.searchTerm;

    return stationData.isEmpty
        ? Center(
            child: Text(
              widget.searchTerm != ""
                  ? "Couldn't find any stations matching that search query"
                  : "No stations here!",
            ),
          )
        : widget.tabIndex <= 1 && widget.searchTerm == ""
            ? ReorderableListView(
                proxyDecorator: (child, idk, animation) => ProxyDecorator(
                  animation: animation,
                  child: child,
                ),
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                children: _listItems(stationData),
                onReorder: (int oldIndex, int newIndex) {
                  widget.tabIndex == 0
                      ? dashboardController.moveStation(oldIndex, newIndex)
                      : dashboardController.moveFavouriteStation(
                          oldIndex, newIndex);
                },
              )
            : ListView(
                controller: _controller,
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                children: _listItems(stationData),
              );
  }

  List<Widget> _listItems(List<StationData> stationData) {
    return [
      for (int index = 0; index < stationData.length; index += 1)
        StationListItem(
          key: Key(index.toString()),
          stationData: stationData[index],
          tabController: widget.tabController,
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
