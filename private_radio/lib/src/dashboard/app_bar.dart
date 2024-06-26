import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  const TopBar({
    super.key,
    required this.searchController,
    required this.boxDecoration,
    required this.hidden,
  });

  final TextEditingController searchController;
  final BoxDecoration boxDecoration;
  final bool hidden;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> with TickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );

  late final Animation<double> animation = CurvedAnimation(
    parent: animationController,
    curve: Curves.fastOutSlowIn,
  );

  @override
  Widget build(BuildContext context) {
    if (widget.hidden) {
      animationController.reverse();
    } else {
      animationController.forward();
    }

    return Container(
      decoration: widget.boxDecoration,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const SizedBox(height: 60),
            Expanded(
              child: SizeTransition(
                sizeFactor: animation,
                axis: Axis.vertical,
                axisAlignment: 1,
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  margin: const EdgeInsets.all(6),
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
          ],
        ),
      ),
    );
  }
}
