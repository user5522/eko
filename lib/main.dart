import 'package:dynamic_color/dynamic_color.dart';
import 'package:eko/helpers/theme.dart';
import 'package:eko/providers/settings.dart';
import 'package:eko/providers/themes.dart';
import 'package:eko/screens/list/list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const EKOApp()));
}

class EKOApp extends ConsumerWidget {
  const EKOApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final settings = ref.watch(settingsProvider);
    final monetTheming = settings.monetTheming;
    final appThemeColor = settings.appThemeColor;
    final Brightness systemBrightness =
        MediaQuery.of(context).platformBrightness;

    return DynamicColorBuilder(
      builder: (
        ColorScheme? lightDynamic,
        ColorScheme? darkDynamic,
      ) {
        return MaterialApp(
          title: 'EKO',
          theme: ThemeData(
            colorScheme: ThemeHelper.getColorScheme(
              monetTheming: monetTheming,
              theme: theme,
              systemBrightness: systemBrightness,
              lightDynamic: lightDynamic,
              darkDynamic: darkDynamic,
              appThemeColor: appThemeColor,
            ),
            useMaterial3: true,
          ),
          home: const ListScreen(),
        );
      },
    );
  }
}
