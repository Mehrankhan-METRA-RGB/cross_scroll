import 'package:flutter/cupertino.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4, Vector3;

/// A thin wrapper on [ValueNotifier] whose value is a [Matrix4] representing a
/// Cross Scrolling.
///
/// The [value] defaults to the identity matrix, which corresponds to no
/// Cross Scrolling.
///
/// See also:
///
///  * [CrossScrollViewer.crossScrollController] for detailed documentation
///    on how to use TransformationController with [CrossScrollViewer].
class MatrixController extends ValueNotifier<Matrix4> {
  /// Create an instance of [MatrixController].
  ///
  /// The [value] defaults to the identity matrix, which corresponds to no
  /// transformation.
  MatrixController([Matrix4? value]) : super(value ?? Matrix4.identity());

  /// Return the scene point at the given viewport point.
  ///
  /// A viewport point is relative to the parent while a scene point is relative
  /// to the child, regardless of transformation. Calling toScene with a
  /// viewport point essentially returns the scene coordinate that lies
  /// underneath the viewport point given the transform.
  ///
  /// The viewport transforms as the inverse of the child (i.e. moving the child
  /// left is equivalent to moving the viewport right).
  ///
  /// This method is often useful when determining where an event on the parent
  /// occurs on the child. This example shows how to determine where a tap on
  /// the parent occurred on the child.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return GestureDetector(
  ///     onTapUp: (TapUpDetails details) {
  ///       _childWasTappedAt = _transformationController.toScene(
  ///         details.localPosition,
  ///       );
  ///     },
  ///     child: InteractiveViewer(
  ///       transformationController: _transformationController,
  ///       child: child,
  ///     ),
  ///   );
  /// }
  /// ```
  Offset toScene(Offset viewportPoint) {
    // On viewportPoint, perform the inverse transformation of the scene to get
    // where the point would be in the scene before the transformation.
    final Matrix4 inverseMatrix = Matrix4.inverted(value);
    final Vector3 untransformed = inverseMatrix.transform3(Vector3(
      viewportPoint.dx,
      viewportPoint.dy,
      0,
    ));
    return Offset(untransformed.x, untransformed.y);
  }
}

class CrossDiagnolController extends ChangeNotifier {
  double? _width = 0;
  double _thumbWidth = 8;
  double? _height = 0;
  double? _horizontalFullSize = 0;
  double? _verticalFullSize = 0;
  double _horizontalThumbCurrentPosition = 0;
  double _verticalThumbCurrentPosition = 0;
  double _previousWidth = 0;
  double _previousHeight = 0;
  bool _onHoverHorizontalTrack = false;
  bool _onHoverVerticalTrack = false;
  double _horizontalViewPort = 0;
  double _verticalViewPort = 0;
  double _horizontalMaxExtent = 0.1;
  double _verticalMaxExtent = 0.1;
  double _horizontalThumbLength = 55;
  double _verticalThumbLength = 55;
  bool _vMaxExtentLessThanViewPort = false;

  ///True when Vertical ViewPort is greater or equal to Max-Extent of Scrolling
  bool get vMaxExtentLessThanViewPort => _vMaxExtentLessThanViewPort;

  set vMaxExtentLessThanViewPort(bool value) {
    _vMaxExtentLessThanViewPort = value;
  }

  bool _hMaxExtentLessThanViewPort = false;

  ///True when Horizontal ViewPort is greater or equal to Max-Extent of Scrolling
  bool get hMaxExtentLessThanViewPort => _hMaxExtentLessThanViewPort;

  set hMaxExtentLessThanViewPort(bool value) {
    _hMaxExtentLessThanViewPort = value;
  } // double _horizontalThumbPosition = 1;

  MatrixController _controller = MatrixController();

  void listen(BuildContext context, MatrixController controller,
      Size maxExtentSize, Size screenSize) {
    //Matrix Controller
    _controller = controller;

    //current screen size
    _verticalFullSize = MediaQuery.of(context).size.height;
    _horizontalFullSize = MediaQuery.of(context).size.width;

    //Vertical thumb Availability
    thumbTrackAvailability(
        maxExtentSize.height, screenSize.height, Axis.vertical);
    //Horizontal thumb Availability
    thumbTrackAvailability(
        maxExtentSize.width, screenSize.width, Axis.horizontal);

    //current scrolling widget size
    ///widgetSize-thumbWidth

    _horizontalViewPort = screenSize.width - _thumbWidth;
    _verticalViewPort = screenSize.height - _thumbWidth;

    //Total of scroll
    /// maxExtent-ViewPort
    _verticalMaxExtent = maxExtentSize.height - _verticalViewPort;
    _horizontalMaxExtent = maxExtentSize.width - _horizontalViewPort;

    //Thumb size based on viewport and amx extent
    _verticalThumbLength = _thumbSize().dy;
    _horizontalThumbLength = _thumbSize().dx;

    print("THUMB SIZE:${_thumbSize()}");
    updateThumbPositionWithScroll(
        _controller.value.absolute().getTranslation());
    notifyListeners();
  }

