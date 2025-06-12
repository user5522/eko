import 'package:eko/helpers/theme.dart';
import 'package:flutter/material.dart';

class ListItemGroup extends StatefulWidget {
  final List<ListItem> children;
  final Color? tileColor;
  final Future<bool> Function(int, ListItem)? onItemDismissed;

  const ListItemGroup({
    super.key,
    required this.children,
    this.tileColor,
    this.onItemDismissed,
  });

  @override
  State<ListItemGroup> createState() => ListItemGroupState();
}

class ListItemGroupState extends State<ListItemGroup> {
  late List<ListItem> items;

  @override
  void initState() {
    super.initState();
    items = List.from(widget.children);
  }

  @override
  void didUpdateWidget(ListItemGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children != oldWidget.children) {
      items = List.from(widget.children);
    }
  }

  BorderRadius getBorderRadius(ShapeBorder shape) {
    if (shape is RoundedRectangleBorder) {
      return shape.borderRadius as BorderRadius;
    }
    return BorderRadius.circular(10.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.asMap().entries.map((e) {
        final index = e.key;

        ShapeBorder getShape(int index, int length) {
          bool isFirst = index == 0;
          bool isLast = index == length - 1;
          if (length == 1) {
            return const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            );
          }
          if (isFirst || isLast) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(isFirst ? 10 : 5),
                bottom: Radius.circular(isFirst ? 5 : 10),
              ),
            );
          }
          return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          );
        }

        final shape = getShape(index, items.length);
        final borderRadius = getBorderRadius(shape);

        final listItem = ListItem.from(
          e.value,
          shape: shape,
          tileColor: widget.tileColor,
        );

        if (widget.onItemDismissed != null) {
          return ClipRRect(
            borderRadius: borderRadius,
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.startToEnd,
              confirmDismiss: (direction) async {
                if (widget.onItemDismissed != null) {
                  final result =
                      await widget.onItemDismissed!(index, items[index]);
                  if (result == true) {
                    setState(() {
                      items.removeAt(index);
                    });
                  }
                  return result;
                }
                return true;
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: listItem,
            ),
          );
        }

        return listItem;
      }).toList(),
    );
  }
}

class ListItem extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final ShapeBorder? shape;
  final Color? tileColor;
  final double? horizontalTitleGap;
  final bool enabled;

  const ListItem({
    super.key,
    this.horizontalTitleGap,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.shape,
    this.tileColor,
    this.enabled = true,
  });

  factory ListItem.from(ListItem item, {ShapeBorder? shape, Color? tileColor}) {
    return ListItem(
      horizontalTitleGap: item.horizontalTitleGap,
      title: item.title,
      subtitle: item.subtitle,
      leading: item.leading,
      trailing: item.trailing,
      onTap: item.onTap,
      shape: shape ?? item.shape,
      tileColor: tileColor ?? item.tileColor,
      enabled: item.enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final customTileColor = tileColor ?? context.colors.onInverseSurface;
    const customPadding = EdgeInsets.only(bottom: 2);

    return Padding(
      padding: customPadding,
      child: ListTile(
        enabled: enabled,
        horizontalTitleGap: horizontalTitleGap,
        title: title,
        subtitle: subtitle,
        leading: leading,
        onTap: onTap,
        shape: shape,
        trailing: trailing,
        tileColor: customTileColor,
      ),
    );
  }
}
