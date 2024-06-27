import 'dart:io';
import 'package:flutter/material.dart';

class StationImage extends StatelessWidget {
  const StationImage({
    super.key,
    required this.path,
    this.size = 80,
  });

  final String path;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image(
      height: size,
      width: size,
      errorBuilder: (context, error, stackTrace) => Card(
        margin: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          size: size,
          Icons.radio,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      loadingBuilder: (context, child, loadingProgress) => SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(),
            ),
            child,
          ],
        ),
      ),
      image:
          path.startsWith("http") ? NetworkImage(path) : FileImage(File(path)),
    );
  }
}
