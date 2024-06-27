import 'dart:io';
import 'package:flutter/material.dart';

class StationImage extends StatelessWidget {
  const StationImage({
    super.key,
    required this.path,
    this.size,
  });

  final String path;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Image(
      height: size,
      width: size,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(size: 52, Icons.error),
      image:
          path.startsWith("http") ? NetworkImage(path) : FileImage(File(path)),
    );
  }
}
