import 'package:flutter/material.dart';

class CrossScrollDesign {
  const CrossScrollDesign({
    this.reverse = false,
    this.padding,
    this.physics,
    this.clipBehavior,
    this.restorationId,
    this.keyboardDismissBehavior,
  });

  /// The amount of space by which to inset the child.
  final EdgeInsetsGeometry? padding;
  final bool reverse;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics? physics;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip? clipBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// {@macro flutter.widgets.scroll_view.keyboardDismissBehavior}
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;
}
