import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StationImage extends StatelessWidget {
  const StationImage({
    super.key,
    required this.path,
    this.size = 80,
    this.borderRadius = 0,
  });

  final String path;
  final double size, borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: size,
        height: size,
        child: Image(
          height: size,
          width: size,
          frameBuilder: (
            BuildContext context,
            Widget child,
            int? frame,
            bool wasSynchronouslyLoaded,
          ) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return child.animate().fade();
          },
          errorBuilder: (context, error, stackTrace) => Card(
            margin: EdgeInsets.zero,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              size: size,
              Icons.radio,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          image: path.startsWith("http")
              ? NetworkImage(path)
              : FileImage(File(path)),
        ),
      ),
    );
  }
}
