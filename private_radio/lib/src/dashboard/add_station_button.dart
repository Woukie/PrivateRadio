import 'package:flutter/material.dart';
import 'package:private_radio/src/dashboard/dashboard_provider.dart';
import 'package:private_radio/src/dashboard/prompt_station_dialogue.dart';
import 'package:provider/provider.dart';

class AddStationButton extends StatelessWidget {
  const AddStationButton({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardProvider =
        Provider.of<DashboardProvider>(context);

    return Padding(
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
                          dashboardProvider.createStation(stationData);
                        },
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              ),
      ),
    );
  }
}
