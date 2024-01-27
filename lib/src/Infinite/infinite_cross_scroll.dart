import 'dart:math' as math;

import 'package:cross_scroll/src/Infinite/crontroller.dart';
import 'package:cross_scroll/src/cross_scroll_decor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InfiniteCrossScroll extends StatefulWidget {
  const InfiniteCrossScroll(
      {this.controller,
      required this.maxRows,
      required this.maxColumns,
      required this.cellSize,
      required this.builder,
      this.horizontalScroll = const CrossScrollDesign(),
      this.verticalScroll = const CrossScrollDesign(),
      this.diagonalDragBehavior = DiagonalDragBehavior.free,
      this.dragStartBehavior = DragStartBehavior.start,
      this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
      this.primary,
      this.cacheExtent,
      super.key});
  final CrossScrollController? controller;

  final Size cellSize;
  final int? maxRows;
  final bool? primary;
  final CrossScrollDesign horizontalScroll;
  final CrossScrollDesign verticalScroll;
  final int? maxColumns;
  final Widget? Function(BuildContext, ChildVicinity) builder;
  final DiagonalDragBehavior diagonalDragBehavior;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final double? cacheExtent;

  @override
  State<InfiniteCrossScroll> createState() => _InfiniteCrossScrollState();
}

class _InfiniteCrossScrollState extends State<InfiniteCrossScroll> {
  ScrollController? _hController;
  ScrollController? _vController;
  late CrossScrollController primary;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    primary = widget.controller ?? CrossScrollController();
    _hController = ScrollController(
        initialScrollOffset: primary.initialScrollOffset.dx,
        keepScrollOffset: primary.keepScrollOffset,
        debugLabel: primary.debugLabel,
        onAttach: primary.onAttach,
        onDetach: primary.onDetach);
    _vController = ScrollController(
        initialScrollOffset: primary.initialScrollOffset.dy,
        keepScrollOffset: primary.keepScrollOffset,
        debugLabel: primary.debugLabel,
        onAttach: primary.onAttach,
        onDetach: primary.onDetach);
    primary.init(h: _hController!, v: _vController!, cellSize: widget.cellSize);
  }

  @override
  void didUpdateWidget(covariant InfiniteCrossScroll oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("DID UPDATE");
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TwoDimensionalGridView(
        // key: widget.key,
        controller: primary,
        primary: widget.primary,
        diagonalDragBehavior: widget.diagonalDragBehavior,
        dragStartBehavior: widget.dragStartBehavior,
        cacheExtent: widget.cacheExtent,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        verticalDetails: ScrollableDetails.vertical(
            controller: _vController,
            reverse: widget.verticalScroll.reverse,
            physics: widget.verticalScroll.physics,
            decorationClipBehavior: widget.verticalScroll.clipBehavior),
        horizontalDetails: ScrollableDetails.horizontal(
            controller: _hController,
            reverse: widget.horizontalScroll.reverse,
            physics: widget.horizontalScroll.physics,
            decorationClipBehavior: widget.horizontalScroll.clipBehavior),
        delegate: TwoDimensionalChildBuilderDelegate(
            maxXIndex: widget.maxRows,
            maxYIndex: widget.maxColumns,
            builder: widget.builder),
      ),
    );
  }
}

