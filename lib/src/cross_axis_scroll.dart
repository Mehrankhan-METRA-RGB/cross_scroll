import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'cross_scroll_bar.dart';
import 'cross_scroll_decor.dart';

// class Thumb {
//   Thumb({this.currentPosition, this.visibility = true, this.thumbWidth});
//   final double? currentPosition;
//   final double? thumbWidth;
//   final bool visibility;
// }

class CrossScroll extends StatefulWidget {
  const CrossScroll(
      {this.child,
      this.verticalScroll,
      this.horizontalScroll,
      this.horizontalScrollController,
      this.verticalScrollController,
      this.idleColor,
      this.hoverColor,
      this.horizontalBar = const CrossScrollBar(
          isAlwaysShown: true,
          trackVisibility: false,
          radius: Radius.elliptical(8, 8),
          interactive: false,
          hoverThickness: 16,
          thickness: 8,
          showTrackOnHover: false),
      this.verticalBar = const CrossScrollBar(
          isAlwaysShown: true,
          trackVisibility: false,
          radius: Radius.elliptical(8, 8),
          interactive: false,
          hoverThickness: 16,
          thickness: 8,
          showTrackOnHover: false),
      Key? key})
      : super(key: key);
  final Widget? child;
  final CrossScrollStyle? verticalScroll;
  final CrossScrollStyle? horizontalScroll;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).

  final ScrollController? horizontalScrollController;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).

  final ScrollController? verticalScrollController;
  final CrossScrollBar? verticalBar;
  final CrossScrollBar? horizontalBar;

  ///when you hovered over a thumb
  final Color? hoverColor;

  ///Normal thumb color
  final Color? idleColor;

  @override
  State<CrossScroll> createState() => _CrossScrollState();
}

class _CrossScrollState extends State<CrossScroll> {
  // final ScrollController _horScrollController = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController verticalScrollController = ScrollController();
  // final StreamController<Thumb> _streamController = StreamController<Thumb>();

  double? width = 0;

  double? fullHeight = 0;

  final _trackKey = GlobalKey();

  bool _onHoverTrack = false;

  double? thumbCurrentPosition = 0;
  double previousWidth = 0;
  double _viewport = 0;
  double _maxExtent = 0.1;
  double _thumbWidth = 55;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    if (width != previousWidth) {
      Future.delayed(Duration.zero, () {
        setState(() {
          initializeControllerValues();
          keepThumbInRangeWhileResizingScreen();
        });
      });
      previousWidth = width!;
    }

