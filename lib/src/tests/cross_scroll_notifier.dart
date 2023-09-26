import 'package:flutter/widgets.dart';

class CrossScrollNotifier extends ChangeNotifier {
  double? _width = 0;
  double? _height = 0;
  double? _horizontalFullSize = 0;
  double? _verticalFullSize = 0;
  double? _horizontalThumbCurrentPosition = 0;
  double? _verticalThumbCurrentPosition = 0;
  double _previousWidth = 0;
  double _previousHeight = 0;
  bool _onHoverHorizontalTrack = false;
  bool _onHoverVerticalTrack = false;
  double _horizontalViewPort = 0;
  double _verticalViewPort = 0;
  double _horizontalMaxExtent = 0.1;
  double _verticalMaxExtent = 0.1;
  double _horizontalThumbWidth = 55;
  double _verticalThumbWidth = 55;

  ScrollController _horizontalScrollController = ScrollController();
  ScrollController _verticalScrollController = ScrollController();
  GlobalKey _horizontalTrackKey = GlobalKey();
  GlobalKey _verticalTrackKey = GlobalKey();

  GlobalKey get horizontalTrackKey => _horizontalTrackKey;

  ScrollController get horizontalScrollController =>
      _horizontalScrollController;

  ScrollController get verticalScrollController => _verticalScrollController;

  double? get width => _width;

  double? get height => _height;

  double? get horizontalFullSize => _horizontalFullSize;

  double? get verticalFullSize => _verticalFullSize;

  double? get horizontalThumbCurrentPosition => _horizontalThumbCurrentPosition;

  double get verticalThumbWidth => _verticalThumbWidth;

  double get horizontalThumbWidth => _horizontalThumbWidth;

  double get verticalMaxExtent => _verticalMaxExtent;

  double get horizontalMaxExtent => _horizontalMaxExtent;

  double get verticalViewPort => _verticalViewPort;

  double get horizontalViewPort => _horizontalViewPort;

  bool get onHoverVerticalTrack => _onHoverVerticalTrack;

  bool get onHoverHorizontalTrack => _onHoverHorizontalTrack;

  double get previousHeight => _previousHeight;

  double get previousWidth => _previousWidth;

  double? get verticalThumbCurrentPosition => _verticalThumbCurrentPosition;
  GlobalKey get verticalTrackKey => _verticalTrackKey;

  ///This method update thumb position while scrolling,
  /// Platforms [Android and IOS]
  updateThumbPositionWithScroll(Axis orientation) {
    ScrollController controller = getController(orientation);
    // print(controller.position.pixels);
    if (orientation == Axis.horizontal) {
      _horizontalThumbCurrentPosition =
          (controller.offset) / ratio(orientation);
    } else {
      _verticalThumbCurrentPosition =
          (controller.position.pixels) / ratio(orientation);
    }
    notifyListeners();
  }

  ScrollController getController(Axis orientation,
      {ScrollController? vController, ScrollController? hController}) {
    return orientation == Axis.vertical
        ? vController ?? _verticalScrollController
        : hController ?? _horizontalScrollController;
  }

