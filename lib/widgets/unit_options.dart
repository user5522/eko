import 'package:eko/models/settings.dart';
import 'package:eko/providers/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UnitOptions extends HookWidget {
  final SettingsNotifier settingsNotifier;
  final Settings settings;

  const UnitOptions({
    super.key,
    required this.settings,
    required this.settingsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final preferredUnit = useState(settings.preferredUnit);
    final controller = useTextEditingController(text: preferredUnit.value);

    return Row(
      children: [
        const Text('Unit'),
        const Spacer(),
        SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Unit'),
            onChanged: (value) {
              settingsNotifier.updatePreferredUnit(value);
            },
            maxLength: 6,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
