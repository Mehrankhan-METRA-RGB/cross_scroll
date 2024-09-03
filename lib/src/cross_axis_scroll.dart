import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'cross_scroll_decor.dart';
import 'cross_scroll_track.dart';

///This code has been design by [Mehran Ullah]
///email: m.jan9396@gmail.com,

// class Thumb {
//   Thumb({this.currentPosition, this.visibility = true, this.thumbWidth});
//   final double? currentPosition;
//   final double? thumbWidth;
//   final bool visibility;
// }

class CrossScroll extends StatefulWidget {
  ///CrossScroll is a Widget that can scroll on multiple directions and
  ///support all properties of [SingleChildScrollView].
  ///Keep [isAlwaysShown:true] while design for Android or IOS so you will
  ///be able to see your thumb position on screen while scrolling with onDrag property
  ///i.e: CrossScrollBar(
  ///         showTrackOnHover: false,
  ///         trackVisibility: false,
  ///         isAlwaysShown: true),
  const CrossScroll(
      {this.child,
      this.verticalScroll,
      this.horizontalScroll,
      this.horizontalScrollController,
      this.verticalScrollController,
      this.dimColor,
      this.normalColor,
      this.hoverColor,
      this.horizontalBar = const CrossScrollTrack(),
      this.verticalBar = const CrossScrollTrack(),
      Key? key})
      : super(key: key);
  final Widget? child;

  ///Modify vertical scrolls
  final CrossScrollDesign? verticalScroll;

  ///Modify horizontal scrolls
  final CrossScrollDesign? horizontalScroll;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
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
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).

  final ScrollController? verticalScrollController;

  ///Modify Vertical scroll thumb and track
  final CrossScrollTrack? verticalBar;

  ///Modify horizontal scroll thumb and track
  final CrossScrollTrack? horizontalBar;

  ///Shown this color when you hovered over a thumb
  ///
  ///when [hoverColor] is null and [CrossScrollBar(thumb:ScrollThumb.hoverShow)] then [normalColor] will be assign to [hoverColor] if [normalColor] not null.
  final Color? hoverColor;

  ///Normal thumb color
  final Color? normalColor;

  ///dim Color
  final Color? dimColor;

  @override
  State<CrossScroll> createState() => _CrossScrollState();
}

class _CrossScrollState extends State<CrossScroll> {
  // final ScrollController _horScrollController = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController verticalScrollController = ScrollController();
  // final StreamController<Thumb> _streamController = StreamController<Thumb>();

  double? width = 0;
  double? height = 0;
  double previousWidth = 0;
  double previousHeight = 0;
  double? horizontalFullSize = 0;
  double? verticalFullSize = 0;

  final _horizontalTrackKey = GlobalKey();
  final _verticalTrackKey = GlobalKey();

  bool _onHoverHorizontalTrack = false;
  bool _onHoverVerticalTrack = false;

  double? horizontalThumbCurrentPosition = 0;
  double? verticalThumbCurrentPosition = 0;

  double _horizontalViewPort = 0;
  double _verticalViewPort = 0;
  double _horizontalMaxExtent = 0.1;
  double _verticalMaxExtent = 0.1;
  double _horizontalThumbWidth = 55;
  double _verticalThumbWidth = 55;

