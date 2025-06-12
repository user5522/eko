enum ThemeOption {
  dark,
  light,
  auto,
}

extension ThemeOptionName on ThemeOption {
  String getName() {
    switch (this) {
      case ThemeOption.auto:
        return 'System';
      case ThemeOption.dark:
        return 'Dark';
      case ThemeOption.light:
        return 'Light';
    }
  }
}