  ///Hide the scroll tab and bar when the viewport size matches or exceeds
  /// the maximum extent of the scroll view. This ensures a seamless user
  /// experience without unnecessary scroll indicators when all content fits
  /// within the visible area.
  bool thumbTrackAvailability(double maxExtent, double viewPort, Axis axis) {
    if (axis == Axis.vertical) {
      _vMaxExtentLessThanViewPort = maxExtent <= viewPort ? true : false;
      return _vMaxExtentLessThanViewPort;
    } else {
      _hMaxExtentLessThanViewPort = maxExtent <= viewPort ? true : false;
      return _hMaxExtentLessThanViewPort;
    }
  }

  GlobalKey _horizontalTrackKey = GlobalKey();
  GlobalKey _verticalTrackKey = GlobalKey();

  GlobalKey get horizontalTrackKey => _horizontalTrackKey;

  double? get width => _width;

  double? get height => _height;

  double? get horizontalFullSize => _horizontalFullSize;

  double? get verticalFullSize => _verticalFullSize;

  double get horizontalThumbCurrentPosition => _horizontalThumbCurrentPosition;

  double get verticalThumbLength => _verticalThumbLength;

  double get horizontalThumbLength => _horizontalThumbLength;

  double get verticalMaxExtent => _verticalMaxExtent;

  double get horizontalMaxExtent => _horizontalMaxExtent;

  double get verticalViewPort => _verticalViewPort;

  double get horizontalViewPort => _horizontalViewPort;

  bool get onHoverVerticalTrack => _onHoverVerticalTrack;

  bool get onHoverHorizontalTrack => _onHoverHorizontalTrack;

  double get previousHeight => _previousHeight;

  double get previousWidth => _previousWidth;

  double get verticalThumbCurrentPosition => _verticalThumbCurrentPosition;
  GlobalKey get verticalTrackKey => _verticalTrackKey;

  /*** Updates the position of the thumb while scrolling.
   *
   * This method is responsible for updating the position of the thumb within the scrollbar when
   * scrolling occurs. It is designed to work on multiple platforms, including Android, iOS, and
   * advanced trackpads that support scrolling gestures.
   *
   * [vec]: A [Vector3] representing the scrolling vector, typically containing horizontal and vertical
   * offsets. For example, `vec.x` represents the horizontal scrolling offset, and `vec.y` represents
   * the vertical scrolling offset.
   */
  void updateThumbPositionWithScroll(Vector3 vec) {
    _horizontalThumbCurrentPosition = vec.x / ratio().width;
    _verticalThumbCurrentPosition = vec.y / ratio().height;
  }

  /**
   * Calculates the position of the thumb within a scrollbar using the formula:
   *
   *     MaxExtent / (ViewPort - thumbSize)
   *
   * This formula is likely used to determine the position of the thumb (the draggable element within the scrollbar)
   * based on the size of the content (fullSize), the size of the visible area (visibleSize), and the size of the thumb
   * (thumbSize).
   *
   * Here's an explanation of each component of the formula:
   *
   * - MaxExtent: Represents the total size of the content that can be scrolled. It's typically the size of the content
   *   within the scrollable area, including any content that is not currently visible within the viewport.
   *
   * - ViewPort: Represents the size of the visible area or viewport. It's the size of the portion of the content that
   *   is currently visible to the user. In the context of a scroll view, it's often the size of the scrollable viewport.
   *
   * - thumbSize: Represents the size of the thumb element, which is the draggable part of the scrollbar that users
   *   interact with to scroll. The thumb size is relative to the content size and viewport size.
   *
   * The formula calculates the position of the thumb within the scrollbar to reflect the relative position of the visible
   * content within the full content. When the visible content is at the top, the thumb should be at the top of the scrollbar,
   * and when the visible content is at the bottom, the thumb should be at the bottom of the scrollbar.
   *
   * This formula is commonly used in scroll view controllers to maintain a consistent and intuitive user experience, ensuring
   * that the thumb's position accurately represents the current view of the content within the full scrollable area.
   *
   * Note: The comment mentions the removal of thumbSize from the code, which suggests that thumbSize might have been
   * excluded from the calculation for some reason.
   */
  Size ratio() {
    return Size(_horizontalMaxExtent / (_horizontalViewPort - _thumbSize().dx),
        _verticalMaxExtent / (_verticalViewPort - _thumbSize().dy));
  }

