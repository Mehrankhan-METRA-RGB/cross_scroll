// import 'dart:async';
//
// import 'package:cross_scroll/cross_scroll.dart';
// import 'package:cross_scroll/src/Components/cross_scroll_thumb.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
//
// ///This code has been design by [Mehran Ullah]
// ///email: m.jan9396@gmail.com, m.jan9396@hotmail.com
//
// /// A box in which a single widget can be scrolled.
// ///
// /// This widget is useful when you have a single box that will normally be
// /// entirely visible, for example a clock face in a time picker, but you need to
// /// make sure it can be scrolled if the container gets too small in one axis
// /// (the scroll direction).
// ///
// /// It is also useful if you need to shrink-wrap in both axes (the main
// /// scrolling direction as well as the cross axis), as one might see in a dialog
// /// or pop-up menu. In that case, you might pair the [CrossScroll]
// /// with a [ListBody] child that can be scroll in both directions.
// ///
//
// ///
// /// Sometimes a layout is designed around the flexible properties of a
// /// [Column], but there is the concern that in some cases, there might not
// /// be enough room to see the entire contents. This could be because some
// /// devices have unusually small screens, or because the application can
// /// be used in landscape mode where the aspect ratio isn't what was
// /// originally envisioned, or because the application is being shown in a
// /// small window in split-screen mode. In any case, as a result, it might
// /// make sense to wrap the layout in a [CrossScroll].
// ///
// /// Doing so, however, usually results in a conflict between the [Column] or [Row],
// /// which typically tries to grow as big as it can, and the [CrossScroll],
// /// which provides its children with an infinite amount of space.
// ///
// /// To resolve this apparent conflict, there are a couple of techniques, as
// /// discussed below. These techniques should only be used when the content is
// /// normally expected to fit on the screen,
// ///
// /// ### Centering, spacing, or aligning fixed-height content
// ///
// /// If the content has fixed (or intrinsic) dimensions but needs to be spaced out,
// /// centered, or otherwise positioned using the [Flex] layout model of a [Column],
// /// the following technique can be used to provide the [Column] with a minimum
// /// dimension while allowing it to shrink-wrap the contents when there isn't enough
// /// room to apply these spacing or alignment needs.
// ///
// /// A [LayoutBuilder] is used to obtain the size of the viewport (implicitly via
// /// the constraints that the [CrossScroll] sees, since viewports
// /// typically grow to fit their maximum height constraint). Then, inside the
// /// scroll view, a [ConstrainedBox] is used to set the minimum height of the
// /// [Column].
// ///
// /// The [Column] or [Row] has no [Expanded] children, so rather than take on the infinite
// /// height from its [BoxConstraints.maxHeight], (the viewport provides no maximum height
// /// constraint), it automatically tries to shrink to fit its children. It cannot
// /// be smaller than its [BoxConstraints.minHeight], though, and It therefore
// /// becomes the bigger of the minimum height or width provided by the
// /// [ConstrainedBox] and the sum of the heights of the children.
// ///
// /// If the children aren't enough to fit that minimum size, the [Column] ends up
// /// with some remaining space to allocate as specified by its
// /// [Column.mainAxisAlignment] argument.
// ///
// /// {@tool dartpad}
// /// In this example, the children are spaced out equally, unless there's no more
// /// room, in which case they stack vertically and scroll.
// ///
// /// When using this technique, [Expanded] and [Flexible] are not useful, because
// /// in both cases the "available space" is infinite (since this is in a viewport).
// /// The next section describes a technique for providing a maximum height constraint.
// ///
// /// ** See code in examples/api/lib/widgets/single_child_scroll_view/single_child_scroll_view.0.dart **
// /// {@end-tool}
// ///
// /// ### Expanding content to fit the viewport
// ///
// /// The following example builds on the previous one. In addition to providing a
// /// minimum dimension for the child [Column], an [IntrinsicHeight] widget is used
// /// to force the column to be exactly as big as its contents. This constraint
// /// combines with the [ConstrainedBox] constraints discussed previously to ensure
// /// that the column becomes either as big as viewport, or as big as the contents,
// /// whichever is biggest.
// ///
// /// Both constraints must be used to get the desired effect. If only the
// /// [IntrinsicHeight] was specified, then the column would not grow to fit the
// /// entire viewport when its children were smaller than the whole screen. If only
// /// the size of the viewport was used, then the [Column] would overflow if the
// /// children were bigger than the viewport.
// ///
// /// The widget that is to grow to fit the remaining space so provided is wrapped
// /// in an [Expanded] widget.
// ///
// /// This technique is quite expensive, as it more or less requires that the contents
// /// of the viewport be laid out twice (once to find their intrinsic dimensions, and
// /// once to actually lay them out). The number of widgets within the column should
// /// therefore be kept small. Alternatively, subsets of the children that have known
// /// dimensions can be wrapped in a [SizedBox] that has tight vertical constraints,
// /// so that the intrinsic sizing algorithm can short-circuit the computation when it
// /// reaches those parts of the subtree.
//
// class NewCrossScroll extends StatefulWidget {
//   ///CrossScroll is a Widget that can scroll on multiple directions and
//   ///support all properties of [SingleChildScrollView].
//   ///Keep [isAlwaysShown:true] while design for Android or IOS so you will
//   ///be able to see your thumb position on screen while scrolling with onDrag property
//   ///i.e: CrossScrollBar(
//   ///         showTrackOnHover: false,
//   ///         trackVisibility: false,
//   ///         isAlwaysShown: true),
//   const NewCrossScroll(
//       {this.child,
//       this.verticalScroll,
//       this.horizontalScroll,
//       this.horizontalScrollController,
//       this.verticalScrollController,
//       this.dimColor,
//       this.normalColor,
//       this.hoverColor,
//       this.horizontalBar = const CrossScrollBar(),
//       this.verticalBar = const CrossScrollBar(),
//       Key? key})
//       : super(key: key);
//   final Widget? child;
//
//   ///Modify vertical scrolls
//   final CrossScrollDesign? verticalScroll;
//
//   ///Modify horizontal scrolls
//   final CrossScrollDesign? horizontalScroll;
//
//   /// An object that can be used to control the position to which this scroll
//   /// view is scrolled.
//   ///
//   /// A [ScrollController] serves several purposes. It can be used to control
//   /// the initial scroll position (see [ScrollController.initialScrollOffset]).
//   /// It can be used to control whether the scroll view should automatically
//   /// save and restore its scroll position in the [PageStorage] (see
//   /// [ScrollController.keepScrollOffset]). It can be used to read the current
//   /// scroll position (see [ScrollController.offset]), or change it (see
//   /// [ScrollController.animateTo]).
//
//   final ScrollController? horizontalScrollController;
//
//   /// An object that can be used to control the position to which this scroll
//   /// view is scrolled.
//   ///
//   /// A [ScrollController] serves several purposes. It can be used to control
//   /// the initial scroll position (see [ScrollController.initialScrollOffset]).
//   /// It can be used to control whether the scroll view should automatically
//   /// save and restore its scroll position in the [PageStorage] (see
//   /// [ScrollController.keepScrollOffset]). It can be used to read the current
//   /// scroll position (see [ScrollController.offset]), or change it (see
//   /// [ScrollController.animateTo]).
//
//   final ScrollController? verticalScrollController;
//
//   ///Modify Vertical scroll thumb and track
//   final CrossScrollBar? verticalBar;
//
//   ///Modify horizontal scroll thumb and track
//   final CrossScrollBar? horizontalBar;
//
//   ///Shown this color when you hovered over a thumb
//   ///
//   ///when [hoverColor] is null and [CrossScrollBar(thumb:ScrollThumb.hoverShow)] then [normalColor] will be assign to [hoverColor] if [normalColor] not null.
//   final Color? hoverColor;
//
//   ///Normal thumb color
//   final Color? normalColor;
//
//   ///dim Color
//   final Color? dimColor;
//
//   @override
//   State<NewCrossScroll> createState() => _NewCrossScrollState();
// }
//
// class _NewCrossScrollState extends State<NewCrossScroll> {
//   // final ScrollController _horScrollController = ScrollController();
//   final ScrollController horizontalScrollController = ScrollController();
//   final ScrollController verticalScrollController = ScrollController();
//   // final StreamController<Thumb> _streamController = StreamController<Thumb>();
//
//   double? width = 0;
//   double? height = 0;
//   double previousWidth = 0;
//   double previousHeight = 0;
//   double? horizontalFullSize = 0;
//   double? verticalFullSize = 0;
//
//   final _horizontalTrackKey = GlobalKey();
//   final _verticalTrackKey = GlobalKey();
//
//   bool _onHoverHorizontalTrack = false;
//   bool _onHoverVerticalTrack = false;
//
//   ValueNotifier<double?> horizontalThumbCurrentPosition = ValueNotifier(0);
//   ValueNotifier<double?> verticalThumbCurrentPosition = ValueNotifier(0);
//
//   double _horizontalViewPort = 0;
//   double _verticalViewPort = 0;
//   double _horizontalMaxExtent = 0.1;
//   double _verticalMaxExtent = 0.1;
//   double _horizontalThumbWidth = 55;
//   double _verticalThumbWidth = 55;
//
//   ///This method update thumb position while scrolling,
//   /// Platforms [Android and IOS]
//   updateThumbPositionWithScroll(Axis orientation) {
//     ScrollController controller = getController(orientation);
//     // print(controller.position.pixels);
//     // setState(() {
//     if (orientation == Axis.horizontal) {
//       horizontalThumbCurrentPosition.value =
//           (controller.offset) / ratio(orientation);
//     } else {
//       verticalThumbCurrentPosition.value =
//           (controller.position.pixels) / ratio(orientation);
//     }
//     // });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     widget.horizontalScrollController != null
//         ? widget.horizontalScrollController
//             ?.addListener(() => updateThumbPositionWithScroll(Axis.horizontal))
//         : horizontalScrollController
//             .addListener(() => updateThumbPositionWithScroll(Axis.horizontal));
//
//     widget.verticalScrollController != null
//         ? widget.verticalScrollController
//             ?.addListener(() => updateThumbPositionWithScroll(Axis.vertical))
//         : verticalScrollController
//             .addListener(() => updateThumbPositionWithScroll(Axis.vertical));
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     widget.horizontalScrollController != null
//         ? widget.horizontalScrollController?.dispose()
//         : horizontalScrollController.dispose();
//     widget.verticalScrollController != null
//         ? widget.verticalScrollController?.dispose()
//         : verticalScrollController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     width = MediaQuery.of(context).size.width;
//     height = MediaQuery.of(context).size.height;
//     // setState(() {
//     //   print(horizontalScrollController.offset-_thumbSize);
//     //
//     // });
//
// // thumbCurrentPosition=widget.horizontalScrollController?.offset??horizontalScrollController.offset;
//     if (width != previousWidth || height != previousHeight) {
//       Future.delayed(Duration.zero, () {
//         setState(() {
//           initializeControllerValues(Axis.vertical);
//           initializeControllerValues(Axis.horizontal);
//           keepThumbInRangeWhileResizingScreen(Axis.vertical);
//           keepThumbInRangeWhileResizingScreen(Axis.horizontal);
//         });
//       });
//       previousHeight = height!;
//       previousWidth = width!;
//     }
//
//     CrossScrollBar? vBar = widget.verticalBar;
//     CrossScrollDesign? vStyle = widget.verticalScroll;
//     CrossScrollBar? hBar = widget.horizontalBar;
//     CrossScrollDesign? hStyle = widget.horizontalScroll;
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           ScrollConfiguration(
//             behavior:
//                 ScrollConfiguration.of(context).copyWith(scrollbars: false),
//             child: SingleChildScrollView(
//               clipBehavior: vStyle?.clipBehavior ?? Clip.hardEdge,
//               dragStartBehavior: DragStartBehavior.start,
//               keyboardDismissBehavior: vStyle?.keyboardDismissBehavior ??
//                   ScrollViewKeyboardDismissBehavior.manual,
//               restorationId: vStyle?.restorationId,
//               padding: vStyle?.padding,
//               primary: false,
//               // physics: vStyle?.physics,
//               scrollDirection: Axis.vertical,
//               controller:
//                   widget.verticalScrollController ?? verticalScrollController,
//               child: SingleChildScrollView(
//                 clipBehavior: hStyle?.clipBehavior ?? Clip.hardEdge,
//                 dragStartBehavior: DragStartBehavior.start,
//                 keyboardDismissBehavior: hStyle?.keyboardDismissBehavior ??
//                     ScrollViewKeyboardDismissBehavior.manual,
//                 restorationId: hStyle?.restorationId,
//                 padding: hStyle?.padding, primary: false,
//                 // primary: hStyle?.primary,
//                 physics: hStyle?.physics,
//                 scrollDirection: Axis.horizontal,
//                 controller: widget.horizontalScrollController ??
//                     horizontalScrollController,
//                 child: widget.child ?? Container(),
//               ),
//             ),
//           ),
//
//           ///Horizontal Scroll track
//           if (_horizontalViewPort != _horizontalMaxExtent)
//             _scrollTrack(
//               bar: hBar!,
//               orientation: Axis.horizontal,
//             ),
//
//           ///Horizontal scroll thumb
//           if (_horizontalViewPort != _horizontalMaxExtent)
//             ValueListenableBuilder<double?>(
//                 valueListenable: verticalThumbCurrentPosition,
//                 builder: (context, double? vertical, child) {
//                   print("Vertical-Positions:$vertical");
//                   return ValueListenableBuilder<double?>(
//                       valueListenable: horizontalThumbCurrentPosition,
//                       builder: (context, double? horizontal, child) =>
//                           CrossScrollThumb(
//                             axis: Axis.horizontal,
//                             position: vertical,
//                             horizontalThumbCurrentPosition: horizontal,
//                             dimColor: widget.dimColor,
//                             hoverColor: widget.hoverColor,
//                             normalColor: widget.normalColor,
//                             thumb: hBar,
//                             hThumbWidth: _horizontalThumbWidth,
//                             vThumbWidth: _verticalThumbWidth,
//                             onDrag: (drag) =>
//                                 _onDrag(drag, orientation: Axis.horizontal),
//                           ));
//                 }),
//
//           // _scrollThumb(thumb: hBar!, orientation: Axis.horizontal),
//
//           ///Vertical Scroll track
//           if (_verticalViewPort != _verticalMaxExtent)
//             _scrollTrack(
//               bar: vBar!,
//               orientation: Axis.vertical,
//             ),
//
//           ///Vertical scroll thumb
//           if (_verticalViewPort != _verticalMaxExtent)
//             ValueListenableBuilder<double?>(
//                 valueListenable: verticalThumbCurrentPosition,
//                 builder: (context, double? vertical, child) {
//                   print("Vertical-Positions:$vertical");
//                   return ValueListenableBuilder<double?>(
//                     valueListenable: horizontalThumbCurrentPosition,
//                     builder: (context, double? horizontal, child) =>
//                         CrossScrollThumb(
//                       axis: Axis.vertical,
//                       position: vertical,
//                       horizontalThumbCurrentPosition: horizontal,
//                       dimColor: widget.dimColor,
//                       hoverColor: widget.hoverColor,
//                       normalColor: widget.normalColor,
//                       thumb: widget.horizontalBar,
//                       hThumbWidth: _horizontalThumbWidth,
//                       vThumbWidth: _verticalThumbWidth,
//                       onDrag: (drag) =>
//                           _onDrag(drag, orientation: Axis.vertical),
//                     ),
//                   );
//                 }),
//         ],
//       ),
//     );
//   }
//
//   /// get  ratio by fullSize/(visibleSize-thumbSize)
//   double ratio(Axis orientation) {
//     ScrollController? controller;
//     if (orientation == Axis.horizontal) {
//       controller =
//           widget.horizontalScrollController ?? horizontalScrollController;
//     } else {
//       controller = widget.verticalScrollController ?? verticalScrollController;
//     }
//     return (controller.position.maxScrollExtent /
//         (controller.position.viewportDimension - _thumbSize(orientation)));
//   }
//
//   ///get ThumbSize = (viewPortSize / maxExtent - minExtent + viewPortSize) * trackLength
//   double _thumbSize(Axis orientation) {
//     ScrollController? _controller = getController(orientation);
//
//     double _size = (_controller.position.viewportDimension /
//             (_controller.position.maxScrollExtent -
//                 _controller.position.minScrollExtent +
//                 _controller.position.viewportDimension)) *
//         _controller.position.viewportDimension;
//
//     if (_size < 55) {
//       return 55.0;
//     } else {
//       return _size;
//     }
//   }
//
//   double viewPort(Axis orientation) {
//     ScrollController? _controller = getController(orientation);
//     return _controller.position.viewportDimension;
//   }
//
//   double virtualTotalSize(Axis orientation) {
//     ScrollController? _controller = getController(orientation);
//     return _controller.position.maxScrollExtent;
//   }
//
//   double jumpTo(delta, Axis orientation) {
//     ScrollController _controller = getController(orientation);
//     return (delta * ratio) + _controller.offset;
//   }
//
//   double trackLength(Axis orientation) {
//     return orientation == Axis.horizontal
//         ? _horizontalTrackKey.currentContext!.size!.width
//         : _verticalTrackKey.currentContext!.size!.width;
//   }
//
//   void _onDrag(DragUpdateDetails a, {required Axis orientation}) {
//     // if (kDebugMode) {
//     //   // print('thumbCurrentPosition: ${thumbCurrentPosition!}');
//     // }
//     if (orientation == Axis.horizontal) {
//       ///horizontal
//
//       if (0 > horizontalThumbCurrentPosition.value!) {
//         horizontalThumbCurrentPosition.value = 0;
//       } else if (horizontalThumbCurrentPosition.value! >
//           viewPort(orientation) - _thumbSize(orientation)) {
//         horizontalThumbCurrentPosition.value =
//             viewPort(orientation) - _thumbSize(orientation);
//       } else if (0 <= horizontalThumbCurrentPosition.value! &&
//           horizontalThumbCurrentPosition.value! <=
//               viewPort(orientation) - _thumbSize(orientation)) {
//         horizontalThumbCurrentPosition.value =
//             horizontalThumbCurrentPosition.value! + a.delta.dx;
//         if (horizontalThumbCurrentPosition.value! != 0 ||
//             horizontalThumbCurrentPosition.value! !=
//                 viewPort(orientation) - _thumbSize(orientation)) {
//           getController(orientation).jumpTo(
//               horizontalThumbCurrentPosition.value! * ratio(orientation));
//           // if (kDebugMode) {
//           //   print('JumpTo:${thumbCurrentPosition! * ratio}');
//           // }
//         }
//       }
//     } else {
//       ///vertical
//       print(a.delta.dy);
//       if (verticalThumbCurrentPosition.value! < 0) {
//         verticalThumbCurrentPosition.value = 0;
//       } else if (verticalThumbCurrentPosition.value! >
//           viewPort(orientation) - _thumbSize(orientation)) {
//         verticalThumbCurrentPosition.value =
//             viewPort(orientation) - _thumbSize(orientation);
//       } else if (verticalThumbCurrentPosition.value! >= 0 &&
//           verticalThumbCurrentPosition.value! <=
//               viewPort(orientation) - _thumbSize(orientation)) {
//         verticalThumbCurrentPosition.value =
//             verticalThumbCurrentPosition.value! + a.delta.dy;
//         if (verticalThumbCurrentPosition.value! != 0 ||
//             verticalThumbCurrentPosition.value! !=
//                 viewPort(orientation) - _thumbSize(orientation)) {
//           getController(orientation)
//               .jumpTo(verticalThumbCurrentPosition.value! * ratio(orientation));
//         }
//       }
//     }
//   }
//
//   void onTrackClick(TapDownDetails tapDownDetails,
//       {required Axis orientation}) {
//     // print(tapDownDetails.localPosition.dy);
//     // print(verticalThumbCurrentPosition);
//     // print(_verticalThumbWidth);
//
//     ScrollController _hController =
//         widget.horizontalScrollController ?? horizontalScrollController;
//     ScrollController _vController =
//         widget.verticalScrollController ?? verticalScrollController;
//
//     double _horizontalTrackLengthFromThumbPoint =
//         horizontalThumbCurrentPosition.value! + _horizontalThumbWidth;
//     double _verticalTrackLengthFromThumbPoint =
//         verticalThumbCurrentPosition.value! + _verticalThumbWidth;
//
//     if (orientation == Axis.horizontal) {
//       ///horizontal track
//       if (tapDownDetails.localPosition.dx >
//           horizontalThumbCurrentPosition.value!) {
//         if (_horizontalTrackLengthFromThumbPoint <
//             _horizontalViewPort - _horizontalThumbWidth) {
//           // print('+ive\nless than _viewport - _thumbWidth');
//
//           horizontalThumbCurrentPosition.value =
//               horizontalThumbCurrentPosition.value! + _horizontalThumbWidth;
//           _hController.animateTo(
//               horizontalThumbCurrentPosition.value! * ratio(orientation),
//               duration: const Duration(
//                 milliseconds: 300,
//               ),
//               curve: Curves.linear);
//         } else {
//           horizontalThumbCurrentPosition.value =
//               _horizontalViewPort - _horizontalThumbWidth;
//           _hController.animateTo(
//               horizontalThumbCurrentPosition.value! * ratio(orientation),
//               duration: const Duration(
//                 milliseconds: 300,
//               ),
//               curve: Curves.linear);
//         }
//       } else if (tapDownDetails.localPosition.dx <
//           horizontalThumbCurrentPosition.value!) {
//         if (horizontalThumbCurrentPosition.value! > _horizontalThumbWidth) {
//           // print('_crnt$_crnt');
//           // print('_thumbWidth$_thumbWidth');
//           // print('-ive\ngreater than thumb');
//           horizontalThumbCurrentPosition.value =
//               horizontalThumbCurrentPosition.value! - _horizontalThumbWidth;
//           _hController.animateTo(
//               horizontalThumbCurrentPosition.value! * ratio(orientation),
//               duration: const Duration(
//                 milliseconds: 300,
//               ),
//               curve: Curves.linear);
//         } else if (horizontalThumbCurrentPosition.value! <
//             _horizontalThumbWidth) {
//           // print('-ive\nless than thumb');
//           horizontalThumbCurrentPosition.value = 0;
//           _hController.animateTo(
//               horizontalThumbCurrentPosition.value! * ratio(orientation),
//               duration: const Duration(
//                 milliseconds: 300,
//               ),
//               curve: Curves.linear);
//         }
//       }
//     } else {
//       ///vertical track
//       if (tapDownDetails.localPosition.dy >
//           verticalThumbCurrentPosition.value!) {
//         if (_verticalTrackLengthFromThumbPoint <
//             _verticalViewPort - _verticalThumbWidth) {
//           // print('+ive\nless than _viewport - _thumbWidth');
//
//           verticalThumbCurrentPosition.value =
//               verticalThumbCurrentPosition.value! + _verticalThumbWidth;
//           _vController.animateTo(
//               verticalThumbCurrentPosition.value! * ratio(orientation),
//               duration: const Duration(
//                 milliseconds: 300,
//               ),
//               curve: Curves.linear);
//         } else {
//           verticalThumbCurrentPosition.value =
//               _verticalViewPort - _verticalThumbWidth;
//           _vController.animateTo(
//               verticalThumbCurrentPosition.value! * ratio(orientation),
//               duration: const Duration(
//                 milliseconds: 300,
//               ),
//               curve: Curves.linear);
//         }
//       } else if (tapDownDetails.localPosition.dy <
//           verticalThumbCurrentPosition.value!) {
//         if (verticalThumbCurrentPosition.value! > _verticalThumbWidth) {
//           // print('_crnt$_crnt');
//           // print('_thumbWidth$_thumbWidth');
//           // print('-ive\ngreater than thumb');
//           verticalThumbCurrentPosition.value =
//               verticalThumbCurrentPosition.value! - _verticalThumbWidth;
//           _vController.animateTo(
//               verticalThumbCurrentPosition.value! * ratio(orientation),
//               duration: const Duration(
//                 milliseconds: 300,
//               ),
//               curve: Curves.linear);
//         } else if (verticalThumbCurrentPosition.value! < _verticalThumbWidth) {
//           // print('-ive\nless than thumb');
//           verticalThumbCurrentPosition.value = 0;
//           _vController.animateTo(
//               verticalThumbCurrentPosition.value! * ratio(orientation),
//               duration: const Duration(
//                 milliseconds: 300,
//               ),
//               curve: Curves.linear);
//         }
//       }
//     }
//   }
//
//   void keepThumbInRangeWhileResizingScreen(Axis orientation) {
//     bool _isHorizontal = orientation == Axis.horizontal ? true : false;
//     double _thumbCurrentPosition = _isHorizontal
//         ? horizontalThumbCurrentPosition.value!
//         : verticalThumbCurrentPosition.value!;
//     if (_thumbCurrentPosition >
//         viewPort(orientation) - _thumbSize(orientation)) {
//       _thumbCurrentPosition = viewPort(orientation) - _thumbSize(orientation);
//       getController(orientation)
//           .jumpTo(_thumbCurrentPosition * ratio(orientation));
//     }
//   }
//
//   void initializeControllerValues(Axis orientation) {
//     bool _isHorizontal = orientation == Axis.horizontal ? true : false;
//     ScrollController _controller = getController(orientation);
//     if (_isHorizontal) {
//       ///horizontal
//       horizontalFullSize = _controller.position.maxScrollExtent;
//       _horizontalMaxExtent = (_controller.position.viewportDimension +
//           _controller.position.maxScrollExtent);
//       _horizontalViewPort = _controller.position.viewportDimension;
//       _horizontalThumbWidth = _thumbSize(orientation);
//     } else {
//       ///Vertical
//       verticalFullSize = _controller.position.maxScrollExtent;
//       _verticalMaxExtent = (_controller.position.viewportDimension +
//           _controller.position.maxScrollExtent);
//       _verticalViewPort = _controller.position.viewportDimension;
//       _verticalThumbWidth = _thumbSize(orientation);
//     }
//   }
//
//   ScrollController getController(Axis orientation) {
//     return orientation == Axis.vertical
//         ? widget.verticalScrollController ?? verticalScrollController
//         : widget.horizontalScrollController ?? horizontalScrollController;
//   }
//
//   ///if no color provided, default colors will be assign
//   ///
//   ///[trackColor]??Colors.black.withOpacity(0.03);
//   ///
//   ///[noColor]??Colors.transparent;
//   ///
//   ///[borderColor]??Colors.black.withOpacity(0.0851);
//
//   Widget _scrollTrack(
//       {required CrossScrollBar bar,
//       required Axis orientation,
//       Color? trackColor,
//       Color? noColor,
//       Color? borderColor}) {
//     bool? _isHorizontal = Axis.horizontal == orientation ? true : false;
//
//     Color _trackColor = trackColor ?? Colors.black.withOpacity(0.03);
//     Color _noColor = noColor ?? Colors.transparent;
//     Color _borderColor = borderColor ?? Colors.black.withOpacity(0.0851);
//
//     Widget _trackWidget({
//       bool isOnTapScroll = true,
//       required Color color,
//       required Color borderColor,
//       double padding = 2,
//     }) =>
//         GestureDetector(
//           onTapDown: (tapDown) => isOnTapScroll
//               ? onTrackClick(tapDown, orientation: orientation)
//               : null,
//           child: InkWell(
//             onHover: (hover) => setState(() => _isHorizontal
//                 ? _onHoverHorizontalTrack = hover
//                 : _onHoverVerticalTrack = hover),
//             child: Container(
//               alignment: Alignment.center,
//               padding: EdgeInsets.symmetric(
//                   vertical: _isHorizontal ? padding : 0,
//                   horizontal: !_isHorizontal ? padding : 0),
//               decoration: BoxDecoration(
//                   color: color,
//                   border: Border(
//                       left: !_isHorizontal
//                           ? BorderSide(width: 0.8, color: borderColor)
//                           : BorderSide(width: 0, color: Colors.transparent),
//                       top: _isHorizontal
//                           ? BorderSide(width: 0.8, color: borderColor)
//                           : BorderSide(width: 0, color: Colors.transparent))),
//               key: _isHorizontal ? _horizontalTrackKey : _verticalTrackKey,
//               width: !_isHorizontal
//                   ? _onHoverVerticalTrack
//                       ? bar.hoverThickness! + padding * 1.4
//                       : bar.thickness! + padding * 1.4
//                   : null,
//               height: _isHorizontal
//                   ? _onHoverHorizontalTrack
//                       ? bar.hoverThickness! + padding * 1.4
//                       : bar.thickness! + padding * 1.4
//                   : null,
//             ),
//           ),
//         );
//
//     /// orientation switch
//     switch (orientation) {
//       case Axis.vertical:
//
//         ///track bar switch
//         switch (bar.track) {
//           case ScrollTrack.onHover:
//             return _trackWidget(
//               color: _onHoverVerticalTrack ? _trackColor : _noColor,
//               borderColor: _onHoverVerticalTrack ? _borderColor : _noColor,
//             );
//
//           case ScrollTrack.show:
//             return _trackWidget(
//               color: _trackColor,
//               borderColor: _borderColor,
//             );
//           case ScrollTrack.hidden:
//             return _trackWidget(
//               color: _noColor,
//               borderColor: _noColor,
//             );
//         }
//
//       case Axis.horizontal:
//         switch (bar.track) {
//           case ScrollTrack.onHover:
//             return _trackWidget(
//               color: _onHoverHorizontalTrack ? _trackColor : _noColor,
//               borderColor: _onHoverHorizontalTrack ? _borderColor : _noColor,
//             );
//
//           case ScrollTrack.show:
//             return _trackWidget(
//               color: _trackColor,
//               borderColor: _borderColor,
//             );
//           case ScrollTrack.hidden:
//             return _trackWidget(
//               color: _noColor,
//               borderColor: _noColor,
//             );
//         }
//     }
//   }
// }
