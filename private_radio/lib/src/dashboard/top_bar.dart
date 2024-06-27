import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  const TopBar({
    super.key,
    required this.searchController,
    required this.tabController,
  });

  final TextEditingController searchController;
  final TabController tabController;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: AnimatedBuilder(
        animation: widget.tabController.animation!,
        builder: (BuildContext context, snapshot) {
          bool fast =
              (widget.tabController.index - widget.tabController.previousIndex)
                      .abs() >
                  1;

          double proportion;

          if (fast) {
            double target = widget.tabController.index.toDouble();
            double previous = widget.tabController.previousIndex.toDouble();

            proportion = (widget.tabController.animation!.value - previous) /
                (target - previous).abs();
          } else {
            proportion = widget.tabController.animation!.value % 1;
          }

          double lastPageProportion = clampDouble(
            widget.tabController.animation!.value - 2,
            0,
            1,
          );
          return Column(
            children: [
              SafeArea(bottom: false, child: Container()),
              ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: 1 - lastPageProportion,
                  child: Card(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    margin: EdgeInsets.fromLTRB(
                      6,
                      6,
                      6,
                      (1 - lastPageProportion) * 6,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: widget.searchController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: 1 - (sin(pi * proportion) / 4).abs(),
                child: Transform.translate(
                  offset: Offset(sin((-2 * pi * proportion)) * 100,
                      cos((-2 * pi * proportion)) * 5 - 5),
                  child: Opacity(
                    opacity: 1 - sin(pi * proportion).abs(),
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(6, lastPageProportion * 6, 6, 6),
                      child: Text(
                        ["Home", "Favourites", "Recents", "Settings"][fast
                            ? proportion.abs() > 0.5
                                ? widget.tabController.index
                                : widget.tabController.previousIndex
                            : widget.tabController.animation!.value.round()],
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