  /// get  ratio by fullSize/(visibleSize-thumbSize)
  double ratio(Axis orientation,
      {ScrollController? vController, ScrollController? hController}) {
    ScrollController? controller;
    if (orientation == Axis.horizontal) {
      controller = vController ?? horizontalScrollController;
    } else {
      controller = hController ?? verticalScrollController;
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

  void initializeControllerValues(Axis orientation) {
    bool _isHorizontal = orientation == Axis.horizontal ? true : false;
    ScrollController _controller = getController(orientation);
    if (_isHorizontal) {
      ///horizontal
      _horizontalFullSize = _controller.position.maxScrollExtent;
      _horizontalMaxExtent = (_controller.position.viewportDimension +
          _controller.position.maxScrollExtent);
      _horizontalViewPort = _controller.position.viewportDimension;
      _horizontalThumbWidth = _thumbSize(orientation);
    } else {
      ///Vertical
      _verticalFullSize = _controller.position.maxScrollExtent;
      _verticalMaxExtent = (_controller.position.viewportDimension +
          _controller.position.maxScrollExtent);
      _verticalViewPort = _controller.position.viewportDimension;
      _verticalThumbWidth = _thumbSize(orientation);
    }
    notifyListeners();
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

  void onDrag(DragUpdateDetails a, {required Axis orientation}) {
    // if (kDebugMode) {
    //   // print('thumbCurrentPosition: ${thumbCurrentPosition!}');
    // }
    if (orientation == Axis.horizontal) {
      ///horizontal

      if (0 > horizontalThumbCurrentPosition!) {
        _horizontalThumbCurrentPosition = 0;
      } else if (horizontalThumbCurrentPosition! >
          viewPort(orientation) - _thumbSize(orientation)) {
        _horizontalThumbCurrentPosition =
            viewPort(orientation) - _thumbSize(orientation);
      } else if (0 <= horizontalThumbCurrentPosition! &&
          horizontalThumbCurrentPosition! <=
              viewPort(orientation) - _thumbSize(orientation)) {
        _horizontalThumbCurrentPosition =
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
        _verticalThumbCurrentPosition = 0;
      } else if (verticalThumbCurrentPosition! >
          viewPort(orientation) - _thumbSize(orientation)) {
        _verticalThumbCurrentPosition =
            viewPort(orientation) - _thumbSize(orientation);
      } else if (verticalThumbCurrentPosition! >= 0 &&
          verticalThumbCurrentPosition! <=
              viewPort(orientation) - _thumbSize(orientation)) {
        _verticalThumbCurrentPosition =
            verticalThumbCurrentPosition! + a.delta.dy;
        if (verticalThumbCurrentPosition! != 0 ||
            verticalThumbCurrentPosition! !=
                viewPort(orientation) - _thumbSize(orientation)) {
          getController(orientation)
              .jumpTo(verticalThumbCurrentPosition! * ratio(orientation));
        }
      }
    }
    notifyListeners();
  }

  ///if no color provided, default colors will be assign
  ///
  ///[trackColor]??Colors.black.withOpacity(0.03);
  ///
  ///[noColor]??Colors.transparent;
  ///
  ///[borderColor]??Colors.black.withOpacity(0.0851);

  void onTrackClick(TapDownDetails tapDownDetails,
      {required Axis orientation,
      ScrollController? vCont,
      ScrollController? hCont}) {
    print(tapDownDetails.localPosition.dy);
    // print(verticalThumbCurrentPosition);
    // print(_verticalThumbWidth);

    ScrollController _hController = hCont ?? horizontalScrollController;
    ScrollController _vController = vCont ?? verticalScrollController;

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

          _horizontalThumbCurrentPosition =
              horizontalThumbCurrentPosition! + _horizontalThumbWidth;
          _hController.animateTo(
              horizontalThumbCurrentPosition! * ratio(orientation),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        } else {
          _horizontalThumbCurrentPosition =
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
          _horizontalThumbCurrentPosition =
              horizontalThumbCurrentPosition! - _horizontalThumbWidth;
          _hController.animateTo(
              horizontalThumbCurrentPosition! * ratio(orientation),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        } else if (horizontalThumbCurrentPosition! < _horizontalThumbWidth) {
          // print('-ive\nless than thumb');
          _horizontalThumbCurrentPosition = 0;
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

          _verticalThumbCurrentPosition =
              verticalThumbCurrentPosition! + _verticalThumbWidth;
          _vController.animateTo(
              verticalThumbCurrentPosition! * ratio(orientation),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        } else {
          _verticalThumbCurrentPosition =
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
          _verticalThumbCurrentPosition =
              verticalThumbCurrentPosition! - _verticalThumbWidth;
          _vController.animateTo(
              verticalThumbCurrentPosition! * ratio(orientation),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear);
        } else if (verticalThumbCurrentPosition! < _verticalThumbWidth) {
          // print('-ive\nless than thumb');
          _verticalThumbCurrentPosition = 0;
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

  void initiate(
      {ScrollController? vController, ScrollController? hController}) {
    hController != null
        ? hController
            .addListener(() => updateThumbPositionWithScroll(Axis.horizontal))
        : horizontalScrollController
            .addListener(() => updateThumbPositionWithScroll(Axis.horizontal));

    vController != null
        ? vController
            .addListener(() => updateThumbPositionWithScroll(Axis.vertical))
        : verticalScrollController
            .addListener(() => updateThumbPositionWithScroll(Axis.vertical));
  }

  set width(double? value) {
    _width = value;
  }

  void close({ScrollController? vController, ScrollController? hController}) {
    hController != null
        ? hController.dispose()
        : horizontalScrollController.dispose();
    vController != null
        ? vController.dispose()
        : verticalScrollController.dispose();
  }

  set height(double? value) {
    _height = value;
  }

  set verticalTrackKey(GlobalKey value) {
    _verticalTrackKey = value;
  }

  set horizontalTrackKey(GlobalKey value) {
    _horizontalTrackKey = value;
  }

  set verticalScrollController(ScrollController value) {
    _verticalScrollController = value;
  }

  set horizontalScrollController(ScrollController value) {
    _horizontalScrollController = value;
  }

  set verticalThumbWidth(double value) {
    _verticalThumbWidth = value;
  }

  set horizontalThumbWidth(double value) {
    _horizontalThumbWidth = value;
  }

  set verticalMaxExtent(double value) {
    _verticalMaxExtent = value;
  }

  set horizontalMaxExtent(double value) {
    _horizontalMaxExtent = value;
  }

  set verticalViewPort(double value) {
    _verticalViewPort = value;
  }

  set horizontalViewPort(double value) {
    _horizontalViewPort = value;
  }

  set onHoverVerticalTrack(bool value) {
    _onHoverVerticalTrack = value;
  }

  set onHoverHorizontalTrack(bool value) {
    _onHoverHorizontalTrack = value;
  }

  set previousHeight(double value) {
    _previousHeight = value;
  }

  set previousWidth(double value) {
    _previousWidth = value;
  }

  set verticalThumbCurrentPosition(double? value) {
    _verticalThumbCurrentPosition = value;
  }

  set horizontalThumbCurrentPosition(double? value) {
    _horizontalThumbCurrentPosition = value;
  }

  set verticalFullSize(double? value) {
    _verticalFullSize = value;
  }

  set horizontalFullSize(double? value) {
    _horizontalFullSize = value;
  }
}
