import 'package:flutter/widgets.dart';

class DuoSideBackScope extends InheritedWidget {
  const DuoSideBackScope({
    super.key,
    required this.isNativeBackEnabled,
    required super.child,
  });

  final bool isNativeBackEnabled;

  static bool isEnabled(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DuoSideBackScope>()
          ?.isNativeBackEnabled ??
      false;

  @override
  bool updateShouldNotify(DuoSideBackScope oldWidget) =>
      isNativeBackEnabled != oldWidget.isNativeBackEnabled;
}