  ///This method update thumb position while scrolling,
  /// Platforms [Android and IOS]
  updateThumbPositionWithScroll(Axis orientation) {
    ScrollController controller = getController(orientation);
    // print(controller.position.pixels);
    setState(() {
      if (orientation == Axis.horizontal) {
        horizontalThumbCurrentPosition =
            (controller.offset) / ratio(orientation);
      } else {
        verticalThumbCurrentPosition =
            (controller.position.pixels) / ratio(orientation);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.horizontalScrollController != null
        ? widget.horizontalScrollController
            ?.addListener(() => updateThumbPositionWithScroll(Axis.horizontal))
        : horizontalScrollController
            .addListener(() => updateThumbPositionWithScroll(Axis.horizontal));

    widget.verticalScrollController != null
        ? widget.verticalScrollController
            ?.addListener(() => updateThumbPositionWithScroll(Axis.vertical))
        : verticalScrollController
            .addListener(() => updateThumbPositionWithScroll(Axis.vertical));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.horizontalScrollController != null
        ? widget.horizontalScrollController?.dispose()
        : horizontalScrollController.dispose();
    widget.verticalScrollController != null
        ? widget.verticalScrollController?.dispose()
        : verticalScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    // setState(() {
    //   print(horizontalScrollController.offset-_thumbSize);
    //
    // });

// thumbCurrentPosition=widget.horizontalScrollController?.offset??horizontalScrollController.offset;

    ///Here i comment out (width != previousWidth || height != previousHeight) because of the issue
    /// https://github.com/Mehrankhan-METRA-RGB/cross_scroll/issues/5#issue-1596328845
//     if (width != previousWidth || height != previousHeight) {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          initializeControllerValues(Axis.vertical);
          initializeControllerValues(Axis.horizontal);
          keepThumbInRangeWhileResizingScreen(Axis.vertical);
          keepThumbInRangeWhileResizingScreen(Axis.horizontal);
        });
      }
    });
    previousHeight = height!;
    previousWidth = width!;
    // }

    CrossScrollTrack? vBar = widget.verticalBar;
    CrossScrollDesign? vStyle = widget.verticalScroll;
    CrossScrollTrack? hBar = widget.horizontalBar;
    CrossScrollDesign? hStyle = widget.horizontalScroll;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              clipBehavior: vStyle?.clipBehavior ?? Clip.hardEdge,
              dragStartBehavior: DragStartBehavior.start,
              keyboardDismissBehavior: vStyle?.keyboardDismissBehavior ??
                  ScrollViewKeyboardDismissBehavior.manual,
              restorationId: vStyle?.restorationId,
              padding: vStyle?.padding,
              // primary: vStyle?.primary,
              physics: vStyle?.physics,
              scrollDirection: Axis.vertical,
              controller:
                  widget.verticalScrollController ?? verticalScrollController,
              child: SingleChildScrollView(
                clipBehavior: hStyle?.clipBehavior ?? Clip.hardEdge,
                dragStartBehavior: DragStartBehavior.start,
                keyboardDismissBehavior: hStyle?.keyboardDismissBehavior ??
                    ScrollViewKeyboardDismissBehavior.manual,
                restorationId: hStyle?.restorationId,
                padding: hStyle?.padding,
                // primary: hStyle?.primary,
                physics: hStyle?.physics,
                scrollDirection: Axis.horizontal,
                controller: widget.horizontalScrollController ??
                    horizontalScrollController,
                child: widget.child ?? Container(),
              ),
            ),
          ),

          ///Horizontal Scroll track
          _horizontalViewPort == _horizontalMaxExtent
              ? const SizedBox(
                  width: 0,
                  height: 0,
                )
              : _scrollTrack(
                  bar: hBar!,
                  orientation: Axis.horizontal,
                ),

          ///Horizontal scroll thumb
          _horizontalViewPort == _horizontalMaxExtent
              ? const SizedBox(
                  width: 0,
                  height: 0,
                )
              : _scrollThumb(thumb: hBar!, orientation: Axis.horizontal),

          ///Vertical Scroll track
          _verticalViewPort == _verticalMaxExtent
              ? const SizedBox(
                  width: 0,
                  height: 0,
                )
              : _scrollTrack(
                  bar: vBar!,
                  orientation: Axis.vertical,
                ),

          ///Vertical scroll thumb
          _verticalViewPort == _verticalMaxExtent
              ? const SizedBox(
                  width: 0,
                  height: 0,
                )
              : _scrollThumb(thumb: vBar!, orientation: Axis.vertical),
        ],
      ),
    );
  }

  /// get  ratio by fullSize/(visibleSize-thumbSize)
  double ratio(Axis orientation) {
    ScrollController? controller;
    if (orientation == Axis.horizontal) {
      controller =
          widget.horizontalScrollController ?? horizontalScrollController;
    } else {
      controller = widget.verticalScrollController ?? verticalScrollController;
    }
    return (controller.position.maxScrollExtent /
        (controller.position.viewportDimension - _thumbSize(orientation)));
  }

  ///get ThumbSize = (viewPortSize / maxExtent - minExtent + viewPortSize) * trackLength
  double _thumbSize(Axis orientation) {
    ScrollController? _controller = getController(orientation);

    double _size = (_controller.position.viewportDimension /
            (_controller.position.maxScrollExtent -
                _controller.position.minScrollExtent +
                _controller.position.viewportDimension)) *
        _controller.position.viewportDimension;

    if (_size < 55) {
      return 55.0;
    } else {
      return _size;
    }
  }

  double viewPort(Axis orientation) {
    ScrollController? _controller = getController(orientation);
    return _controller.position.viewportDimension;
  }

  double virtualTotalSize(Axis orientation) {
    ScrollController? _controller = getController(orientation);
    return _controller.position.maxScrollExtent;
  }

  double jumpTo(delta, Axis orientation) {
    ScrollController _controller = getController(orientation);
    return (delta * ratio) + _controller.offset;
  }

  double trackLength(Axis orientation) {
    return orientation == Axis.horizontal
        ? _horizontalTrackKey.currentContext!.size!.width
        : _verticalTrackKey.currentContext!.size!.width;
  }

  void _onDrag(DragUpdateDetails a, {required Axis orientation}) {
    // if (kDebugMode) {
    //   // print('thumbCurrentPosition: ${thumbCurrentPosition!}');
    // }
    if (orientation == Axis.horizontal) {
      ///horizontal

      if (0 > horizontalThumbCurrentPosition!) {
        horizontalThumbCurrentPosition = 0;
      } else if (horizontalThumbCurrentPosition! >
          viewPort(orientation) - _thumbSize(orientation)) {
        horizontalThumbCurrentPosition =
            viewPort(orientation) - _thumbSize(orientation);
      } else if (0 <= horizontalThumbCurrentPosition! &&
          horizontalThumbCurrentPosition! <=
              viewPort(orientation) - _thumbSize(orientation)) {
        horizontalThumbCurrentPosition =
            horizontalThumbCurrentPosition! + a.delta.dx;
        if (horizontalThumbCurrentPosition! != 0 ||
            horizontalThumbCurrentPosition! !=
                viewPort(orientation) - _thumbSize(orientation)) {
          getController(orientation)
              .jumpTo(horizontalThumbCurrentPosition! * ratio(orientation));
          // if (kDebugMode) {
          //   print('JumpTo:${thumbCurrentPosition! * ratio}');
          // }
        }
      }
    } else {
      ///vertical
      print(a.delta.dy);
      if (verticalThumbCurrentPosition! < 0) {
        verticalThumbCurrentPosition = 0;
      } else if (verticalThumbCurrentPosition! >
          viewPort(orientation) - _thumbSize(orientation)) {
        verticalThumbCurrentPosition =
            viewPort(orientation) - _thumbSize(orientation);
      } else if (verticalThumbCurrentPosition! >= 0 &&
          verticalThumbCurrentPosition! <=
              viewPort(orientation) - _thumbSize(orientation)) {
        verticalThumbCurrentPosition =
            verticalThumbCurrentPosition! + a.delta.dy;
        if (verticalThumbCurrentPosition! != 0 ||
            verticalThumbCurrentPosition! !=
                viewPort(orientation) - _thumbSize(orientation)) {
          getController(orientation)
              .jumpTo(verticalThumbCurrentPosition! * ratio(orientation));
        }
      }
    }
  }

  void onTrackClick(TapDownDetails tapDownDetails,
      {required Axis orientation}) {
    print(tapDownDetails.localPosition.dy);
    // print(verticalThumbCurrentPosition);
    // print(_verticalThumbWidth);

    ScrollController _hController =
        widget.horizontalScrollController ?? horizontalScrollController;
    ScrollController _vController =
        widget.verticalScrollController ?? verticalScrollController;

    double _horizontalTrackLengthFromThumbPoint =
        horizontalThumbCurrentPosition! + _horizontalThumbWidth;
    double _verticalTrackLengthFromThumbPoint =
        verticalThumbCurrentPosition! + _verticalThumbWidth;

    if (orientation == Axis.horizontal) {
      ///horizontal track
      if (tapDownDetails.localPosition.dx > horizontalThumbCurrentPosition!) {
        if (_horizontalTrackLengthFromThumbPoint <
            _horizontalViewPort - _horizontalThumbWidth) {
          // print('+ive\nless than _viewport - _thumbWidth');

          horizontalThumbCurrentPosition =
              horizontalThumbCurrentPosition! + _horizontalThumbWidth;
          _hController.animateTo(
              horizontalThumbCurrentPosition! * ratio(orientation),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        } else {
          horizontalThumbCurrentPosition =
              _horizontalViewPort - _horizontalThumbWidth;
          _hController.animateTo(
              horizontalThumbCurrentPosition! * ratio(orientation),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        }
      } else if (tapDownDetails.localPosition.dx <
          horizontalThumbCurrentPosition!) {
        if (horizontalThumbCurrentPosition! > _horizontalThumbWidth) {
          // print('_crnt$_crnt');
          // print('_thumbWidth$_thumbWidth');
          // print('-ive\ngreater than thumb');
          horizontalThumbCurrentPosition =
              horizontalThumbCurrentPosition! - _horizontalThumbWidth;
          _hController.animateTo(
              horizontalThumbCurrentPosition! * ratio(orientation),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        } else if (horizontalThumbCurrentPosition! < _horizontalThumbWidth) {
          // print('-ive\nless than thumb');
          horizontalThumbCurrentPosition = 0;
          _hController.animateTo(
              horizontalThumbCurrentPosition! * ratio(orientation),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        }
      }
    } else {
      ///vertical track
      if (tapDownDetails.localPosition.dy > verticalThumbCurrentPosition!) {
        if (_verticalTrackLengthFromThumbPoint <
            _verticalViewPort - _verticalThumbWidth) {
          // print('+ive\nless than _viewport - _thumbWidth');

          verticalThumbCurrentPosition =
              verticalThumbCurrentPosition! + _verticalThumbWidth;
          _vController.animateTo(
              verticalThumbCurrentPosition! * ratio(orientation),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        } else {
          verticalThumbCurrentPosition =
              _verticalViewPort - _verticalThumbWidth;
          _vController.animateTo(
              verticalThumbCurrentPosition! * ratio(orientation),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        }
      } else if (tapDownDetails.localPosition.dy <
          verticalThumbCurrentPosition!) {
        if (verticalThumbCurrentPosition! > _verticalThumbWidth) {
          // print('_crnt$_crnt');
          // print('_thumbWidth$_thumbWidth');
          // print('-ive\ngreater than thumb');
          verticalThumbCurrentPosition =
              verticalThumbCurrentPosition! - _verticalThumbWidth;
          _vController.animateTo(
              verticalThumbCurrentPosition! * ratio(orientation),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        } else if (verticalThumbCurrentPosition! < _verticalThumbWidth) {
          // print('-ive\nless than thumb');
          verticalThumbCurrentPosition = 0;
          _vController.animateTo(
              verticalThumbCurrentPosition! * ratio(orientation),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        }
      }
    }
  }

  void keepThumbInRangeWhileResizingScreen(Axis orientation) {
    bool _isHorizontal = orientation == Axis.horizontal ? true : false;
    double _thumbCurrentPosition = _isHorizontal
        ? horizontalThumbCurrentPosition!
        : verticalThumbCurrentPosition!;
    if (_thumbCurrentPosition >
        viewPort(orientation) - _thumbSize(orientation)) {
      _thumbCurrentPosition = viewPort(orientation) - _thumbSize(orientation);
      getController(orientation)
          .jumpTo(_thumbCurrentPosition * ratio(orientation));
    }
  }

  void initializeControllerValues(Axis orientation) {
    bool _isHorizontal = orientation == Axis.horizontal ? true : false;
    ScrollController _controller = getController(orientation);
    if (_isHorizontal) {
      ///horizontal
      horizontalFullSize = _controller.position.maxScrollExtent;
      _horizontalMaxExtent = (_controller.position.viewportDimension +
          _controller.position.maxScrollExtent);
      _horizontalViewPort = _controller.position.viewportDimension;
      _horizontalThumbWidth = _thumbSize(orientation);
    } else {
      ///Vertical
      verticalFullSize = _controller.position.maxScrollExtent;
      _verticalMaxExtent = (_controller.position.viewportDimension +
          _controller.position.maxScrollExtent);
      _verticalViewPort = _controller.position.viewportDimension;
      _verticalThumbWidth = _thumbSize(orientation);
    }
  }

  ScrollController getController(Axis orientation) {
    return orientation == Axis.vertical
        ? widget.verticalScrollController ?? verticalScrollController
        : widget.horizontalScrollController ?? horizontalScrollController;
  }

  BorderRadiusGeometry _thumbRadius(
      {required CrossScrollTrack bar,
      required bool hover,
      required Axis orientation}) {
    return BorderRadius.all(Radius.elliptical(
        bar.thumbRadius?.x ?? bar.thickness ?? 8,
        bar.thumbRadius?.y ?? bar.thickness ?? 8));
  }

  Color _thumbColor(
    BuildContext context, {
    required CrossScrollTrack bar,
    required bool hover,
    required Axis orientation,
  }) {
    ///called by Cross scroll constructor
    Color normalColor =
        widget.normalColor ?? const Color.fromARGB(228, 26, 26, 26);
    Color dimColor = widget.dimColor ?? const Color.fromARGB(159, 24, 24, 24);

    if (bar.thumb == ScrollThumb.hoverShow ||
        bar.track == ScrollTrackBehaviour.onHover) {
      return hover ? widget.hoverColor ?? normalColor : dimColor;
    } else if (bar.thumb == ScrollThumb.alwaysDim) {
      return dimColor;
    } else if (bar.thumb == ScrollThumb.alwaysShow) {
      return normalColor;
    } else {
      return normalColor;
    }
  }

  ///if no color provided, default colors will be assign
  ///
  ///[trackColor]??Colors.black.withOpacity(0.03);
  ///
  ///[noColor]??Colors.transparent;
  ///
  ///[borderColor]??Colors.black.withOpacity(0.0851);

  Widget _scrollTrack(
      {required CrossScrollTrack bar,
      required Axis orientation,
      Color? trackColor,
      Color? noColor,
      Color? borderColor}) {
    bool? _isHorizontal = Axis.horizontal == orientation ? true : false;

    Color _trackColor = trackColor ?? Colors.black.withOpacity(0.03);
    Color _noColor = noColor ?? Colors.transparent;
    Color _borderColor = borderColor ?? Colors.black.withOpacity(0.0851);

    Widget _trackWidget({
      bool isOnTapScroll = true,
      required Color color,
      required Color borderColor,
      double padding = 2,
    }) =>
        GestureDetector(
          onTapDown: (tapDown) => isOnTapScroll
              ? onTrackClick(tapDown, orientation: orientation)
              : null,
          child: InkWell(
            onHover: (hover) => setState(() => _isHorizontal
                ? _onHoverHorizontalTrack = hover
                : _onHoverVerticalTrack = hover),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: _isHorizontal ? padding : 0,
                  horizontal: !_isHorizontal ? padding : 0),
              decoration: BoxDecoration(
                  color: color,
                  border: Border(
                      left: !_isHorizontal
                          ? BorderSide(width: 0.8, color: borderColor)
                          : BorderSide(width: 0, color: Colors.transparent),
                      top: _isHorizontal
                          ? BorderSide(width: 0.8, color: borderColor)
                          : BorderSide(width: 0, color: Colors.transparent))),
              key: _isHorizontal ? _horizontalTrackKey : _verticalTrackKey,
              width: !_isHorizontal
                  ? _onHoverVerticalTrack
                      ? bar.hoverThickness! + padding * 1.4
                      : bar.thickness! + padding * 1.4
                  : null,
              height: _isHorizontal
                  ? _onHoverHorizontalTrack
                      ? bar.hoverThickness! + padding * 1.4
                      : bar.thickness! + padding * 1.4
                  : null,
            ),
          ),
        );

    /// orientation switch
    switch (orientation) {
      case Axis.vertical:

        ///track bar switch
        switch (bar.track) {
          case ScrollTrackBehaviour.onHover:
            return _trackWidget(
              color: _onHoverVerticalTrack ? _trackColor : _noColor,
              borderColor: _onHoverVerticalTrack ? _borderColor : _noColor,
            );

          case ScrollTrackBehaviour.show:
            return _trackWidget(
              color: _trackColor,
              borderColor: _borderColor,
            );
          case ScrollTrackBehaviour.hidden:
            return _trackWidget(
              color: _noColor,
              borderColor: _noColor,
            );
        }

      case Axis.horizontal:
        switch (bar.track) {
          case ScrollTrackBehaviour.onHover:
            return _trackWidget(
              color: _onHoverHorizontalTrack ? _trackColor : _noColor,
              borderColor: _onHoverHorizontalTrack ? _borderColor : _noColor,
            );

          case ScrollTrackBehaviour.show:
            return _trackWidget(
              color: _trackColor,
              borderColor: _borderColor,
            );
          case ScrollTrackBehaviour.hidden:
            return _trackWidget(
              color: _noColor,
              borderColor: _noColor,
            );
        }
    }
  }

  Widget _scrollThumb(
      {required CrossScrollTrack thumb, required Axis orientation}) {
    bool _isHorizontal = orientation == Axis.horizontal ? true : false;
    bool _trackHover =
        _isHorizontal ? _onHoverHorizontalTrack : _onHoverVerticalTrack;
    double? _thumbThickness() =>
        _trackHover ? thumb.hoverThickness : thumb.thickness;

    Widget position = Positioned(
      top: _isHorizontal ? null : verticalThumbCurrentPosition,
      bottom: _isHorizontal ? 1 : null,
      left: !_isHorizontal ? null : horizontalThumbCurrentPosition,
      right: !_isHorizontal ? 1 : null,
      child: SizedBox(
          height: _isHorizontal
              ? _thumbThickness()
              : _verticalThumbWidth < 55
                  ? 55
                  : _verticalThumbWidth,
          width: !_isHorizontal
              ? _thumbThickness()
              : _horizontalThumbWidth < 55
                  ? 55
                  : _horizontalThumbWidth,
          child: GestureDetector(
            // onTapDown: (tip) =>fingerTip= tip.localPosition.dx,
            onPanUpdate: (drag) => _onDrag(drag, orientation: orientation),
            child: InkWell(
              onHover: (hover) {
                setState(() {
                  _isHorizontal
                      ? _onHoverHorizontalTrack = hover
                      : _onHoverVerticalTrack = hover;
                });
              },
              autofocus: true,
              enableFeedback: true,
              excludeFromSemantics: true,
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: _thumbRadius(
                      bar: thumb,
                      hover: _isHorizontal
                          ? _onHoverHorizontalTrack
                          : _onHoverVerticalTrack,
                      orientation: orientation),
                  color: _thumbColor(context,
                      bar: thumb,
                      hover: _isHorizontal
                          ? _onHoverHorizontalTrack
                          : _onHoverVerticalTrack,
                      orientation: orientation),
                ),
              ),
            ),
          )),
    );

    return position;
  }
}
