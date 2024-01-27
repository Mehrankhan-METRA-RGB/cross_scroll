import 'dart:math' as math;

import 'package:cross_scroll/cross_scroll.dart';
import 'package:cross_scroll/src/Components/cross_scroll_thumb.dart';
import 'package:cross_scroll/src/Infinite/CrossScrollBar/cross_scroll_bar.dart';
import 'package:cross_scroll/src/Interactive/controller.dart';
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4, Quad, Vector3;

// Examples can assume:
// late BuildContext context;
// late Offset? _childWasTappedAt;
// late TransformationController _transformationController;
// Widget child = const Placeholder();

/// A signature for widget builders that take a [Quad] of the current viewport.
///
/// See also:
///
///   * [DiagonalScrollingBase.builder], whose builder is of this type.
///   * [WidgetBuilder], which is similar, but takes no viewport.
typedef CrossScrollWidgetBuilder = Widget Function(
    BuildContext context, Quad viewport);

@immutable
class DiagonalScrollingBase extends StatefulWidget {
  // CrossScrollViewer({
  //   super.key,
  //   this.clipBehavior = Clip.hardEdge,
  //   @Deprecated(
  //     'Use panAxis instead. '
  //     'This feature was deprecated after v3.3.0-0.5.pre.',
  //   )
  //   this.alignPanAxis = false,
  //   this.panAxis = PanAxis.free,
  //   this.boundaryMargin = EdgeInsets.zero,
  //   this.constrained = true,
  //   // These default scale values were eyeballed as reasonable limits for common
  //   // use cases.
  //   this.maxScale = 2.5,
  //   this.minScale = 0.8,
  //   this.interactionEndFrictionCoefficient = _kDrag,
  //   this.onInteractionEnd,
  //   this.onInteractionStart,
  //   this.onInteractionUpdate,
  //   this.panEnabled = true,
  //   this.scaleEnabled = true,
  //   this.scaleFactor = kDefaultMouseScrollToScaleFactor,
  //   this.transformationController,
  //   this.alignment,
  //   this.trackpadScrollCausesScale = false,
  //   required Widget this.child,
  // })  : assert(minScale > 0),
  //       assert(interactionEndFrictionCoefficient > 0),
  //       assert(minScale.isFinite),
  //       assert(maxScale > 0),
  //       assert(!maxScale.isNaN),
  //       assert(maxScale >= minScale),
  //       // boundaryMargin must be either fully infinite or fully finite, but not
  //       // a mix of both.
  //       assert(
  //         (boundaryMargin.horizontal.isInfinite &&
  //                 boundaryMargin.vertical.isInfinite) ||
  //             (boundaryMargin.top.isFinite &&
  //                 boundaryMargin.right.isFinite &&
  //                 boundaryMargin.bottom.isFinite &&
  //                 boundaryMargin.left.isFinite),
  //       ),
  //       builder = null;

  /// Creates an InteractiveViewer for a child that is created on demand.
  ///
  /// Can be used to render a child that changes in response to the current
  /// transformation.
  ///
  /// The [builder] parameter must not be null. See its docs for an example of
  /// using it to optimize a large child.

  DiagonalScrollingBase.builder({
    super.key,
    this.clipBehavior = Clip.hardEdge,
    // @Deprecated(
    //   'Use panAxis instead. '
    //   'This feature was deprecated after v3.3.0-0.5.pre.',
    // )
    // this.alignPanAxis = false,
    this.panAxis = PanAxisCross.free,
    this.boundaryMargin = EdgeInsets.zero,
    // These default scale values were eyeballed as reasonable limits for common
    // use cases.
    this.maxScale = 2.5,
    this.minScale = 0.8,
    this.interactionEndFrictionCoefficient = _kDrag,
    this.onInteractionEnd,
    this.onInteractionStart,
    this.onInteractionUpdate,
    this.panEnabled = true,
    this.scaleEnabled = true,
    this.scaleFactor = 200.0,
    this.crossScrollController,
    this.normalColor,
    this.hoverColor,
    this.dimColor,
    this.horizontalBar,
    this.verticalBar,
    this.alignment,
    // this.trackpadScrollCausesScale = false,
    required CrossScrollWidgetBuilder this.builder,
  })  :
        // assert(minScale > 0),
        assert(interactionEndFrictionCoefficient > 0),
        // assert(minScale.isFinite),
        // assert(maxScale > 0),
        // assert(!maxScale.isNaN),
        // assert(maxScale >= minScale),
        // boundaryMargin must be either fully infinite or fully finite, but not
        // a mix of both.
        assert(
          (boundaryMargin.horizontal.isInfinite &&
                  boundaryMargin.vertical.isInfinite) ||
              (boundaryMargin.top.isFinite &&
                  boundaryMargin.right.isFinite &&
                  boundaryMargin.bottom.isFinite &&
                  boundaryMargin.left.isFinite),
        ),
        constrained = false;
  // child = null;

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

  /// The alignment of the child's origin, relative to the size of the box.
  final Alignment? alignment;

  /// If set to [Clip.none], the child may extend beyond the size of the InteractiveViewer,
  /// but it will not receive gestures in these areas.
  /// Be sure that the InteractiveViewer is the desired size when using [Clip.none].
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// This property is deprecated, please use [panAxis] instead.
  ///
  /// If true, panning is only allowed in the direction of the horizontal axis
  /// or the vertical axis.
  ///
  /// In other words, when this is true, diagonal panning is not allowed. A
  /// single gesture begun along one axis cannot also cause panning along the
  /// other axis without stopping and beginning a new gesture. This is a common
  /// pattern in tables where data is displayed in columns and rows.
  ///
  /// See also:
  ///  * [constrained], which has an example of creating a table that uses
  ///    alignPanAxis.
  // @Deprecated(
  //   'Use panAxis instead. '
  //   'This feature was deprecated after v3.3.0-0.5.pre.',
  // )
  // final bool alignPanAxis;

  /// When set to [PanAxisCross.aligned], panning is only allowed in the horizontal
  /// axis or the vertical axis, diagonal panning is not allowed.
  ///
  /// When set to [PanAxisCross.vertical] or [PanAxisCross.horizontal] panning is only
  /// allowed in the specified axis. For example, if set to [PanAxisCross.vertical],
  /// panning will only be allowed in the vertical axis. And if set to [PanAxisCross.horizontal],
  /// panning will only be allowed in the horizontal axis.
  ///
  /// When set to [PanAxisCross.free] panning is allowed in all directions.
  ///
  /// Defaults to [PanAxisCross.free].
  final PanAxisCross panAxis;

