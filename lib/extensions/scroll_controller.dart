import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension ScrollControllerExt on ScrollController {
  static final Map<ScrollController, bool> visibilityMap = {};
  static final Map<ScrollController, VoidCallback?> callbackMap = {};

  bool get isAppBarVisible => visibilityMap[this] ?? true;
  set isAppBarVisible(bool value) => visibilityMap[this] = value;

  void setVisibilityCallback(VoidCallback callback) {
    callbackMap[this] = callback;
  }

  void resetAppBarVisibility() {
    if (hasClients && position.maxScrollExtent <= 0) {
      isAppBarVisible = true;
      callbackMap[this]?.call();
    }
  }
}

ScrollController useHidingAppBar({double threshold = 30}) {
  final controller = useScrollController();
  final visible = useState(true);
  final lastScrollPosition = useRef(0.0);

  useEffect(() {
    controller.setVisibilityCallback(() {
      visible.value = controller.isAppBarVisible;
    });
    return null;
  }, [controller]);

  useEffect(() {
    void listen() {
      final currentPosition = controller.position.pixels;
      final delta = (currentPosition - lastScrollPosition.value).abs();

      if (delta > threshold) {
        switch (controller.position.userScrollDirection) {
          case ScrollDirection.idle:
            break;
          case ScrollDirection.forward:
            visible.value = true;
          case ScrollDirection.reverse:
            visible.value = false;
        }
        lastScrollPosition.value = currentPosition;
      }
    }

    controller.addListener(listen);
    return () => controller.removeListener(listen);
  }, [controller]);

  controller.isAppBarVisible = visible.value;
  return controller;
}
