import 'package:flutter/material.dart';
import 'package:eko/widgets/list_item_group.dart';
import 'package:eko/helpers/theme.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final Widget? leading;
  final String approveButtonText;
  final void Function()? onApprove;
  final void Function()? onCancel;

  const CustomAlertDialog({
    super.key,
    this.title,
    required this.content,
    required this.approveButtonText,
    required this.onApprove,
    required this.onCancel,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    Widget modifiedContent = content is Text
        ? Text((content as Text).data ?? '', textAlign: TextAlign.center)
        : content;

    return AlertDialog(
      icon: const Icon(
        Icons.warning_amber_outlined,
        size: 30,
      ),
      content: modifiedContent,
      contentTextStyle: TextStyle(
        fontSize: 20,
        color: context.text.titleMedium!.color,
      ),
      actions: <Widget>[
        ListItemGroup(
          children: [
            ListItem(
              onTap: onCancel,
              title: Text("Cancel", textAlign: TextAlign.center),
            ),
            ListItem(
              leading: leading,
              onTap: onApprove,
              title: Text(
                approveButtonText,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.onErrorContainer),
              ),
              tileColor: context.colors.error.withAlpha(50),
            ),
          ],
        ),
      ],
    );
  }
}