  /// A margin for the visible boundaries of the child.
  ///
  /// Any transformation that results in the viewport being able to view outside
  /// of the boundaries will be stopped at the boundary. The boundaries do not
  /// rotate with the rest of the scene, so they are always aligned with the
  /// viewport.
  ///
  /// To produce no boundaries at all, pass infinite [EdgeInsets], such as
  /// `EdgeInsets.all(double.infinity)`.
  ///
  /// No edge can be NaN.
  ///
  /// Defaults to [EdgeInsets.zero], which results in boundaries that are the
  /// exact same size and position as the [child].
  final EdgeInsets boundaryMargin;

  /// Builds the child of this widget.
  ///
  /// Passed with the [DiagonalScrollingBase.builder] constructor.
  ///
  /// {@tool dartpad}
  /// This example shows how to use builder to create a [Table] whose cell
  /// contents are only built when they are visible. Built and remove cells are
  /// logged in the console for illustration.
  ///
  /// ** See code in examples/api/lib/widgets/interactive_viewer/interactive_viewer.builder.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///   * [ListView.builder], which follows a similar pattern.
  final CrossScrollWidgetBuilder? builder;

  // /// The child [Widget] that is transformed by InteractiveViewer.
  // ///
  // /// If the [CrossScrollViewer.builder] constructor is used, then this will be
  // /// null, otherwise it is required.
  // final Widget? child;

  /// Whether the normal size constraints at this point in the widget tree are
  /// applied to the child.
  ///
  /// If set to false, then the child will be given infinite constraints. This
  /// is often useful when a child should be bigger than the InteractiveViewer.
  ///
  /// For example, for a child which is bigger than the viewport but can be
  /// panned to reveal parts that were initially offscreen, [constrained] must
  /// be set to false to allow it to size itself properly. If [constrained] is
  /// true and the child can only size itself to the viewport, then areas
  /// initially outside of the viewport will not be able to receive user
  /// interaction events. If experiencing regions of the child that are not
  /// receptive to user gestures, make sure [constrained] is false and the child
  /// is sized properly.
  ///
  /// Defaults to true.
  ///
  /// {@tool dartpad}
  /// This example shows how to create a pannable table. Because the table is
  /// larger than the entire screen, setting [constrained] to false is necessary
  /// to allow it to be drawn to its full size. The parts of the table that
  /// exceed the screen size can then be panned into view.
  ///
  /// ** See code in examples/api/lib/widgets/interactive_viewer/interactive_viewer.constrained.0.dart **
  /// {@end-tool}
  final bool constrained;

  /// If false, the user will be prevented from panning.
  ///
  /// Defaults to true.
  ///
  /// See also:
  ///
  ///   * [scaleEnabled], which is similar but for scale.
  final bool panEnabled;

  /// If false, the user will be prevented from scaling.
  ///
  /// Defaults to true.
  ///
  /// See also:
  ///
  ///   * [panEnabled], which is similar but for panning.
  final bool scaleEnabled;

  /// {@macro flutter.gestures.scale.trackpadScrollCausesScale}
  // final bool trackpadScrollCausesScale;

  /// Determines the amount of scale to be performed per pointer scroll.
  ///
  /// Defaults to [kDefaultMouseScrollToScaleFactor].
  ///
  /// Increasing this value above the default causes scaling to feel slower,
  /// while decreasing it causes scaling to feel faster.
  ///
  /// The amount of scale is calculated as the exponential function of the
  /// [PointerScrollEvent.scrollDelta] to [scaleFactor] ratio. In the Flutter
  /// engine, the mousewheel [PointerScrollEvent.scrollDelta] is hardcoded to 20
  /// per scroll, while a trackpad scroll can be any amount.
  ///
  /// Affects only pointer device scrolling, not pinch to zoom.
  final double scaleFactor;

  /// The maximum allowed scale.
  ///
  /// The scale will be clamped between this and [minScale] inclusively.
  ///
  /// Defaults to 2.5.
  ///
  /// Cannot be null, and must be greater than zero and greater than minScale.
  final double maxScale;

  /// The minimum allowed scale.
  ///
  /// The scale will be clamped between this and [maxScale] inclusively.
  ///
  /// Scale is also affected by [boundaryMargin]. If the scale would result in
  /// viewing beyond the boundary, then it will not be allowed. By default,
  /// boundaryMargin is EdgeInsets.zero, so scaling below 1.0 will not be
  /// allowed in most cases without first increasing the boundaryMargin.
  ///
  /// Defaults to 0.8.
  ///
  /// Cannot be null, and must be a finite number greater than zero and less
  /// than maxScale.
  final double minScale;

  /// Changes the deceleration behavior after a gesture.
  ///
  /// Defaults to 0.0000135.
  ///
  /// Cannot be null, and must be a finite number greater than zero.
  final double interactionEndFrictionCoefficient;

  /// Called when the user ends a pan or scale gesture on the widget.
  ///
  /// At the time this is called, the [MatrixController] will have
  /// already been updated to reflect the change caused by the interaction,
  /// though a pan may cause an inertia animation after this is called as well.
  ///
  /// {@template flutter.widgets.InteractiveViewer.onInteractionEnd}
  /// Will be called even if the interaction is disabled with [panEnabled] or
  /// [scaleEnabled] for both touch gestures and mouse interactions.
  ///
  /// A [GestureDetector] wrapping the InteractiveViewer will not respond to
  /// [GestureDetector.onScaleStart], [GestureDetector.onScaleUpdate], and
  /// [GestureDetector.onScaleEnd]. Use [onInteractionStart],
  /// [onInteractionUpdate], and [onInteractionEnd] to respond to those
  /// gestures.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [onInteractionStart], which handles the start of the same interaction.
  ///  * [onInteractionUpdate], which handles an update to the same interaction.
  final GestureScaleEndCallback? onInteractionEnd;

