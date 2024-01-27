// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

/// Signature for when a [CrossScrollController] has added or removed a
/// [ScrollPosition].
///
/// Since a [ScrollPosition] is not created and attached to a controller until
/// the [Scrollable] is built, this can be used to respond to the position being
/// attached to a controller.
///
/// By having access to the position directly, additional listeners can be
/// applied to aspects of the scroll position, like
/// [ScrollPosition.isScrollingNotifier].
///
/// Used by [CrossScrollController.onAttach] and [CrossScrollController.onDetach].
typedef ScrollControllerCallback = void Function(ScrollPosition position);

/// Controls a scrollable widget.
///
/// Scroll controllers are typically stored as member variables in [State]
/// objects and are reused in each [State.build]. A single scroll controller can
/// be used to control multiple scrollable widgets, but some operations, such
/// as reading the scroll [offset], require the controller to be used with a
/// single scrollable widget.
///
/// A scroll controller creates a [ScrollPosition] to manage the state specific
/// to an individual [Scrollable] widget. To use a custom [ScrollPosition],
/// subclass [CrossScrollController] and override [createScrollPosition].
///
/// {@macro flutter.widgets.scrollPosition.listening}
///
/// Typically used with [ListView], [GridView], [CustomScrollView].
///
/// See also:
///
///  * [ListView], [GridView], [CustomScrollView], which can be controlled by a
///    [CrossScrollController].
///  * [Scrollable], which is the lower-level widget that creates and associates
///    [ScrollPosition] objects with [CrossScrollController] objects.
///  * [PageController], which is an analogous object for controlling a
///    [PageView].
///  * [ScrollPosition], which manages the scroll offset for an individual
///    scrolling widget.
///  * [ScrollNotification] and [NotificationListener], which can be used to
///    listen to scrolling occur without using a [CrossScrollController].

class CrossScrollController extends ChangeNotifier {
  CrossScrollController({
    Offset initialScrollOffset = const Offset(0.0, 0.0),
    this.keepScrollOffset = true,
    this.debugLabel,
    this.onAttach,
    this.onDetach,
  }) : _initialScrollOffset = initialScrollOffset;

  Offset get initialScrollOffset => _initialScrollOffset;
  final Offset _initialScrollOffset;

  final bool keepScrollOffset;

  final ScrollControllerCallback? onAttach;

  final ScrollControllerCallback? onDetach;

  final String? debugLabel;

  ///Initialize Data
  void init(
      {required ScrollController h,
      required ScrollController v,
      required Size cellSize}) {
    _hCont = h;
    _vCont = v;
    _size = cellSize;
  }

  late ScrollController _hCont;

  ScrollController get hCont => _hCont;

  set hCont(ScrollController value) {
    _hCont = value;
    // notifyListeners();
  }

  ScrollController get vCont => _vCont;

  set vCont(ScrollController value) {
    _vCont = value;
    // notifyListeners();
  }

  late ScrollController _vCont = ScrollController();

  Iterable<ScrollPosition> get xPositions => _hCont.positions;
  // final List<ScrollPosition> _xPositions = <ScrollPosition>[];
  Iterable<ScrollPosition> get yPositions => _vCont.positions;
  // final List<ScrollPosition> _yPositions = <ScrollPosition>[];

  ///Check both Positions
  bool get hasClients => _hCont.hasClients && _vCont.hasClients;

  ScrollPosition get xPosition => _hCont.position;

  ScrollPosition get yPosition => _vCont.position;

  /// The current scroll offset of the scrollable widget.
  ///
  /// Requires the controller to be controlling exactly one scrollable widget.
  double get offsetX => xPosition.pixels;
  double get offsetY => yPosition.pixels;

