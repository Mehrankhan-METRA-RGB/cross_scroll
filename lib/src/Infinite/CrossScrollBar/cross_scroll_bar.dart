import 'package:cross_scroll/cross_scroll.dart';
import 'package:cross_scroll/src/Components/cross_scroll_thumb.dart';
import 'package:cross_scroll/src/Components/cross_track.dart';
import 'package:flutter/material.dart';

class CrossScrollBar extends StatefulWidget {
  const CrossScrollBar(
      {required this.controller,
      required this.child,
      this.decoration = const CrossScrollTrack(),
      this.trackBehaviour = ScrollTrackBehaviour.onHover,
      this.trackAppearance = TrackAppearance.BOTTOM_RIGHT,
      super.key});
  final Widget child;
  final CrossScrollController controller;
  final TrackAppearance trackAppearance;
  final CrossScrollTrack decoration;
  final ScrollTrackBehaviour trackBehaviour;
  @override
  State<CrossScrollBar> createState() => _CrossScrollBarState();
}

class _CrossScrollBarState extends State<CrossScrollBar> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ScrollBar:initState");
  }

  @override
  void didUpdateWidget(covariant CrossScrollBar oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("ScrollBar:didUpdateWidget");
    widget.controller.hCont.addListener(() {
      updateThumbPositionWithScroll(Axis.horizontal);
    });
    widget.controller.vCont.addListener(() {
      updateThumbPositionWithScroll(Axis.vertical);
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("ScrollBar:didChangeDependencies");
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    Future.delayed(Duration.zero, () {
      setState(() {
        initializeControllerValues(Axis.vertical);
        initializeControllerValues(Axis.horizontal);
        keepThumbInRangeWhileResizingScreen(Axis.vertical);
        keepThumbInRangeWhileResizingScreen(Axis.horizontal);
      });
    });
    previousHeight = height!;
    previousWidth = width!;
    return Stack(
      children: [
        widget.child,

        CrossTrack(
          width: widget.decoration.thickness,
          height: height,
          onTrackClick: (click) =>
              onTrackClick(click, orientation: Axis.vertical),
          axis: Axis.vertical,
          color: Colors.black12,
          appearance: widget.trackAppearance,
          behaviour: widget.trackBehaviour,
        ),

        ///Vertical TRACK
        CrossScrollThumb(
          thumb: widget.decoration,
          appearance: widget.trackAppearance,
          axis: Axis.vertical,
          position: verticalThumbCurrentPosition,
          thumbLength: _verticalThumbWidth,
          onDrag: (DragUpdateDetails a) =>
              _onDrag(a, orientation: Axis.vertical),
        ),

        CrossTrack(
          width: width,
          height: widget.decoration.thickness,
          onTrackClick: (click) =>
              onTrackClick(click, orientation: Axis.horizontal),
          color: Colors.black12,
          behaviour: widget.trackBehaviour,
          axis: Axis.horizontal,
          appearance: widget.trackAppearance,
        ),

        ///Horizontal Track
        CrossScrollThumb(
          thumb: widget.decoration,
          axis: Axis.horizontal,
          appearance: widget.trackAppearance,
          position: horizontalThumbCurrentPosition,
          thumbLength: _horizontalThumbWidth,
          onDrag: (DragUpdateDetails a) =>
              _onDrag(a, orientation: Axis.horizontal),
        ),
      ],
    );
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
          widget.controller
              .jumpXTo(horizontalThumbCurrentPosition! * ratio(orientation));

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
          widget.controller
              .jumpYTo(verticalThumbCurrentPosition! * ratio(orientation));
        }
      }
    }
  }

  void onTrackClick(TapDownDetails tapDownDetails,
      {required Axis orientation}) {
    print(tapDownDetails.localPosition.dy);
    // print(verticalThumbCurrentPosition);
    // print(_verticalThumbWidth);

    // ScrollController _hController =
    //     widget.horizontalScrollController ?? horizontalScrollController;
    // ScrollController _vController =
    //     widget.verticalScrollController ?? verticalScrollController;

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
          widget.controller
              .animateXTo(horizontalThumbCurrentPosition! * ratio(orientation),
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  curve: Curves.linear);
        } else {
          horizontalThumbCurrentPosition =
              _horizontalViewPort - _horizontalThumbWidth;
          widget.controller
              .animateXTo(horizontalThumbCurrentPosition! * ratio(orientation),
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
          widget.controller
              .animateXTo(horizontalThumbCurrentPosition! * ratio(orientation),
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  curve: Curves.linear);
        } else if (horizontalThumbCurrentPosition! < _horizontalThumbWidth) {
          // print('-ive\nless than thumb');
          horizontalThumbCurrentPosition = 0;
          widget.controller
              .animateXTo(horizontalThumbCurrentPosition! * ratio(orientation),
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
          widget.controller
              .animateYTo(verticalThumbCurrentPosition! * ratio(orientation),
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  curve: Curves.linear);
        } else {
          verticalThumbCurrentPosition =
              _verticalViewPort - _verticalThumbWidth;
          widget.controller
              .animateYTo(verticalThumbCurrentPosition! * ratio(orientation),
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
          widget.controller
              .animateYTo(verticalThumbCurrentPosition! * ratio(orientation),
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  curve: Curves.linear);
        } else if (verticalThumbCurrentPosition! < _verticalThumbWidth) {
          // print('-ive\nless than thumb');
          verticalThumbCurrentPosition = 0;
          widget.controller
              .animateYTo(verticalThumbCurrentPosition! * ratio(orientation),
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  curve: Curves.linear);
        }
      }
    }
  }

  ///The extent of the viewport along the axisDirection.
  /// Copied from ScrollMetrics.
  double viewPort(Axis orientation) {
    if (orientation == Axis.horizontal)
      return widget.controller.xPosition.viewportDimension;
    else
      return widget.controller.yPosition.viewportDimension;
  }

  ///This method update thumb position while scrolling,
  /// Platforms [Android and IOS]
  void updateThumbPositionWithScroll(Axis orientation) {
    // print(controller.position.pixels);
    // setState(() {
    if (orientation == Axis.horizontal) {
      widget.controller.hCont.addListener(() {
        setState(() {
          horizontalThumbCurrentPosition =
              (widget.controller.offsetX) / ratio(orientation);
        });
      });
    } else {
      widget.controller.vCont.addListener(() {
        setState(() {
          verticalThumbCurrentPosition =
              (widget.controller.offsetY) / ratio(orientation);
        });
      });
    }

    // verticalThumbCurrentPosition =
    //     (widget.controller.yPosition.pixels) / ratio(orientation);
    // }
    // });
  }

  /// get  ratio by fullSize/(visibleSize-thumbSize)
  double ratio(Axis orientation) {
    double ratio = 1;
    if (orientation == Axis.horizontal) {
      ratio = (widget.controller.xPosition.maxScrollExtent /
          (widget.controller.xPosition.viewportDimension -
              _thumbSize(orientation)));
    } else {
      ratio = (widget.controller.yPosition.maxScrollExtent /
          (widget.controller.yPosition.viewportDimension -
              _thumbSize(orientation)));
    }
    return ratio;
  }

  ///get ThumbSize = (viewPortSize / maxExtent - minExtent + viewPortSize) * trackLength
  double _thumbSize(Axis orientation) {
    double _size = 1;

    if (orientation == Axis.horizontal)
      _size = (widget.controller.xPosition.viewportDimension /
              (widget.controller.xPosition.maxScrollExtent -
                  widget.controller.xPosition.minScrollExtent +
                  widget.controller.xPosition.viewportDimension)) *
          widget.controller.xPosition.viewportDimension;
    else
      _size = (widget.controller.yPosition.viewportDimension /
              (widget.controller.yPosition.maxScrollExtent -
                  widget.controller.yPosition.minScrollExtent +
                  widget.controller.yPosition.viewportDimension)) *
          widget.controller.yPosition.viewportDimension;

    if (_size < 55)
      return 55.0;
    else
      return _size;
  }

  void keepThumbInRangeWhileResizingScreen(Axis orientation) {
    bool _isHorizontal = orientation == Axis.horizontal ? true : false;
    double _thumbCurrentPosition = _isHorizontal
        ? horizontalThumbCurrentPosition!
        : verticalThumbCurrentPosition!;
    if (_thumbCurrentPosition >
        viewPort(orientation) - _thumbSize(orientation)) {
      _thumbCurrentPosition = viewPort(orientation) - _thumbSize(orientation);
      if (_isHorizontal)
        widget.controller.jumpXTo(_thumbCurrentPosition * ratio(orientation));
      else
        widget.controller.jumpXTo(_thumbCurrentPosition * ratio(orientation));
    }
  }

  void initializeControllerValues(Axis orientation) {
    bool _isHorizontal = orientation == Axis.horizontal ? true : false;

    if (_isHorizontal) {
      ///horizontal
      horizontalFullSize = widget.controller.xPosition.maxScrollExtent;
      _horizontalMaxExtent = (widget.controller.xPosition.viewportDimension +
          widget.controller.xPosition.maxScrollExtent);
      _horizontalViewPort = widget.controller.xPosition.viewportDimension;
      _horizontalThumbWidth = _thumbSize(orientation);
    } else {
      ///Vertical
      verticalFullSize = widget.controller.yPosition.maxScrollExtent;
      _verticalMaxExtent = (widget.controller.yPosition.viewportDimension +
          widget.controller.yPosition.maxScrollExtent);
      _verticalViewPort = widget.controller.yPosition.viewportDimension;
      _verticalThumbWidth = _thumbSize(orientation);
    }
  }
}

///Horizontal_Vertical
enum TrackAppearance { TOP_LEFT, BOTTOM_LEFT, TOP_RIGHT, BOTTOM_RIGHT }
