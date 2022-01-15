import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CrossScrollStyle {
  CrossScrollStyle({
    this.reverse = false,
    this.padding,
    this.primary,
    this.physics,
    this.dragStartBehavior,
    this.clipBehavior,
    this.restorationId,
    this.keyboardDismissBehavior,
  });

  final bool reverse;
  final EdgeInsetsGeometry? padding;
  final bool? primary;
  final ScrollPhysics? physics;
  final DragStartBehavior? dragStartBehavior;
  final Clip? clipBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;
}
