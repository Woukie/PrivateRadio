import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';
import 'package:private_radio/src/dashboard/dashboard_provider.dart';
import 'package:private_radio/src/dashboard/prompt_station_dialogue.dart';
import 'package:private_radio/src/dashboard/station_image.dart';
import 'package:private_radio/src/serializable/station_data.dart';
import 'package:provider/provider.dart';

class StationListItem extends StatefulWidget {
  const StationListItem({
    super.key,
    required this.stationData,
  });

  final StationData stationData;

  @override
  State<StationListItem> createState() => _StationListItemState();
}

class _StationListItemState extends State<StationListItem> {
  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardController =
        Provider.of<DashboardProvider>(context);

    return Card(
      color: widget.stationData.id == dashboardController.selectedStation
          ? Theme.of(context).colorScheme.surfaceContainerHighest
          : Theme.of(context).colorScheme.surfaceContainerHigh,
      margin: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          dashboardController.selectStation(widget.stationData.id);
        },
        child: Row(
          children: [
            StationImage(
              path: widget.stationData.image,
              size: 80,
              borderRadius: 12,
            ),
            const Padding(padding: EdgeInsets.only(right: 6)),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoScrollText(
                  intervalSpaces: 1,
                  velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                  widget.stationData.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  widget.stationData.url,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            )),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PromptStationDialogue(
                      title: "Edit Station",
                      defaultStationData: widget.stationData,
                      submitCallback: (stationData) {
                        dashboardController.editStation(stationData);
                      },
                      deleteCallback: () {
                        dashboardController.deleteStation(widget.stationData);
                      },
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                dashboardController.toggleFavourate(widget.stationData);
              },
              icon: Icon(
                dashboardController.stations.favourites
                        .contains(widget.stationData.id)
                    ? Icons.star
                    : Icons.star_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
