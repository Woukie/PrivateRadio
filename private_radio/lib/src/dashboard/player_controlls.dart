import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:private_radio/src/dashboard/dashboard_provider.dart';
import 'package:private_radio/src/serializable/station_data.dart';
import 'package:provider/provider.dart';

class PlayerControlls extends StatelessWidget {
  const PlayerControlls({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardProvider =
        Provider.of<DashboardProvider>(context);

    StationData? selectedStation = dashboardProvider.getSelectedStationData();
    AudioPlayer player = dashboardProvider.player;

    bool ready = player.processingState == ProcessingState.ready;

    return AnimatedSize(
      alignment: Alignment.bottomCenter,
      duration: const Duration(milliseconds: 250),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: ready && selectedStation != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                    child: Row(
                      children: [
                        IconButton.filled(
                          onPressed: () {
                            dashboardProvider.togglePlaying();
                          },
                          icon: player.playing
                              ? const Icon(Icons.pause)
                              : const Icon(Icons.play_arrow),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoScrollText(
                                intervalSpaces: 1,
                                velocity: const Velocity(
                                    pixelsPerSecond: Offset(40, 0)),
                                selectedStation.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                selectedStation.url,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        )),
                        IconButton(
                          onPressed: () {
                            dashboardProvider.selectStation(null);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
          !ready && selectedStation != null
              ? const LinearProgressIndicator()
              : Container(),
        ],
      ),
    );
  }
}
