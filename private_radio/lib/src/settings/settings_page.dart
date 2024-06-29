import 'package:flutter/material.dart';
import 'package:private_radio/src/settings/settings_provider.dart';
import 'package:provider/provider.dart';

import 'setting_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Appearance",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SettingItem(
            title: "Theme",
            label: "Save your eyes and use dark mode!",
            child: DropdownMenu(
              initialSelection: settingsProvider.themeMode,
              onSelected: (value) {
                if (value == null) return;
                settingsProvider.updateTheme(value);
              },
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                  value: ThemeMode.system,
                  label: "System",
                ),
                DropdownMenuEntry(
                  value: ThemeMode.dark,
                  label: "Dark",
                ),
                DropdownMenuEntry(
                  value: ThemeMode.light,
                  label: "Light",
                ),
              ],
            ),
          ),
          SettingItem(
            title: "Font",
            label: "Choose what font the app uses",
            child: DropdownMenu(
              initialSelection: settingsProvider.fontName,
              onSelected: (value) {
                if (value == null) return;
                settingsProvider.updateFontName(value);
              },
              dropdownMenuEntries: settingsProvider.fontNames
                  .map((fontName) => DropdownMenuEntry(
                        value: fontName,
                        label: fontName,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
