import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CrossScrollStyle {
  CrossScrollStyle({
    this.reverse = false,
    this.padding,
    // this.primary,
    this.physics,
    this.dragStartBehavior=DragStartBehavior.start,
    this.clipBehavior=Clip.hardEdge,
    this.restorationId,
    this.keyboardDismissBehavior= ScrollViewKeyboardDismissBehavior.manual,
  });
  //
  // final bool reverse;
  // final EdgeInsetsGeometry? padding;
  // final bool? primary;
  // final ScrollPhysics? physics;
  // final DragStartBehavior? dragStartBehavior;
  // final Clip? clipBehavior;
  // final String? restorationId;
  // final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the scroll view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the scroll view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// The amount of space by which to inset the child.
  final EdgeInsetsGeometry? padding;




  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics? physics;


  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// {@macro flutter.widgets.scroll_view.keyboardDismissBehavior}
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

}
