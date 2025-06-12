import 'package:eko/screens/settings/choose_app_color.dart';
import 'package:eko/widgets/color_indicator.dart';
import 'package:eko/widgets/list_item_group.dart';
import 'package:eko/widgets/theme_options.dart';
import 'package:eko/widgets/unit_options.dart';
import 'package:eko/db/services/services.dart';
import 'package:eko/providers/notes.dart';
import 'package:eko/providers/settings.dart';
import 'package:eko/providers/themes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider.notifier);
    final settingsNotifier = ref.watch(settingsProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final monetTheming = settings.monetTheming;
    final appThemeColor = settings.appThemeColor;
    final notes = ref.read(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(title: Text("Customize"), dense: true),
          ListItemGroup(
            children: [
              ListItem(
                leading: const Icon(Icons.palette_outlined, size: 20),
                title: ThemeOptions(theme: themeNotifier),
                onTap: () {},
              ),
              ListItem(
                leading: const Icon(Icons.wallpaper_outlined, size: 20),
                title: const Text("Monet Theming"),
                subtitle: const Text("Android 12+"),
                trailing: Switch(
                  value: monetTheming,
                  onChanged: (value) =>
                      settingsNotifier.updateMonetThemeing(value),
                ),
                onTap: () =>
                    settingsNotifier.updateMonetThemeing(!monetTheming),
              ),
              ListItem(
                enabled: !monetTheming,
                leading: const Icon(
                  Icons.colorize_outlined,
                  size: 20,
                ),
                horizontalTitleGap: 8,
                title: const Text("App Color"),
                trailing: ColorIndicator(
                    color: appThemeColor, inactive: monetTheming),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChooseAppColor()),
                  );
                },
              ),
              ListItem(
                leading: const Icon(Icons.attach_money_rounded, size: 20),
                title: UnitOptions(
                  settings: settings,
                  settingsNotifier: settingsNotifier,
                ),
                onTap: () {},
              ),
            ],
          ),
          ListTile(title: Text("Data"), dense: true),
          ListItemGroup(
            children: [
              ListItem(
                leading: const Icon(Icons.file_present_outlined, size: 20),
                title: const Text("Export as TXT"),
                onTap: () {
                  final messenger = ScaffoldMessenger.of(context);
                  exportNotesToTxt(messenger, notes);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