    CrossScrollBar? vBar = widget.verticalBar;
    CrossScrollStyle? vStyle = widget.verticalScroll;
    CrossScrollBar? hBar = widget.horizontalBar;
    CrossScrollStyle? hStyle = widget.horizontalScroll;
    return Scaffold(
      body: Stack(
        children: [
          CustomCrossScrollBar(
            controller: verticalScrollController,
            isAlwaysShown: vBar?.isAlwaysShown,
            // interactive: vBar.interactive,
            trackVisibility: vBar?.trackVisibility,
            showTrackOnHover: vBar?.showTrackOnHover,
            hoverThickness: vBar?.hoverThickness,
            thickness: vBar?.thickness,
            idleColor: widget.idleColor,
            hoverColor: widget.hoverColor,
            radius: vBar?.radius,
            notificationPredicate: vBar?.notificationPredicate,
            child: SingleChildScrollView(
              reverse: vStyle?.reverse ?? false,
              clipBehavior: vStyle?.clipBehavior ?? Clip.hardEdge,
              dragStartBehavior:
                  vStyle?.dragStartBehavior ?? DragStartBehavior.start,
              keyboardDismissBehavior: vStyle?.keyboardDismissBehavior ??
                  ScrollViewKeyboardDismissBehavior.manual,
              restorationId: vStyle?.restorationId,
              padding: vStyle?.padding,
              // primary: vStyle?.primary,
              physics: vStyle?.physics,
              scrollDirection: Axis.vertical,
              controller: verticalScrollController,
              child: SingleChildScrollView(
                reverse: hStyle?.reverse ?? false,
                clipBehavior: hStyle?.clipBehavior ?? Clip.hardEdge,
                dragStartBehavior:
                    hStyle?.dragStartBehavior ?? DragStartBehavior.start,
                keyboardDismissBehavior: hStyle?.keyboardDismissBehavior ??
                    ScrollViewKeyboardDismissBehavior.manual,
                restorationId: hStyle?.restorationId,
                padding: hStyle?.padding,
                // primary: hStyle?.primary,
                physics: hStyle?.physics,
                scrollDirection: Axis.horizontal,
                controller: horizontalScrollController,
                child: widget.child ?? Container(),
              ),
            ),
          ),

          ///Custom Scroll track
          _viewport == _maxExtent
              ? const SizedBox(
                  width: 0,
                  height: 0,
                )
              : _track(bar: hBar!),

          ///Custom scroll thumb
          _viewport == _maxExtent
              ? const SizedBox(
                  width: 0,
                  height: 0,
                )
              : _thumbButton(thumb: hBar!),
        ],
      ),
    );
  }

  /// get  ratio by fullSize/(visibleSize-thumbSize)
  double get ratio => (horizontalScrollController.position.maxScrollExtent /
      (horizontalScrollController.position.viewportDimension - _thumbSize));

  ///get ThumbSize = (viewPortSize / maxExtent - minExtent + viewPortSize) * trackLength
  double get _thumbSize {
    double size = (horizontalScrollController.position.viewportDimension /
            (horizontalScrollController.position.maxScrollExtent -
                horizontalScrollController.position.minScrollExtent +
                horizontalScrollController.position.viewportDimension)) *
        horizontalScrollController.position.viewportDimension;
    if (size < 55) {
      return 55.0;
    } else {
      return size;
    }
  }

  double get viewPort => horizontalScrollController.position.viewportDimension;

  double get virtualTotalSize =>
      horizontalScrollController.position.maxScrollExtent;

  double jumpTo(delta) => (delta * ratio) + horizontalScrollController.offset;

  double get trackLength => _trackKey.currentContext!.size!.width;

  @Deprecated(' Will stop  working from next version')
  bool get isControllerLoaded =>
      horizontalScrollController.position.maxScrollExtent.toString().isNotEmpty
          ? true
          : false;

  void _onDrag(DragUpdateDetails a) {
    if (kDebugMode) {
      print('thumbCurrentPosition: ${thumbCurrentPosition!}');
    }
    setState(() {
      if (0 <= thumbCurrentPosition! &&
          thumbCurrentPosition! <= viewPort - _thumbSize) {
        thumbCurrentPosition = thumbCurrentPosition! + a.delta.dx;
        if (thumbCurrentPosition! != 0 ||
            thumbCurrentPosition! != viewPort - _thumbSize) {
          horizontalScrollController.jumpTo(thumbCurrentPosition! * ratio);
          if (kDebugMode) {
            print('Jumpto:${thumbCurrentPosition! * ratio}');
          }
        }
      }
      if (0 > thumbCurrentPosition!) {
        thumbCurrentPosition = 0;
      } else if (thumbCurrentPosition! > viewPort - _thumbSize) {
        thumbCurrentPosition = viewPort - _thumbSize;
      }
    });
  }

  Widget _thumbButton({required CrossScrollBar thumb}) {
    double? _height() =>
        thumb.trackVisibility == true || thumb.showTrackOnHover == true
            ? _onHoverTrack
                ? thumb.hoverThickness
                : thumb.thickness
            : thumb.thickness;

    Widget posi = Positioned(
      bottom: 1,
      left: thumbCurrentPosition,
      child: SizedBox(
          height: _height(),
          width: _thumbWidth < 55 ? 55 : _thumbWidth,
          child: GestureDetector(
            // onTapDown: (tip) =>fingerTip= tip.localPosition.dx,
            onHorizontalDragUpdate: _onDrag,
            child: InkWell(
              onHover: (hover) {
                setState(() {
                  _onHoverTrack = hover;
                });
              },
              autofocus: true,
              enableFeedback: true,
              excludeFromSemantics: true,
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: _thumbRadius(bar: thumb, hover: _onHoverTrack),
                  color: _thumbColor(bar: thumb, hover: _onHoverTrack),
                ),
              ),
            ),
          )),
    );

    return posi;
  }

  BorderRadiusGeometry _thumbRadius(
      {required CrossScrollBar bar, required bool hover}) {
    return BorderRadius.all(Radius.elliptical(
        bar.radius?.x ?? (bar.thickness ?? 14),
        bar.radius?.y ?? (bar.thickness ?? 14)));
  }

  Widget _track({
    required CrossScrollBar bar,
  }) {
    bool? _isTV = bar.trackVisibility;
    bool? _isSTOnHover = bar.showTrackOnHover;
    bool? _isAlwaysShown = bar.isAlwaysShown;

    Widget _value;
    Widget _trackWidget({
      bool isOnTapScroll = true,
      required Color color,
      required Color borderColor,
      double paddingVert = 2,
    }) =>
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTapDown: isOnTapScroll ? onTrackClick : null,
            child: InkWell(
              onHover: (hover) => setState(() => _onHoverTrack = hover),
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                // margin: const EdgeInsets.symmetric(vertical: 3.0),
                padding: EdgeInsets.symmetric(vertical: paddingVert),
                decoration: BoxDecoration(
                    color: color,
                    border: Border(
                        top: BorderSide(width: 0.8, color: borderColor))),
                key: _trackKey,

                height: _onHoverTrack
                    ? bar.hoverThickness! + 3
                    : bar.thickness! + 3,
              ),
            ),
          ),
        );
    if (_isTV!) {
      ///Always Visible
      _value = _trackWidget(
        borderColor: Colors.black.withOpacity(0.0851),
        color: bar.trackVisibility != null
            ? bar.trackVisibility!
                ? Colors.black.withOpacity(0.03)
                : Colors.black.withOpacity(0.00)
            : Colors.transparent,
      );
    } else {
      if (_isSTOnHover!) {
        ///Visible On Hover
        ///
        _value = _trackWidget(
            color: _onHoverTrack
                ? Colors.black.withOpacity(0.03)
                : Colors.transparent,
            borderColor: _isAlwaysShown!
                ? _onHoverTrack
                    ? Colors.black.withOpacity(0.0851)
                    : Colors.black.withOpacity(0.00)
                : _onHoverTrack
                    ? Colors.black.withOpacity(0.0851)
                    : Colors.black.withOpacity(0.00));
      } else {
        ///Don't Show Track
        _value = _trackWidget(
          color: const Color.fromARGB(0, 0, 0, 0),
          borderColor: const Color.fromARGB(0, 0, 0, 0),
        );
      }
    }
    return _value;
  }

  Color _thumbColor({
    required CrossScrollBar bar,
    required bool hover,
    Color fullColor = const Color.fromARGB(239, 16, 16, 16),
    // Color middleColor = const Color.fromARGB(155, 17, 17, 17),
  }) {
    bool trackVisibility = bar.trackVisibility ?? false;

    Color? color;
    if (bar.isAlwaysShown != null) {
      bar.isAlwaysShown!
          ? trackVisibility
              ?

              ///When [trackVisibility] is true
              ///The hover will be ignored

              color = widget.hoverColor ?? fullColor
              :

              ///When [trackVisibility] is false
              hover

                  ///Show Thumb Full Color on Hover when [isAlwaysShown]  is true
                  ? color = widget.hoverColor ?? fullColor

                  ///Show Half Color When not Hovered when [isAlwaysShown]  is true
                  : color =
                      widget.idleColor ?? const Color.fromARGB(118, 17, 17, 17)
          : hover

              ///Show Thumb Full Color on Hover when [isAlwaysShown]  is false
              ? color = widget.hoverColor ?? fullColor

              ///Don't show Thumb when not Hovered
              : color = const Color(0x00111111);
    } else {
      hover
          ? color = fullColor

          ///Show Thumb Full Color on Hover
          : color = const Color(0x00111111);

      ///Don't show Thumb when not Hovered
    }
    return color;
  }

  void onTrackClick(TapDownDetails tapDownDetails) {
    if (kDebugMode) {
      // print('thumbCurrentPosition: $thumbCurrentPosition');
      // print('tapDownDetails.dx: ${tapDownDetails.localPosition.dx}');
    }
    double _trackLengthfromThumbPoint = thumbCurrentPosition! + _thumbWidth;

    setState(() {
      if (tapDownDetails.localPosition.dx > thumbCurrentPosition!) {
        if (_trackLengthfromThumbPoint < _viewport - _thumbWidth) {
          // print('+ive\nless than _viewport - _thumbWidth');

          thumbCurrentPosition = thumbCurrentPosition! + _thumbWidth;
          horizontalScrollController.animateTo(thumbCurrentPosition! * ratio,
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        } else {
          // print('+ive\ngreater than _viewport - _thumbWidth');

          thumbCurrentPosition = _viewport - _thumbWidth;
          horizontalScrollController.animateTo(thumbCurrentPosition! * ratio,
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        }
      } else if (tapDownDetails.localPosition.dx < thumbCurrentPosition!) {
        if (thumbCurrentPosition! > _thumbWidth) {
          // print('_crnt$_crnt');
          // print('_thumbWidth$_thumbWidth');
          // print('-ive\ngreater than thumb');
          thumbCurrentPosition = thumbCurrentPosition! - _thumbWidth;
          horizontalScrollController.animateTo(thumbCurrentPosition! * ratio,
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        } else if (thumbCurrentPosition! < _thumbWidth) {
          // print('-ive\nless than thumb');
          thumbCurrentPosition = 0;
          horizontalScrollController.animateTo(thumbCurrentPosition! * ratio,
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        }
      }
    });
  }

  void keepThumbInRangeWhileResizingScreen() {
    if (thumbCurrentPosition! > viewPort - _thumbSize) {
      thumbCurrentPosition = viewPort - _thumbSize;
      horizontalScrollController.jumpTo(thumbCurrentPosition! * ratio);
    }
  }

  void initializeControllerValues() {
    fullHeight = horizontalScrollController.position.maxScrollExtent;
    _maxExtent = (horizontalScrollController.position.viewportDimension +
        horizontalScrollController.position.maxScrollExtent);
    _viewport = horizontalScrollController.position.viewportDimension;
    _thumbWidth = _thumbSize;
  }
}