  /// Called when the user begins a pan or scale gesture on the widget.
  ///
  /// At the time this is called, the [MatrixController] will not have
  /// changed due to this interaction.
  ///
  /// {@macro flutter.widgets.InteractiveViewer.onInteractionEnd}
  ///
  /// The coordinates provided in the details' `focalPoint` and
  /// `localFocalPoint` are normal Flutter event coordinates, not
  /// InteractiveViewer scene coordinates. See
  /// [MatrixController.toScene] for how to convert these coordinates to
  /// scene coordinates relative to the child.
  ///
  /// See also:
  ///
  ///  * [onInteractionUpdate], which handles an update to the same interaction.
  ///  * [onInteractionEnd], which handles the end of the same interaction.
  final GestureScaleStartCallback? onInteractionStart;

  /// Called when the user updates a pan or scale gesture on the widget.
  ///
  /// At the time this is called, the [MatrixController] will have
  /// already been updated to reflect the change caused by the interaction, if
  /// the interaction caused the matrix to change.
  ///
  /// {@macro flutter.widgets.InteractiveViewer.onInteractionEnd}
  ///
  /// The coordinates provided in the details' `focalPoint` and
  /// `localFocalPoint` are normal Flutter event coordinates, not
  /// InteractiveViewer scene coordinates. See
  /// [MatrixController.toScene] for how to convert these coordinates to
  /// scene coordinates relative to the child.
  ///
  /// See also:
  ///
  ///  * [onInteractionStart], which handles the start of the same interaction.
  ///  * [onInteractionEnd], which handles the end of the same interaction.
  final GestureScaleUpdateCallback? onInteractionUpdate;

  /// A [MatrixController] for the transformation performed on the
  /// child.
  ///
  /// Whenever the child is transformed, the [Matrix4] value is updated and all
  /// listeners are notified. If the value is set, InteractiveViewer will update
  /// to respect the new value.
  ///
  /// {@tool dartpad}
  /// This example shows how transformationController can be used to animate the
  /// transformation back to its starting position.
  ///
  /// ** See code in examples/api/lib/widgets/interactive_viewer/interactive_viewer.transformation_controller.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [ValueNotifier], the parent class of TransformationController.
  ///  * [TextEditingController] for an example of another similar pattern.
  final CrossDiagnolController? crossScrollController;

  // Used as the coefficient of friction in the inertial translation animation.
  // This value was eyeballed to give a feel similar to Google Photos.
  static const double _kDrag = 0.0000135;

  /// Returns the closest point to the given point on the given line segment.
  @visibleForTesting
  static Vector3 getNearestPointOnLine(Vector3 point, Vector3 l1, Vector3 l2) {
    final double lengthSquared = math.pow(l2.x - l1.x, 2.0).toDouble() +
        math.pow(l2.y - l1.y, 2.0).toDouble();

    // In this case, l1 == l2.
    if (lengthSquared == 0) {
      return l1;
    }

    // Calculate how far down the line segment the closest point is and return
    // the point.
    final Vector3 l1P = point - l1;
    final Vector3 l1L2 = l2 - l1;
    final double fraction =
        clampDouble(l1P.dot(l1L2) / lengthSquared, 0.0, 1.0);
    return l1 + l1L2 * fraction;
  }

  /// Given a quad, return its axis aligned bounding box.
  @visibleForTesting
  static Quad getAxisAlignedBoundingBox(Quad quad) {
    final double minX = math.min(
      quad.point0.x,
      math.min(
        quad.point1.x,
        math.min(
          quad.point2.x,
          quad.point3.x,
        ),
      ),
    );
    final double minY = math.min(
      quad.point0.y,
      math.min(
        quad.point1.y,
        math.min(
          quad.point2.y,
          quad.point3.y,
        ),
      ),
    );
    final double maxX = math.max(
      quad.point0.x,
      math.max(
        quad.point1.x,
        math.max(
          quad.point2.x,
          quad.point3.x,
        ),
      ),
    );
    final double maxY = math.max(
      quad.point0.y,
      math.max(
        quad.point1.y,
        math.max(
          quad.point2.y,
          quad.point3.y,
        ),
      ),
    );
    return Quad.points(
      Vector3(minX, minY, 0),
      Vector3(maxX, minY, 0),
      Vector3(maxX, maxY, 0),
      Vector3(minX, maxY, 0),
    );
  }

  /// Returns true iff the point is inside the rectangle given by the Quad,
  /// inclusively.
  /// Algorithm from https://math.stackexchange.com/a/190373.
  @visibleForTesting
  static bool pointIsInside(Vector3 point, Quad quad) {
    final Vector3 aM = point - quad.point0;
    final Vector3 aB = quad.point1 - quad.point0;
    final Vector3 aD = quad.point3 - quad.point0;

    final double aMAB = aM.dot(aB);
    final double aBAB = aB.dot(aB);
    final double aMAD = aM.dot(aD);
    final double aDAD = aD.dot(aD);

    return 0 <= aMAB && aMAB <= aBAB && 0 <= aMAD && aMAD <= aDAD;
  }

  /// Get the point inside (inclusively) the given Quad that is nearest to the
  /// given Vector3.
  @visibleForTesting
  static Vector3 getNearestPointInside(Vector3 point, Quad quad) {
    // If the point is inside the axis aligned bounding box, then it's ok where
    // it is.
    if (pointIsInside(point, quad)) {
      return point;
    }

    // Otherwise, return the nearest point on the quad.
    final List<Vector3> closestPoints = <Vector3>[
      DiagonalScrollingBase.getNearestPointOnLine(
          point, quad.point0, quad.point1),
      DiagonalScrollingBase.getNearestPointOnLine(
          point, quad.point1, quad.point2),
      DiagonalScrollingBase.getNearestPointOnLine(
          point, quad.point2, quad.point3),
      DiagonalScrollingBase.getNearestPointOnLine(
          point, quad.point3, quad.point0),
    ];
    double minDistance = double.infinity;
    late Vector3 closestOverall;
    for (final Vector3 closePoint in closestPoints) {
      final double distance = math.sqrt(
        math.pow(point.x - closePoint.x, 2) +
            math.pow(point.y - closePoint.y, 2),
      );
      if (distance < minDistance) {
        minDistance = distance;
        closestOverall = closePoint;
      }
    }
    return closestOverall;
  }

  @override
  State<DiagonalScrollingBase> createState() => _DiagonalScrollingBaseState();
}

