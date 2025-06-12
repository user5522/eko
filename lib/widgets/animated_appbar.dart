import 'package:flutter/material.dart';

class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AnimatedAppBar({
    super.key,
    required this.showAppBar,
    required this.appBar,
  });

  final bool showAppBar;
  final AppBar appBar;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: showAppBar ? 80 : 0,
      curve: Curves.easeInOutCubic,
      duration: const Duration(milliseconds: 250),
      child: appBar,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
