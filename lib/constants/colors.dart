import 'package:flutter/material.dart';

/// hand picked colors for the app theme color.
enum AppColorsList {
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),

  pink('Pink', Colors.pink),
  deepPurple('Deep Purple', Colors.deepPurple),

  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),

  lightGreen('Light Green', Colors.lightGreen),
  green('Green', Colors.green),
  teal('Teal', Colors.teal),

  red('Red', Colors.red),
  lightRed('Light Red', Colors.redAccent);

  const AppColorsList(this.label, this.color);
  final String label;
  final Color color;
}
