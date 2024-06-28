import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:private_radio/src/dashboard/dashboard_provider.dart';
import 'package:private_radio/src/dashboard/prompt_station_dialogue.dart';
import 'package:provider/provider.dart';

class AddStationButton extends StatelessWidget {
  const AddStationButton({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardProvider =
        Provider.of<DashboardProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: AnimatedBuilder(
        animation: tabController.animation!,
        builder: (context, child) {
          double proportion =
              clampDouble(tabController.animation!.value - 2, 0, 1);

          return Transform.translate(
            offset: Offset(0, proportion * 30),
            child: Opacity(
              opacity: 1 - proportion,
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PromptStationDialogue(
                        title: "Create Station",
                        submitCallback: (stationData) {
                          dashboardProvider.createStation(stationData);
                          tabController.animateTo(0);
                        },
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              ),
            ),
          );
        },
      ),
    );
  }
}