class _DiagonalScrollingBaseState extends State<DiagonalScrollingBase>
    with TickerProviderStateMixin {
  MatrixController? _transformationController;
  CrossDiagnolController? _crossController;

  final GlobalKey _childKey = GlobalKey();
  final GlobalKey _parentKey = GlobalKey();
  Animation<Offset>? _animation;
  Animation<double>? _scaleAnimation;
  late Offset _scaleAnimationFocalPoint;
  late AnimationController _controller;
  late AnimationController _scaleController;
  Axis? _currentAxis; // Used with panAxis.
  Offset? _referenceFocalPoint; // Point where the current gesture began.
  double? _scaleStart; // Scale value at start of scaling gesture.
  double? _rotationStart = 0.0; // Rotation at start of rotation gesture.
  double _currentRotation = 0.0; // Rotation of _transformationController.value.
  _GestureTypeCross? _gestureType;

  // TODO(justinmc): Add rotateEnabled parameter to the widget and remove this
  // hardcoded value when the rotation feature is implemented.
  // https://github.com/flutter/flutter/issues/57698
  final bool _rotateEnabled = false;

  // The _boundaryRect is calculated by adding the boundaryMargin to the size of
  // the child.
  Rect get _boundaryRect {
    assert(_childKey.currentContext != null);
    assert(!widget.boundaryMargin.left.isNaN);
    assert(!widget.boundaryMargin.right.isNaN);
    assert(!widget.boundaryMargin.top.isNaN);
    assert(!widget.boundaryMargin.bottom.isNaN);

    final RenderBox childRenderBox =
        _childKey.currentContext!.findRenderObject()! as RenderBox;
    final Size childSize = childRenderBox.size;
    final Rect boundaryRect =
        widget.boundaryMargin.inflateRect(Offset.zero & childSize);
    assert(
      !boundaryRect.isEmpty,
      "InteractiveViewer's child must have nonzero dimensions.",
    );
    // Boundaries that are partially infinite are not allowed because Matrix4's
    // rotation and translation methods don't handle infinites well.
    assert(
      boundaryRect.isFinite ||
          (boundaryRect.left.isInfinite &&
              boundaryRect.top.isInfinite &&
              boundaryRect.right.isInfinite &&
              boundaryRect.bottom.isInfinite),
      'boundaryRect must either be infinite in all directions or finite in all directions.',
    );
    return boundaryRect;
  }

  // The Rect representing the child's parent.
  Rect get _viewport {
    assert(_parentKey.currentContext != null);
    final RenderBox parentRenderBox =
        _parentKey.currentContext!.findRenderObject()! as RenderBox;
    return Offset.zero & parentRenderBox.size;
  }

  // Return a new matrix representing the given matrix after applying the given
  // translation.
  Matrix4 _matrixTranslate(Matrix4 matrix, Offset translation) {
    if (translation == Offset.zero) {
      return matrix.clone();
    }

    late final Offset alignedTranslation;

    if (_currentAxis != null) {
      switch (widget.panAxis) {
        case PanAxisCross.horizontal:
          alignedTranslation = _alignAxisCross(translation, Axis.horizontal);
          break;
        case PanAxisCross.vertical:
          alignedTranslation = _alignAxisCross(translation, Axis.vertical);
          break;
        case PanAxisCross.aligned:
          alignedTranslation = _alignAxisCross(translation, _currentAxis!);
          break;
        case PanAxisCross.free:
          alignedTranslation = translation;
      }
    } else {
      alignedTranslation = translation;
    }

    final Matrix4 nextMatrix = matrix.clone()
      ..translate(
        alignedTranslation.dx,
        alignedTranslation.dy,
      );

    // Transform the viewport to determine where its four corners will be after
    // the child has been transformed.
    final Quad nextViewport = _transformViewportCross(nextMatrix, _viewport);

    // If the boundaries are infinite, then no need to check if the translation
    // fits within them.
    if (_boundaryRect.isInfinite) {
      return nextMatrix;
    }

    // Expand the boundaries with rotation. This prevents the problem where a
    // mismatch in orientation between the viewport and boundaries effectively
    // limits translation. With this approach, all points that are visible with
    // no rotation are visible after rotation.
    final Quad boundariesAabbQuad = _getAxisAlignedBoundingBoxWithRotationCross(
      _boundaryRect,
      _currentRotation,
    );

    // If the given translation fits completely within the boundaries, allow it.
    final Offset offendingDistance =
        _exceedsByCross(boundariesAabbQuad, nextViewport);
    if (offendingDistance == Offset.zero) {
      return nextMatrix;
    }

    // Desired translation goes out of bounds, so translate to the nearest
    // in-bounds point instead.
    final Offset nextTotalTranslation = _getMatrixTranslationCross(nextMatrix);
    final double currentScale = matrix.getMaxScaleOnAxis();
    final Offset correctedTotalTranslation = Offset(
      nextTotalTranslation.dx - offendingDistance.dx * currentScale,
      nextTotalTranslation.dy - offendingDistance.dy * currentScale,
    );
    // TODO(justinmc): This needs some work to handle rotation properly. The
    // idea is that the boundaries are axis aligned (boundariesAabbQuad), but
    // calculating the translation to put the viewport inside that Quad is more
    // complicated than this when rotated.
    // https://github.com/flutter/flutter/issues/57698
    final Matrix4 correctedMatrix = matrix.clone()
      ..setTranslation(Vector3(
        correctedTotalTranslation.dx,
        correctedTotalTranslation.dy,
        0.0,
      ));

    // Double check that the corrected translation fits.
    final Quad correctedViewport =
        _transformViewportCross(correctedMatrix, _viewport);
    final Offset offendingCorrectedDistance =
        _exceedsByCross(boundariesAabbQuad, correctedViewport);
    if (offendingCorrectedDistance == Offset.zero) {
      return correctedMatrix;
    }

    // If the corrected translation doesn't fit in either direction, don't allow
    // any translation at all. This happens when the viewport is larger than the
    // entire boundary.
    if (offendingCorrectedDistance.dx != 0.0 &&
        offendingCorrectedDistance.dy != 0.0) {
      return matrix.clone();
    }

    // Otherwise, allow translation in only the direction that fits. This
    // happens when the viewport is larger than the boundary in one direction.
    final Offset unidirectionalCorrectedTotalTranslation = Offset(
      offendingCorrectedDistance.dx == 0.0 ? correctedTotalTranslation.dx : 0.0,
      offendingCorrectedDistance.dy == 0.0 ? correctedTotalTranslation.dy : 0.0,
    );
    return matrix.clone()
      ..setTranslation(Vector3(
        unidirectionalCorrectedTotalTranslation.dx,
        unidirectionalCorrectedTotalTranslation.dy,
        0.0,
      ));
  }

  // Return a new matrix representing the given matrix after applying the given
  // scale.
  // Matrix4 _matrixScale(Matrix4 matrix, double scale) {
  //   if (scale == 1.0) {
  //     return matrix.clone();
  //   }
  //   assert(scale != 0.0);
  //
  //   // Don't allow a scale that results in an overall scale beyond min/max
  //   // scale.
  //   final double currentScale =
  //       _transformationController!.value.getMaxScaleOnAxis();
  //   final double totalScale = math.max(
  //     currentScale * scale,
  //     // Ensure that the scale cannot make the child so big that it can't fit
  //     // inside the boundaries (in either direction).
  //     math.max(
  //       _viewport.width / _boundaryRect.width,
  //       _viewport.height / _boundaryRect.height,
  //     ),
  //   );
  //   // final double clampedTotalScale = clampDouble(
  //   //   totalScale,
  //   //   widget.minScale,
  //   //   widget.maxScale,
  //   // );
  //   // final double clampedScale = clampedTotalScale / currentScale;
  //   return matrix.clone()..scale(clampedScale);
  // }

  // Return a new matrix representing the given matrix after applying the given
  // rotation.
  Matrix4 _matrixRotate(Matrix4 matrix, double rotation, Offset focalPoint) {
    if (rotation == 0) {
      return matrix.clone();
    }
    final Offset focalPointScene = _transformationController!.toScene(
      focalPoint,
    );
    return matrix.clone()
      ..translate(focalPointScene.dx, focalPointScene.dy)
      ..rotateZ(-rotation)
      ..translate(-focalPointScene.dx, -focalPointScene.dy);
  }

  // Returns true iff the given _GestureType is enabled.
  bool _gestureIsSupported(_GestureTypeCross? gestureType) {
    switch (gestureType) {
      case _GestureTypeCross.rotate:
        return _rotateEnabled;

      case _GestureTypeCross.scale:
        return widget.scaleEnabled;

      case _GestureTypeCross.pan:
      case null:
        return widget.panEnabled;
    }
  }

  // Decide which type of gesture this is by comparing the amount of scale
  // and rotation in the gesture, if any. Scale starts at 1 and rotation
  // starts at 0. Pan will have no scale and no rotation because it uses only one
  // finger.
  _GestureTypeCross _getGestureType(ScaleUpdateDetails details) {
    final double scale = !widget.scaleEnabled ? 1.0 : details.scale;

    ///TODO:Mehran removed removed rotations here because he is planning something big
    final double rotation = 0.0;
    // !_rotateEnabled ? 0.0 : details.rotation;
    if ((scale - 1).abs() > rotation.abs()) {
      return _GestureTypeCross.scale;
    } else if (rotation != 0.0) {
      return _GestureTypeCross.rotate;
    } else {
      return _GestureTypeCross.pan;
    }
  }

  // Handle the start of a gesture. All of pan, scale, and rotate are handled
  // with GestureDetector's scale gesture.
  void _onScaleStart(ScaleStartDetails details) {
    widget.onInteractionStart?.call(details);

    if (_controller.isAnimating) {
      _controller.stop();
      _controller.reset();
      _animation?.removeListener(_onAnimate);
      _animation = null;
    }
    if (_scaleController.isAnimating) {
      _scaleController.stop();
      _scaleController.reset();
      // _scaleAnimation?.removeListener(_onScaleAnimate);
      _scaleAnimation = null;
    }

    _gestureType = null;
    _currentAxis = null;
    _scaleStart = _transformationController!.value.getMaxScaleOnAxis();
    _referenceFocalPoint = _transformationController!.toScene(
      details.localFocalPoint,
    );
    _rotationStart = _currentRotation;
  }

  // Handle an update to an ongoing gesture. All of pan, scale, and rotate are
  // handled with GestureDetector's scale gesture.
  void _onScaleUpdate(ScaleUpdateDetails details) {
    // final double scale = _transformationController!.value.getMaxScaleOnAxis();
    _scaleAnimationFocalPoint = details.localFocalPoint;
    final Offset focalPointScene = _transformationController!.toScene(
      details.localFocalPoint,
    );

    if (_gestureType == _GestureTypeCross.pan) {
      // When a gesture first starts, it sometimes has no change in scale and
      // rotation despite being a two-finger gesture. Here the gesture is
      // allowed to be reinterpreted as its correct type after originally
      // being marked as a pan.
      _gestureType = _getGestureType(details);
    } else {
      _gestureType ??= _getGestureType(details);
    }
    if (!_gestureIsSupported(_gestureType)) {
      widget.onInteractionUpdate?.call(details);
      return;
    }

    switch (_gestureType!) {
      case _GestureTypeCross.scale:
        assert(_scaleStart != null);
        // details.scale gives us the amount to change the scale as of the
        // start of this gesture, so calculate the amount to scale as of the
        // previous call to _onScaleUpdate.
        // final double desiredScale = _scaleStart! * details.scale;
        // final double scaleChange = desiredScale / scale;
        // _transformationController!.value = _matrixScale(
        //   _transformationController!.value,
        //   scaleChange,
        // );

        // While scaling, translate such that the user's two fingers stay on
        // the same places in the scene. That means that the focal point of
        // the scale should be on the same place in the scene before and after
        // the scale.
        final Offset focalPointSceneScaled = _transformationController!.toScene(
          details.localFocalPoint,
        );
        _transformationController!.value = _matrixTranslate(
          _transformationController!.value,
          focalPointSceneScaled - _referenceFocalPoint!,
        );

        // details.localFocalPoint should now be at the same location as the
        // original _referenceFocalPoint point. If it's not, that's because
        // the translate came in contact with a boundary. In that case, update
        // _referenceFocalPoint so subsequent updates happen in relation to
        // the new effective focal point.
        final Offset focalPointSceneCheck = _transformationController!.toScene(
          details.localFocalPoint,
        );
        if (_roundCross(_referenceFocalPoint!) !=
            _roundCross(focalPointSceneCheck)) {
          _referenceFocalPoint = focalPointSceneCheck;
        }
        break;

      case _GestureTypeCross.rotate:
        if (details.rotation == 0.0) {
          widget.onInteractionUpdate?.call(details);
          return;
        }
        final double desiredRotation = _rotationStart! + details.rotation;
        _transformationController!.value = _matrixRotate(
          _transformationController!.value,
          _currentRotation - desiredRotation,
          details.localFocalPoint,
        );
        _currentRotation = desiredRotation;
        break;

      case _GestureTypeCross.pan:
        assert(_referenceFocalPoint != null);
        // details may have a change in scale here when scaleEnabled is false.
        // In an effort to keep the behavior similar whether or not scaleEnabled
        // is true, these gestures are thrown away.
        if (details.scale != 1.0) {
          widget.onInteractionUpdate?.call(details);
          return;
        }
        _currentAxis ??=
            _getPanAxisCross(_referenceFocalPoint!, focalPointScene);
        // Translate so that the same point in the scene is underneath the
        // focal point before and after the movement.
        final Offset translationChange =
            focalPointScene - _referenceFocalPoint!;
        _transformationController!.value = _matrixTranslate(
          _transformationController!.value,
          translationChange,
        );
        _referenceFocalPoint = _transformationController!.toScene(
          details.localFocalPoint,
        );
    }
    widget.onInteractionUpdate?.call(details);
  }

  // Handle the end of a gesture of _GestureType. All of pan, scale, and rotate
  // are handled with GestureDetector's scale gesture.
  void _onScaleEnd(ScaleEndDetails details) {
    widget.onInteractionEnd?.call(details);
    _scaleStart = null;
    _rotationStart = null;
    _referenceFocalPoint = null;

    _animation?.removeListener(_onAnimate);
    // _scaleAnimation?.removeListener(_onScaleAnimate);
    _controller.reset();
    _scaleController.reset();

    if (!_gestureIsSupported(_gestureType)) {
      _currentAxis = null;
      return;
    }

    if (_gestureType == _GestureTypeCross.pan) {
      if (details.velocity.pixelsPerSecond.distance < kMinFlingVelocity) {
        _currentAxis = null;
        return;
      }
      final Vector3 translationVector =
          _transformationController!.value.getTranslation();
      final Offset translation =
          Offset(translationVector.x, translationVector.y);
      final FrictionSimulation frictionSimulationX = FrictionSimulation(
        widget.interactionEndFrictionCoefficient,
        translation.dx,
        details.velocity.pixelsPerSecond.dx,
      );
      final FrictionSimulation frictionSimulationY = FrictionSimulation(
        widget.interactionEndFrictionCoefficient,
        translation.dy,
        details.velocity.pixelsPerSecond.dy,
      );
      final double tFinal = _getFinalTimeCross(
        details.velocity.pixelsPerSecond.distance,
        widget.interactionEndFrictionCoefficient,
      );
      _animation = Tween<Offset>(
        begin: translation,
        end: Offset(frictionSimulationX.finalX, frictionSimulationY.finalX),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ));
      _controller.duration = Duration(milliseconds: (tFinal * 1000).round());
      _animation!.addListener(_onAnimate);
      _controller.forward();
    } else if (_gestureType == _GestureTypeCross.scale) {
      if (details.scaleVelocity.abs() < 0.1) {
        _currentAxis = null;
        return;
      }
      final double scale = 1;
      final FrictionSimulation frictionSimulation = FrictionSimulation(
          widget.interactionEndFrictionCoefficient * widget.scaleFactor,
          scale,
          details.scaleVelocity / 10);
      final double tFinal = _getFinalTimeCross(
          details.scaleVelocity.abs(), widget.interactionEndFrictionCoefficient,
          effectivelyMotionless: 0.1);
      _scaleAnimation =
          Tween<double>(begin: scale, end: frictionSimulation.x(tFinal))
              .animate(CurvedAnimation(
                  parent: _scaleController, curve: Curves.decelerate));
      _scaleController.duration =
          Duration(milliseconds: (tFinal * 1000).round());
      // _scaleAnimation!.addListener(_onScaleAnimate);
      _scaleController.forward();
    }
  }

  // Handle mousewheel and web trackpad scroll events.
  void _receivedPointerSignal(PointerSignalEvent event) {
    final double scaleChange;
    if (event is PointerScrollEvent) {
      if (event.kind == PointerDeviceKind.trackpad) {
        // Trackpad scroll, so treat it as a pan.
        widget.onInteractionStart?.call(
          ScaleStartDetails(
            focalPoint: event.position,
            localFocalPoint: event.localPosition,
          ),
        );

        final Offset localDelta = PointerEvent.transformDeltaViaPositions(
          untransformedEndPosition: event.position + event.scrollDelta,
          untransformedDelta: event.scrollDelta,
          transform: event.transform,
        );

        if (!_gestureIsSupported(_GestureTypeCross.pan)) {
          widget.onInteractionUpdate?.call(ScaleUpdateDetails(
            focalPoint: event.position - event.scrollDelta,
            localFocalPoint: event.localPosition - event.scrollDelta,
            focalPointDelta: -localDelta,
          ));
          widget.onInteractionEnd?.call(ScaleEndDetails());
          return;
        }

        final Offset focalPointScene = _transformationController!.toScene(
          event.localPosition,
        );

        final Offset newFocalPointScene = _transformationController!.toScene(
          event.localPosition - localDelta,
        );

        _transformationController!.value = _matrixTranslate(
            _transformationController!.value,
            newFocalPointScene - focalPointScene);

        widget.onInteractionUpdate?.call(ScaleUpdateDetails(
            focalPoint: event.position - event.scrollDelta,
            localFocalPoint: event.localPosition - localDelta,
            focalPointDelta: -localDelta));
        widget.onInteractionEnd?.call(ScaleEndDetails());
        return;
      }
      // Ignore left and right mouse wheel scroll.
      if (event.scrollDelta.dy == 0.0) {
        return;
      }
      scaleChange = math.exp(-event.scrollDelta.dy / widget.scaleFactor);
    } else if (event is PointerScaleEvent) {
      scaleChange = event.scale;
    } else {
      return;
    }
    widget.onInteractionStart?.call(
      ScaleStartDetails(
        focalPoint: event.position,
        localFocalPoint: event.localPosition,
      ),
    );

    if (!_gestureIsSupported(_GestureTypeCross.scale)) {
      widget.onInteractionUpdate?.call(ScaleUpdateDetails(
        focalPoint: event.position,
        localFocalPoint: event.localPosition,
        scale: scaleChange,
      ));
      widget.onInteractionEnd?.call(ScaleEndDetails());
      return;
    }

    final Offset focalPointScene = _transformationController!.toScene(
      event.localPosition,
    );

    // _transformationController!.value = _matrixScale(
    //   _transformationController!.value,
    //   scaleChange,
    // );

    // After scaling, translate such that the event's position is at the
    // same scene point before and after the scale.
    final Offset focalPointSceneScaled = _transformationController!.toScene(
      event.localPosition,
    );
    _transformationController!.value = _matrixTranslate(
      _transformationController!.value,
      focalPointSceneScaled - focalPointScene,
    );

    widget.onInteractionUpdate?.call(ScaleUpdateDetails(
      focalPoint: event.position,
      localFocalPoint: event.localPosition,
      scale: scaleChange,
    ));
    widget.onInteractionEnd?.call(ScaleEndDetails());
  }

  // Handle inertia drag animation.
  void _onAnimate() {
    if (!_controller.isAnimating) {
      _currentAxis = null;
      _animation?.removeListener(_onAnimate);
      _animation = null;
      _controller.reset();
      return;
    }

    // Translate such that the resulting translation is _animation.value.
    final Vector3 translationVector =
        _transformationController!.value.getTranslation();
    final Offset translation = Offset(translationVector.x, translationVector.y);
    final Offset translationScene = _transformationController!.toScene(
      translation,
    );
    final Offset animationScene = _transformationController!.toScene(
      _animation!.value,
    );
    final Offset translationChangeScene = animationScene - translationScene;
    _transformationController!.value = _matrixTranslate(
      _transformationController!.value,
      translationChangeScene,
    );
  }

  // Handle inertia scale animation.
  // void _onScaleAnimate() {
  //   if (!_scaleController.isAnimating) {
  //     _currentAxis = null;
  //     _scaleAnimation?.removeListener(_onScaleAnimate);
  //     _scaleAnimation = null;
  //     _scaleController.reset();
  //     return;
  //   }
  //   // final double desiredScale = _scaleAnimation!.value;
  //   // final double scaleChange =
  //   //     desiredScale / _transformationController!.value.getMaxScaleOnAxis();
  //   final Offset referenceFocalPoint = _transformationController!.toScene(
  //     _scaleAnimationFocalPoint,
  //   );
  //   // _transformationController!.value = _matrixScale(
  //   //   _transformationController!.value,
  //   //   scaleChange,
  //   // );
  //
  //   // While scaling, translate such that the user's two fingers stay on
  //   // the same places in the scene. That means that the focal point of
  //   // the scale should be on the same place in the scene before and after
  //   // the scale.
  //   final Offset focalPointSceneScaled = _transformationController!.toScene(
  //     _scaleAnimationFocalPoint,
  //   );
  //   _transformationController!.value = _matrixTranslate(
  //     _transformationController!.value,
  //     focalPointSceneScaled - referenceFocalPoint,
  //   );
  // }

  void _onTransformationControllerChange() {
    // A change to the CrossScrollController's value is a change to the
    // state.
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _transformationController = MatrixController();
    _transformationController!.addListener(() {
      _onTransformationControllerChange();
      // print(
      //     "Current Offset:${_transformationController?.value.getTranslation()}");
    });
    _controller = AnimationController(
      vsync: this,
    );
    _scaleController = AnimationController(vsync: this);
    _crossController = widget.crossScrollController ?? CrossDiagnolController();

    _crossController!.addListener(() {
      print("THUMB POSITION:${_crossController?.verticalThumbCurrentPosition}");
    });
  }

  @override
  void didUpdateWidget(DiagonalScrollingBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle all cases of needing to dispose and initialize
    // transformationControllers.
    if (oldWidget.crossScrollController == null) {
      if (widget.crossScrollController != null) {
        _transformationController!
            .removeListener(_onTransformationControllerChange);
        _transformationController!.dispose();
        // _transformationController = widget.crossScrollController;
        _transformationController!
            .addListener(_onTransformationControllerChange);
      }
    } else {
      if (widget.crossScrollController == null) {
        _transformationController!
            .removeListener(_onTransformationControllerChange);
        _transformationController!
            .addListener(_onTransformationControllerChange);
      } else if (widget.crossScrollController !=
          oldWidget.crossScrollController) {
        _transformationController!
            .removeListener(_onTransformationControllerChange);
        _crossController = widget.crossScrollController;
        _transformationController!
            .addListener(_onTransformationControllerChange);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    _transformationController!
        .removeListener(_onTransformationControllerChange);
    if (_transformationController == null) {
      _transformationController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size? size;
    Size? maxExtent;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Current screen size (Viewport)
      size = _parentKey.currentContext!.size;

      //Max extent of scroll
      maxExtent = _childKey.currentContext!.size;

      _crossController!
          .listen(context, _transformationController!, maxExtent!, size!);
    });
    _crossController!.keepThumbInRangeWhileResizingScreen();
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Listener(
          key: _parentKey,
          onPointerSignal: _receivedPointerSignal,
          child: GestureDetector(
            behavior:
                HitTestBehavior.opaque, // Necessary when panning off screen.
            onScaleEnd: _onScaleEnd,
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            // trackpadScrollCausesScale: widget.trackpadScrollCausesScale,
            // trackpadScrollToScaleFactor: Offset(0, -1 / widget.scaleFactor),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final Matrix4 matrix = _transformationController!.value;
// RepaintBoundary()
                return _CrossViewerBuilt(
                  childKey: _childKey,
                  clipBehavior: widget.clipBehavior,
                  constrained: widget.constrained,
                  alignment: widget.alignment,
                  matrix: matrix,
                  child: widget.builder!(
                    context,
                    _transformViewportCross(
                        matrix, Offset.zero & constraints.biggest),
                  ),
                );
              },
            ),
          ),
        ),

        ///Vertical TRACK
        CrossScrollThumb(
          thumb: widget.verticalBar,
          axis: Axis.vertical,
          appearance: TrackAppearance.BOTTOM_RIGHT,
          position: _crossController?.verticalThumbCurrentPosition,
          thumbLength: _crossController?.verticalThumbLength ?? 0,
          onDrag: (DragUpdateDetails a) {
            _crossController!.onDrag(a, orientation: Axis.vertical);
          },
        ),

        ///Horizontal Track
        CrossScrollThumb(
          thumb: widget.horizontalBar,
          appearance: TrackAppearance.BOTTOM_RIGHT,
          axis: Axis.horizontal,
          position: _crossController?.horizontalThumbCurrentPosition,
          thumbLength: _crossController?.horizontalThumbLength ?? 0,
          onDrag: (DragUpdateDetails a) {
            _crossController!.onDrag(a, orientation: Axis.horizontal);
          },
        ),
      ],
    );
  }
}