  /// Animates the position from its current value to the given value.
  ///
  /// Any active animation is canceled. If the user is currently scrolling, that
  /// action is canceled.
  ///
  /// The returned [Future] will complete when the animation ends, whether it
  /// completed successfully or whether it was interrupted prematurely.
  ///
  /// An animation will be interrupted whenever the user attempts to scroll
  /// manually, or whenever another activity is started, or whenever the
  /// animation reaches the edge of the viewport and attempts to overscroll. (If
  /// the [ScrollPosition] does not overscroll but instead allows scrolling
  /// beyond the extents, then going beyond the extents will not interrupt the
  /// animation.)
  ///
  /// The animation is indifferent to changes to the viewport or content
  /// dimensions.
  ///
  /// Once the animation has completed, the scroll position will attempt to
  /// begin a ballistic activity in case its value is not stable (for example,
  /// if it is scrolled beyond the extents and in that situation the scroll
  /// position would normally bounce back).
  ///
  /// The duration must not be zero. To jump to a particular value without an
  /// animation, use [jumpTo].
  ///
  /// When calling [animateTo] in widget tests, `await`ing the returned
  /// [Future] may cause the test to hang and timeout. Instead, use
  /// [WidgetTester.pumpAndSettle].

  Future<void> animateXTo(
    double offset, {
    required Duration duration,
    required Curve curve,
  }) async =>
      await hCont.animateTo(offset, duration: duration, curve: curve);

  Future<void> animateYTo(
    double offset, {
    required Duration duration,
    required Curve curve,
  }) async =>
      await _vCont.animateTo(offset, duration: duration, curve: curve);

  /// Jumps the scroll position from its current value to the given value,
  /// without animation, and without checking if the new value is in range.
  ///
  /// Any active animation is canceled. If the user is currently scrolling, that
  /// action is canceled.
  ///
  /// If this method changes the scroll position, a sequence of start/update/end
  /// scroll notifications will be dispatched. No overscroll notifications can
  /// be generated by this method.
  ///
  /// Immediately after the jump, a ballistic activity is started, in case the
  /// value was out of range.
  void jumpXTo(double value) => _hCont.jumpTo(value);

  void jumpYTo(double value) => _vCont.jumpTo(value);

  /// Register the given position with this controller.
  ///
  /// After this function returns, the [animateTo] and [jumpTo] methods on this
  /// controller will manipulate the given position.
  void attachX(ScrollPosition position) => _hCont.attach(position);

  void attachY(ScrollPosition position) => _vCont.attach(position);

  /// Unregister the given position with this controller.
  ///
  /// After this function returns, the [animateTo] and [jumpTo] methods on this
  /// controller will not manipulate the given position.
  void detachX(ScrollPosition position) => _hCont.detach(position);

  void detachY(ScrollPosition position) => _vCont.detach(position);

  @override
  void dispose() {
    _hCont.dispose();
    _vCont.dispose();

    super.dispose();
  }

  /// Creates a [ScrollPosition] for use by a [Scrollable] widget.
  ///
  /// Subclasses can override this function to customize the [ScrollPosition]
  /// used by the scrollable widgets they control. For example, [PageController]
  /// overrides this function to return a page-oriented scroll position
  /// subclass that keeps the same page visible when the scrollable widget
  /// resizes.
  ///
  /// By default, returns a [ScrollPositionWithSingleContext].
  ///
  /// The arguments are generally passed to the [ScrollPosition] being created:
  ///
  ///  * `physics`: An instance of [ScrollPhysics] that determines how the
  ///    [ScrollPosition] should react to user interactions, how it should
  ///    simulate scrolling when released or flung, etc. The value will not be
  ///    null. It typically comes from the [ScrollView] or other widget that
  ///    creates the [Scrollable], or, if none was provided, from the ambient
  ///    [ScrollConfiguration].
  ///  * `context`: A [ScrollContext] used for communicating with the object
  ///    that is to own the [ScrollPosition] (typically, this is the
  ///    [Scrollable] itself).
  ///  * `oldPosition`: If this is not the first time a [ScrollPosition] has
  ///    been created for this [Scrollable], this will be the previous instance.
  ///    This is used when the environment has changed and the [Scrollable]
  ///    needs to recreate the [ScrollPosition] object. It is null the first
  ///    time the [ScrollPosition] is created.
  ScrollPosition createXScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) =>
      _hCont.createScrollPosition(physics, context, oldPosition);

  void xDebugFillDescription(List<String> description) =>
      _hCont.debugFillDescription(description);
  void yDebugFillDescription(List<String> description) =>
      _vCont.debugFillDescription(description);

  ScrollPosition createYScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) =>
      _vCont.createScrollPosition(physics, context, oldPosition);

  Size _size = Size(0.0, 0.0);

  /// cell Size
  Size get size => _size;

  ///Set cell Size
  set size(Size value) {
    _size = value;
  }
}
