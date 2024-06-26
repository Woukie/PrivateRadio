import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:private_radio/src/serializable/station_data.dart';
import 'package:uuid/uuid.dart';

class PromptStationDialogue extends StatefulWidget {
  const PromptStationDialogue({
    super.key,
    required this.title,
    required this.submitCallback,
    this.defaultStationData,
    this.deleteCallback,
  });

  final StationData? defaultStationData;
  final String title;

  final Function(StationData stationData) submitCallback;
  final Function()? deleteCallback;

  @override
  State<PromptStationDialogue> createState() => _PromptStationDialogueState();
}

class _PromptStationDialogueState extends State<PromptStationDialogue> {
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    final TextEditingController nameController = TextEditingController(
      text: widget.defaultStationData?.name ?? "",
    );

    final TextEditingController urlController = TextEditingController(
      text: widget.defaultStationData?.url ?? "",
    );

    imageUrl ??= widget.defaultStationData?.image ??
        "http://owdo.thisisglobal.com/2.0/id/154/logo/800x800.jpg";

    var mediaQuery = MediaQuery.of(context);
    var textTheme = Theme.of(context).textTheme;

    Future<void> pickImage() async {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          imageUrl = image.path;
        });
      }
    }

    return AnimatedContainer(
      padding: mediaQuery.viewInsets,
      duration: const Duration(milliseconds: 100),
      child: Center(
        child: Card(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      widget.title,
                      style: textTheme.headlineMedium,
                    ),
                    widget.deleteCallback == null
                        ? Container()
                        : IconButton(
                            onPressed: () {
                              widget.deleteCallback!();
                              Navigator.pop(context);
                            },
                            tooltip: "Delete",
                            icon: const Icon(Icons.delete),
                          ),
                  ],
                ),
                const Divider(),
                Text('Name', style: textTheme.titleMedium),
                InputBox(
                  nameController: nameController,
                  hintText: "Name",
                  margin: const EdgeInsets.only(bottom: 6),
                ),
                Text(
                  'Choose the display name of the station',
                  style: textTheme.labelMedium,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text('Image', style: textTheme.titleMedium),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Image(
                        height: 52,
                        width: 52,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(size: 52, Icons.error),
                        image: imageUrl!.startsWith("http")
                            ? NetworkImage(imageUrl!)
                            : FileImage(File(imageUrl!)),
                      ),
                      IconButton(
                        onPressed: () {
                          pickImage();
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Select an image from your phone to use as the image of the station',
                  style: textTheme.labelMedium,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text('URL', style: textTheme.titleMedium),
                InputBox(
                  nameController: urlController,
                  hintText: "http://example.com/...",
                  margin: const EdgeInsets.only(bottom: 6),
                ),
                Text(
                  'URLs can point to any media, though it is expected that you use an external URL stream',
                  style: textTheme.labelMedium,
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Submit'),
                    onPressed: () {
                      widget.submitCallback(StationData(
                        id: widget.defaultStationData?.id ?? const Uuid().v4(),
                        name: nameController.text,
                        image: imageUrl!,
                        url: urlController.text,
                      ));
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputBox extends StatelessWidget {
  const InputBox({
    super.key,
    required this.nameController,
    required this.hintText,
    this.margin = const EdgeInsets.all(6),
  });

  final TextEditingController nameController;
  final String hintText;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      margin: margin,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
