import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:private_radio/src/dashboard/dashboard_provider.dart';
import 'package:private_radio/src/dashboard/prompt_station_dialogue.dart';
import 'package:provider/provider.dart';

import 'app_bar.dart';
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
    DashboardProvider dashboardProvider =
        Provider.of<DashboardProvider>(context);

    Duration startDelay = const Duration(milliseconds: 500);

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          TopBar(
            hidden: _tabController.index == 3,
            searchController: _searchController,
            boxDecoration: _containerDecoration(context),
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
                      key: const Key('0'),
                      searchTerm: _searchController.text,
                    ),
                    StationList(
                      tabIndex: 1,
                      key: const Key('1'),
                      searchTerm: _searchController.text,
                    ),
                    StationList(
                      tabIndex: 2,
                      key: const Key('2'),
                      searchTerm: _searchController.text,
                    ),
                    const Center(child: Text("Balls lol")),
                  ],
                ).animate().fade(delay: startDelay),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: _tabController.index == 3
                        ? const SizedBox(height: 20, width: 20)
                        : FloatingActionButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PromptStationDialogue(
                                    title: "Create Station",
                                    submitCallback: (stationData) {
                                      dashboardProvider
                                          .createStation(stationData);
                                    },
                                  );
                                },
                              );
                            },
                            child: const Icon(Icons.add),
                          ),
                  ),
                ).animate().fadeIn(delay: const Duration(milliseconds: 1000)),
              ],
            ),
          ),
          BottomBar(
            containerDecoration: _containerDecoration(context),
            tabController: _tabController,
          )
              .animate()
              .slideY(begin: 1, delay: startDelay)
              .fadeIn(delay: startDelay),
        ],
      ),
    );
  }

  BoxDecoration _containerDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(50, 0, 0, 0),
          spreadRadius: 5,
          blurRadius: 25,
        ),
      ],
    );
  }
}
