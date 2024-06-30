import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:private_radio/src/serializable/station_data.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

import 'station_image.dart';

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
  late TextEditingController nameController, urlController, imageController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.defaultStationData?.name,
    );
    urlController = TextEditingController(
      text: widget.defaultStationData?.url,
    );
    imageController = TextEditingController(
      text: widget.defaultStationData?.image,
    );

    imageController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();

    var mediaQuery = MediaQuery.of(context);
    var textTheme = Theme.of(context).textTheme;

    Future<void> pickImage() async {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          imageController.text = image.path;
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
                InputBox(
                  controller: nameController,
                  hintText: "Name",
                  margin: const EdgeInsets.only(bottom: 6),
                ),
                Row(
                  children: [
                    StationImage(
                      path: imageController.text,
                      size: 50,
                      borderRadius: 12,
                    ),
                    Expanded(
                      child: InputBox(
                        controller: imageController,
                        hintText: "https://location.of/image...",
                        margin: const EdgeInsets.only(left: 6),
                        trailing: IconButton(
                          onPressed: () => pickImage(),
                          icon: const Icon(Icons.drive_folder_upload),
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  'Select an image for the station either from your phone or through a URL to an image on the web',
                  style: textTheme.bodyMedium,
                ),
                const Padding(padding: EdgeInsets.all(6)),
                InputBox(
                  controller: urlController,
                  hintText: "http://url-to.audio/stream...",
                  margin: const EdgeInsets.only(bottom: 6),
                ),
                RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium,
                    children: [
                      const TextSpan(
                        text: 'URLs can point to most media formats. Go to ',
                      ),
                      TextSpan(
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        text: 'streamurl.link',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse('https://streamurl.link/'));
                          },
                      ),
                      const TextSpan(
                        text: ' for an example list of radio station URLs',
                      )
                    ],
                  ),
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
                        image: imageController.text,
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
    required this.controller,
    required this.hintText,
    this.margin = const EdgeInsets.all(6),
    this.trailing,
  });

  final TextEditingController controller;
  final String hintText;
  final EdgeInsets margin;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      margin: margin,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          trailing ?? Container(),
        ],
      ),
    );
  }
}