  /**
   * Calculate the size of the thumb in a scrollbar within a scroll view controller.
   * It takes into account various components to ensure the thumb's size accurately represents the
   * proportion of visible content to the total content size. This enables users to gauge the visibility
   * of content and navigate through it effectively.
   *
   * Formula:
   * ThumbSize = (viewPortSize / (maxExtent - minExtent + viewPortSize)) * trackLength
   *
   * Components Explained:
   * - ThumbSize: Represents the size of the thumb within the scrollbar. It represents the currently
   *   visible portion of content within the viewport.
   * - viewPortSize: Denotes the size of the visible area or viewport within the scrollable content.
   * - maxExtent: Represents the maximum extent of the scrollable content, including out-of-view content.
   * - minExtent: Represents the minimum extent of the scrollable content, often used when content size
   *   can dynamically change but has a lower limit.
   * - trackLength: Indicates the length of the entire scrollbar track where the thumb can move.
   *
   * The formula calculates ThumbSize by comparing the viewPortSize to the difference between maxExtent
   * and minExtent, adjusted by the trackLength. This ensures a responsive scrollbar, reflecting the
   * current visibility of content within the entire content size.
   */

  Offset _thumbSize() {
    double _vSize =
        (_verticalViewPort / (_verticalMaxExtent - 1 + _verticalViewPort)) *
            _verticalViewPort;
    double _hSize = (_horizontalViewPort /
            (_horizontalMaxExtent - 1 + _horizontalViewPort)) *
        _horizontalViewPort;

    return Offset(_hSize < 55 ? 55 : _hSize, _vSize < 55 ? 55 : _vSize);
  }

  void keepThumbInRangeWhileResizingScreen() {
    print("keepThumbInRangeWhileResizingScreen");

    if (_horizontalThumbCurrentPosition >
        _horizontalViewPort - _thumbSize().dx) {
      _horizontalThumbCurrentPosition =
          (_horizontalViewPort - _thumbSize().dx) * ratio().width;

      ///TODO:ADD SCROLLING THUMB CODE HERE
      // _horizontalJump();
    }
    if (_verticalThumbCurrentPosition > _verticalViewPort - _thumbSize().dy) {
      _verticalThumbCurrentPosition =
          (_verticalViewPort - _thumbSize().dy) * ratio().height;
      // _verticalJump();
    }

    Matrix4.identity()
      ..translate(_horizontalThumbCurrentPosition,
          _verticalThumbCurrentPosition); // Specify the desired scroll offset.

    notifyListeners();
  }

  /**
   * Handles the drag gesture update to move the thumb within the scrollbar.
   *
   * @param a [DragUpdateDetails] object containing information about the drag update.
   * @param orientation The axis (horizontal or vertical) in which the scrollbar operates.
   */
  void onDrag(DragUpdateDetails a, {required Axis orientation}) {
    if (orientation == Axis.horizontal) {
      // Handle horizontal scrolling

      final maxHorizontalPosition = _horizontalViewPort - _thumbSize().dx;

      // Ensure the thumb stays within the scrollbar's horizontal bounds.
      _horizontalThumbCurrentPosition =
          _horizontalThumbCurrentPosition.clamp(0.0, maxHorizontalPosition);

      // Update the horizontal thumb position based on the drag delta.
      _horizontalThumbCurrentPosition += a.delta.dx;

      if (_horizontalThumbCurrentPosition != 0 &&
          _horizontalThumbCurrentPosition != maxHorizontalPosition) {
        // Implement scrolling logic for horizontal scrolling (TODO: Implement scrolling logic here)
        _horizontalJump();
      }
    } else {
      // Handle vertical scrolling

      final maxVerticalPosition = _verticalViewPort - _thumbSize().dy;

      // Ensure the thumb stays within the scrollbar's vertical bounds.
      _verticalThumbCurrentPosition =
          _verticalThumbCurrentPosition.clamp(0.0, maxVerticalPosition);

      // Update the vertical thumb position based on the drag delta.
      _verticalThumbCurrentPosition += a.delta.dy;

      if (_verticalThumbCurrentPosition != 0 &&
          _verticalThumbCurrentPosition != maxVerticalPosition) {
        // Implement scrolling logic for vertical scrolling (TODO: Implement scrolling logic here)
        _verticalJump();
      }
    }

    // Notify listeners about the updated thumb position.
    notifyListeners();
  }