// This widget allows us to easily swap in and out the LayoutBuilder in
// InteractiveViewer's depending on if it's using a builder or a child.
class _CrossViewerBuilt extends StatelessWidget {
  const _CrossViewerBuilt({
    required this.child,
    required this.childKey,
    required this.clipBehavior,
    required this.constrained,
    required this.matrix,
    required this.alignment,
  });

  final Widget child;
  final GlobalKey childKey;
  final Clip clipBehavior;
  final bool constrained;
  final Matrix4 matrix;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    Widget child = Transform(
      transform: matrix,
      alignment: alignment,
      child: KeyedSubtree(
        key: childKey,
        child: this.child,
      ),
    );

    if (!constrained) {
      child = OverflowBox(
        alignment: Alignment.topLeft,
        minWidth: 0.0,
        minHeight: 0.0,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: child,
      );
    }

    return ClipRect(
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}

// A classification of relevant user gestures. Each contiguous user gesture is
// represented by exactly one _GestureType.
enum _GestureTypeCross {
  pan,
  scale,
  rotate,
}

// Given a velocity and drag, calculate the time at which motion will come to
// a stop, within the margin of effectivelyMotionless.
double _getFinalTimeCross(double velocity, double drag,
    {double effectivelyMotionless = 10}) {
  return math.log(effectivelyMotionless / velocity) / math.log(drag / 100);
}

// Return the translation from the given Matrix4 as an Offset.
Offset _getMatrixTranslationCross(Matrix4 matrix) {
  final Vector3 nextTranslation = matrix.getTranslation();
  return Offset(nextTranslation.x, nextTranslation.y);
}

// Transform the four corners of the viewport by the inverse of the given
// matrix. This gives the viewport after the child has been transformed by the
// given matrix. The viewport transforms as the inverse of the child (i.e.
// moving the child left is equivalent to moving the viewport right).
Quad _transformViewportCross(Matrix4 matrix, Rect viewport) {
  final Matrix4 inverseMatrix = matrix.clone()..invert();
  return Quad.points(
    inverseMatrix.transform3(Vector3(
      viewport.topLeft.dx,
      viewport.topLeft.dy,
      0.0,
    )),
    inverseMatrix.transform3(Vector3(
      viewport.topRight.dx,
      viewport.topRight.dy,
      0.0,
    )),
    inverseMatrix.transform3(Vector3(
      viewport.bottomRight.dx,
      viewport.bottomRight.dy,
      0.0,
    )),
    inverseMatrix.transform3(Vector3(
      viewport.bottomLeft.dx,
      viewport.bottomLeft.dy,
      0.0,
    )),
  );
}

// Find the axis aligned bounding box for the rect rotated about its center by
// the given amount.
Quad _getAxisAlignedBoundingBoxWithRotationCross(Rect rect, double rotation) {
  final Matrix4 rotationMatrix = Matrix4.identity()
    ..translate(rect.size.width / 2, rect.size.height / 2)
    ..rotateZ(rotation)
    ..translate(-rect.size.width / 2, -rect.size.height / 2);
  final Quad boundariesRotated = Quad.points(
    rotationMatrix.transform3(Vector3(rect.left, rect.top, 0.0)),
    rotationMatrix.transform3(Vector3(rect.right, rect.top, 0.0)),
    rotationMatrix.transform3(Vector3(rect.right, rect.bottom, 0.0)),
    rotationMatrix.transform3(Vector3(rect.left, rect.bottom, 0.0)),
  );
  return DiagonalScrollingBase.getAxisAlignedBoundingBox(boundariesRotated);
}

// Return the amount that viewport lies outside of boundary. If the viewport
// is completely contained within the boundary (inclusively), then returns
// Offset.zero.
Offset _exceedsByCross(Quad boundary, Quad viewport) {
  final List<Vector3> viewportPoints = <Vector3>[
    viewport.point0,
    viewport.point1,
    viewport.point2,
    viewport.point3,
  ];
  Offset largestExcess = Offset.zero;
  for (final Vector3 point in viewportPoints) {
    final Vector3 pointInside =
        DiagonalScrollingBase.getNearestPointInside(point, boundary);
    final Offset excess = Offset(
      pointInside.x - point.x,
      pointInside.y - point.y,
    );
    if (excess.dx.abs() > largestExcess.dx.abs()) {
      largestExcess = Offset(excess.dx, largestExcess.dy);
    }
    if (excess.dy.abs() > largestExcess.dy.abs()) {
      largestExcess = Offset(largestExcess.dx, excess.dy);
    }
  }

  return _roundCross(largestExcess);
}

// Round the output values. This works around a precision problem where
// values that should have been zero were given as within 10^-10 of zero.
Offset _roundCross(Offset offset) {
  return Offset(
    double.parse(offset.dx.toStringAsFixed(9)),
    double.parse(offset.dy.toStringAsFixed(9)),
  );
}

// Align the given offset to the given axis by allowing movement only in the
// axis direction.
Offset _alignAxisCross(Offset offset, Axis axis) {
  switch (axis) {
    case Axis.horizontal:
      return Offset(offset.dx, 0.0);
    case Axis.vertical:
      return Offset(0.0, offset.dy);
  }
}

// Given two points, return the axis where the distance between the points is
// greatest. If they are equal, return null.
Axis? _getPanAxisCross(Offset point1, Offset point2) {
  if (point1 == point2) {
    return null;
  }
  final double x = point2.dx - point1.dx;
  final double y = point2.dy - point1.dy;
  return x.abs() > y.abs() ? Axis.horizontal : Axis.vertical;
}

/// This enum is used to specify the behavior of the [DiagonalScrollingBase] when
/// the user drags the viewport.
enum PanAxisCross {
  /// The user can only pan the viewport along the horizontal axis.
  horizontal,

  /// The user can only pan the viewport along the vertical axis.
  vertical,

  /// The user can pan the viewport along the horizontal and vertical axes
  /// but not diagonally.
  aligned,

  /// The user can pan the viewport freely in any direction.
  free,
}
