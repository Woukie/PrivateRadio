import 'package:flutter/material.dart';

import 'player_controlls.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(50, 0, 0, 0),
              spreadRadius: 5,
              blurRadius: 25,
            ),
          ],
        ),
        child: Column(
          children: [
            const PlayerControlls(),
            Card(
              margin: const EdgeInsets.all(6),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: TabBar(
                controller: tabController,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.home),
                  ),
                  Tab(
                    icon: Icon(Icons.star),
                  ),
                  Tab(
                    icon: Icon(Icons.schedule),
                  ),
                  Tab(
                    icon: Icon(Icons.settings),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
