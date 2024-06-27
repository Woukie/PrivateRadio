import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.searchController,
    required this.hidden,
  });

  final TextEditingController searchController;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: AnimatedSize(
        alignment: Alignment.topLeft,
        duration: const Duration(milliseconds: 250),
        child: Column(
          children: [
            AnimatedSwitcher(
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: hidden
                  ? Container()
                  : Card(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      margin: const EdgeInsets.all(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
            ),
            AnimatedSwitcher(
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ],
        ),
      ),
    );
  }
}