  /**
   * Performs a vertical jump in response to a scrollbar interaction.
   *
   * This method calculates the new position for the content to be displayed when the user interacts with the scrollbar
   * on the vertical axis. It then applies the calculated transformation to the [_controller] to update the content's
   * visible area accordingly.
   */
  void _verticalJump() {
    // Calculate the vertical displacement based on the thumb's position and apply the transformation
    _controller.value = Matrix4.identity()
      ..translate(_horizontalThumbCurrentPosition,
          -(verticalThumbCurrentPosition * ratio().height));
  }

  /**
   * Performs a horizontal jump in response to a scrollbar interaction.
   *
   * This method calculates the new position for the content to be displayed when the user interacts with the scrollbar
   * on the horizontal axis. It then applies the calculated transformation to the [_controller] to update the content's
   * visible area accordingly.
   */
  void _horizontalJump() {
    // Calculate the horizontal displacement based on the thumb's position and apply the transformation
    _controller.value = Matrix4.identity()
      ..translate(-(_horizontalThumbCurrentPosition * ratio().width),
          verticalThumbCurrentPosition);
  }

  ///if no color provided, default colors will be assign
  ///
  ///[trackColor]??Colors.black.withOpacity(0.03);
  ///
  ///[noColor]??Colors.transparent;
  ///
  ///[borderColor]??Colors.black.withOpacity(0.0851);

  void onTrackClick(
    TapDownDetails tapDownDetails, {
    required Axis orientation,
  }) {
    double _horizontalTrackLengthFromThumbPoint =
        _horizontalThumbCurrentPosition + _horizontalThumbLength;
    double _verticalTrackLengthFromThumbPoint =
        _verticalThumbCurrentPosition + _verticalThumbLength;

    if (orientation == Axis.horizontal) {
      ///horizontal track
      if (tapDownDetails.localPosition.dx > _horizontalThumbCurrentPosition) {
        if (_horizontalTrackLengthFromThumbPoint <
            _horizontalViewPort - _horizontalThumbLength) {
          _horizontalThumbCurrentPosition =
              horizontalThumbCurrentPosition + _horizontalThumbLength;

          ///TODO:We will do Scrolling here
        } else {
          _horizontalThumbCurrentPosition =
              _horizontalViewPort - _horizontalThumbLength;

          ///TODO:We will do Scrolling here
          //     horizontalThumbCurrentPosition! * ratio( ).width,
        }
      } else if (tapDownDetails.localPosition.dx <
          _horizontalThumbCurrentPosition) {
        if (_horizontalThumbCurrentPosition > _horizontalThumbLength) {
          _horizontalThumbCurrentPosition =
              _horizontalThumbCurrentPosition - _horizontalThumbLength;

          ///TODO:We will do Scrolling here
        } else if (horizontalThumbCurrentPosition < _horizontalThumbLength) {
          // print('-ive\nless than thumb');
          _horizontalThumbCurrentPosition = 0;

          ///TODO:We will do Scrolling here
        }
      }
    } else {
      ///vertical track
      if (tapDownDetails.localPosition.dy > _verticalThumbCurrentPosition) {
        if (_verticalTrackLengthFromThumbPoint <
            _verticalViewPort - _verticalThumbLength) {
          _verticalThumbCurrentPosition =
              _verticalThumbCurrentPosition + _verticalThumbLength;

          ///TODO:We will do Scrolling here
        } else {
          _verticalThumbCurrentPosition =
              _verticalViewPort - _verticalThumbLength;
        }
      } else if (tapDownDetails.localPosition.dy <
          _verticalThumbCurrentPosition) {
        if (_verticalThumbCurrentPosition > _verticalThumbLength) {
          _verticalThumbCurrentPosition =
              _verticalThumbCurrentPosition - _verticalThumbLength;

          ///TODO:We will do Scrolling here
        } else if (_verticalThumbCurrentPosition < _verticalThumbLength) {
          _verticalThumbCurrentPosition = 0;

          ///TODO:We will do Scrolling here
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    if (CrossDiagnolController().hasListeners)
      CrossDiagnolController().removeListener(() {});
  }

  set width(double? value) {
    _width = value;
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

  set verticalThumbLength(double value) {
    _verticalThumbLength = value;
  }

  set horizontalThumbLength(double value) {
    _horizontalThumbLength = value;
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

  set verticalThumbCurrentPosition(double value) {
    _verticalThumbCurrentPosition = value;
  }

  set horizontalThumbCurrentPosition(double value) {
    _horizontalThumbCurrentPosition = value;
  }

  set verticalFullSize(double? value) {
    _verticalFullSize = value;
  }

  set horizontalFullSize(double? value) {
    _horizontalFullSize = value;
  }
}