class TwoDimensionalGridView extends TwoDimensionalScrollView {
  const TwoDimensionalGridView({
    super.key,
    required this.controller,
    super.primary,
    super.mainAxis = Axis.vertical,
    super.verticalDetails = const ScrollableDetails.vertical(),
    super.horizontalDetails = const ScrollableDetails.horizontal(),
    required TwoDimensionalChildBuilderDelegate delegate,
    super.cacheExtent,
    super.diagonalDragBehavior = DiagonalDragBehavior.none,
    super.dragStartBehavior = DragStartBehavior.start,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  final CrossScrollController controller;

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
  ) {
    return TwoDimensionalGridViewport(
      controller: controller,
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalDetails.direction,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalDetails.direction,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }
}

class TwoDimensionalGridViewport extends TwoDimensionalViewport {
  const TwoDimensionalGridViewport({
    super.key,
    required this.controller,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required TwoDimensionalChildBuilderDelegate super.delegate,
    required super.mainAxis,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  });
  final CrossScrollController controller;

  @override
  RenderTwoDimensionalViewport createRenderObject(BuildContext context) {
    return RenderTwoDimensionalGridViewport(
      controller: controller,
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalAxisDirection,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalAxisDirection,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      childManager: context as TwoDimensionalChildManager,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTwoDimensionalGridViewport renderObject,
  ) {
    renderObject
      ..horizontalOffset = horizontalOffset
      ..horizontalAxisDirection = horizontalAxisDirection
      ..verticalOffset = verticalOffset
      ..verticalAxisDirection = verticalAxisDirection
      ..mainAxis = mainAxis
      ..delegate = delegate
      ..cacheExtent = cacheExtent
      ..clipBehavior = clipBehavior;
  }
}

class RenderTwoDimensionalGridViewport extends RenderTwoDimensionalViewport {
  RenderTwoDimensionalGridViewport({
    required this.controller,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required TwoDimensionalChildBuilderDelegate delegate,
    required super.mainAxis,
    required super.childManager,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);
  final CrossScrollController controller;

  @override
  void layoutChildSequence() {
    final double horizontalPixels = horizontalOffset.pixels;
    final double verticalPixels = verticalOffset.pixels;
    final double viewportWidth = viewportDimension.width + cacheExtent;
    final double viewportHeight = viewportDimension.height + cacheExtent;
    final TwoDimensionalChildBuilderDelegate builderDelegate =
        delegate as TwoDimensionalChildBuilderDelegate;
    Size tileSize = controller.size;

    final int maxRowIndex = builderDelegate.maxYIndex!;
    final int maxColumnIndex = builderDelegate.maxXIndex!;

    final int leadingColumn =
        math.max((horizontalPixels / tileSize.width).floor(), 0);
    final int leadingRow =
        math.max((verticalPixels / tileSize.height).floor(), 0);
    final int trailingColumn = math.min(
      ((horizontalPixels + viewportWidth) / tileSize.width).ceil(),
      maxColumnIndex,
    );
    final int trailingRow = math.min(
      ((verticalPixels + viewportHeight) / tileSize.height).ceil(),
      maxRowIndex,
    );

    double xLayoutOffset =
        (leadingColumn * tileSize.width) - horizontalOffset.pixels;
    for (int column = leadingColumn; column <= trailingColumn; column++) {
      double yLayoutOffset =
          (leadingRow * tileSize.height) - verticalOffset.pixels;
      for (int row = leadingRow; row <= trailingRow; row++) {
        final ChildVicinity vicinity =
            ChildVicinity(xIndex: column, yIndex: row);
        final RenderBox child = buildOrObtainChildFor(vicinity)!;
        child.layout(constraints.loosen());

        // Subclasses only need to set the normalized layout offset. The super
        // class adjusts for reversed axes.
        parentDataOf(child).layoutOffset = Offset(xLayoutOffset, yLayoutOffset);
        yLayoutOffset += tileSize.height;
      }
      xLayoutOffset += tileSize.width;
    }

    // Set the min and max scroll extents for each axis.
    final double verticalExtent = tileSize.height * (maxRowIndex + 1);
    verticalOffset.applyContentDimensions(
      0.0,
      clampDouble(
          verticalExtent - viewportDimension.height, 0.0, double.infinity),
    );
    final double horizontalExtent = tileSize.width * (maxColumnIndex + 1);
    horizontalOffset.applyContentDimensions(
      0.0,
      clampDouble(
          horizontalExtent - viewportDimension.width, 0.0, double.infinity),
    );
    // Super class handles garbage collection too!
  }
}
