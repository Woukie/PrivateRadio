import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'add_station_button.dart';
import 'top_bar.dart';
import 'bottom_bar.dart';
import 'station_list.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late final TabController _tabController =
      TabController(vsync: this, length: 4);
  int _lastIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController.addListener(() {
      if (_lastIndex != _tabController.index) {
        setState(() {});
        _lastIndex = _tabController.index;
      }
    });
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Duration startDelay = const Duration(milliseconds: 500);

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          TopBar(
            searchController: _searchController,
            tabController: _tabController,
          )
              .animate()
              .slideY(begin: -1, delay: startDelay)
              .fadeIn(delay: startDelay),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    StationList(
                      tabIndex: 0,
                      searchTerm: _searchController.text,
                    ),
                    StationList(
                      tabIndex: 1,
                      searchTerm: _searchController.text,
                    ),
                    StationList(
                      tabIndex: 2,
                      searchTerm: _searchController.text,
                    ),
                    const Center(child: Text("Balls lol")),
                  ],
                ).animate().fade(delay: startDelay),
                AddStationButton(tabController: _tabController)
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 1000)),
              ],
            ),
          ),
          BottomBar(tabController: _tabController)
              .animate()
              .slideY(begin: 1, delay: startDelay)
              .fadeIn(delay: startDelay),
        ],
      ),
    );
  }
}
