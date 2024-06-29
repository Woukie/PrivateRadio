import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../settings/settings_page.dart';
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
                      tabController: _tabController,
                    ),
                    StationList(
                      tabIndex: 1,
                      searchTerm: _searchController.text,
                      tabController: _tabController,
                    ),
                    StationList(
                      tabIndex: 2,
                      searchTerm: _searchController.text,
                      tabController: _tabController,
                    ),
                    const SettingsPage(),
                  ],
                ).animate().fade(delay: startDelay),
                AddStationButton(tabController: _tabController)
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 1000)),
                IgnorePointer(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 50),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(85, 0, 0, 0),
                                    spreadRadius: 5,
                                    blurRadius: 25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
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
