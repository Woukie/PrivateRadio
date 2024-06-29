import 'package:flutter/material.dart';
import 'package:private_radio/src/settings/settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Column(
      children: [
        DropdownMenu(
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
      ],
    );
  }
}
