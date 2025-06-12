import 'package:eko/constants/theme_option.dart';
import 'package:eko/providers/themes.dart';
import 'package:flutter/material.dart';

class ThemeOptions extends StatelessWidget {
  final ThemeNotifier theme;

  const ThemeOptions({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry<ThemeOption>> themeEntries() {
      final themeEntries = <DropdownMenuEntry<ThemeOption>>[];

      for (final ThemeOption option in ThemeOption.values) {
        final label = option.getName();

        themeEntries.add(
          DropdownMenuEntry<ThemeOption>(
            value: option,
            label: label,
          ),
        );
      }
      return themeEntries.toList();
    }

    return Row(
      children: [
        const Text('Theme'),
        const Spacer(),
        DropdownMenu<ThemeOption>(
          width: 130,
          dropdownMenuEntries: themeEntries(),
          label: const Text("Theme"),
          initialSelection: theme.getTheme(),
          onSelected: (value) => theme.changeTheme(value!),
        ),
      ],
    );
  }
}
