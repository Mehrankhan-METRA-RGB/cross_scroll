// import 'dart:async';
//
// import 'package:cross_scroll/cross_scroll.dart';
// import 'package:cross_scroll/src/tests/cross_scroll_notifier.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
//
// ///This code has been design by [Mehran Ullah]
// ///email: m.jan9396@gmail.com, m.jan9396@hotmail.com
//
// // class Thumb {
// //   Thumb({this.currentPosition, this.visibility = true, this.thumbWidth});
// //   final double? currentPosition;
// //   final double? thumbWidth;
// //   final bool visibility;
// // }
//
// class TestCrossScroll extends StatefulWidget {
//   ///CrossScroll is a Widget that can scroll on multiple directions and
//   ///support all properties of [SingleChildScrollView].
//   ///Keep [isAlwaysShown:true] while design for Android or IOS so you will
//   ///be able to see your thumb position on screen while scrolling with onDrag property
//   ///i.e: CrossScrollBar(
//   ///         showTrackOnHover: false,
//   ///         trackVisibility: false,
//   ///         isAlwaysShown: true),
//   const TestCrossScroll(
//       {this.child,
//       this.verticalScroll,
//       this.horizontalScroll,
//       this.horizontalScrollController,
//       this.verticalScrollController,
//       this.dimColor,
//       this.normalColor,
//       this.hoverColor,
//       this.horizontalBar = const CrossScrollTrack(),
//       this.verticalBar = const CrossScrollTrack(),
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
//   final CrossScrollTrack? verticalBar;
//
//   ///Modify horizontal scroll thumb and track
//   final CrossScrollTrack? horizontalBar;
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
//   State<TestCrossScroll> createState() => _TestCrossScrollState();
// }
//
// class _TestCrossScrollState extends State<TestCrossScroll> {
//   CrossScrollNotifier notifier = CrossScrollNotifier();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     notifier.initiate(
//         vController: widget.verticalScrollController,
//         hController: widget.horizontalScrollController);
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     notifier.close();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     notifier.width = MediaQuery.of(context).size.width;
//     notifier.height = MediaQuery.of(context).size.height;
//
//     if (notifier.width != notifier.previousWidth ||
//         notifier.height != notifier.previousHeight) {
//       Future.delayed(Duration.zero, () {
//         notifier.initializeControllerValues(Axis.vertical);
//         notifier.initializeControllerValues(Axis.horizontal);
//       });
//       notifier.previousHeight = notifier.height!;
//       notifier.previousWidth = notifier.width!;
//     }
//
//     CrossScrollTrack? vBar = widget.verticalBar;
//     CrossScrollDesign? vStyle = widget.verticalScroll;
//     CrossScrollTrack? hBar = widget.horizontalBar;
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
//               // primary: vStyle?.primary,
//               physics: vStyle?.physics,
//               scrollDirection: Axis.vertical,
//               controller: widget.verticalScrollController ??
//                   notifier.verticalScrollController,
//               child: SingleChildScrollView(
//                 clipBehavior: hStyle?.clipBehavior ?? Clip.hardEdge,
//                 dragStartBehavior: DragStartBehavior.start,
//                 keyboardDismissBehavior: hStyle?.keyboardDismissBehavior ??
//                     ScrollViewKeyboardDismissBehavior.manual,
//                 restorationId: hStyle?.restorationId,
//                 padding: hStyle?.padding,
//                 // primary: hStyle?.primary,
//                 physics: hStyle?.physics,
//                 scrollDirection: Axis.horizontal,
//                 controller: widget.horizontalScrollController ??
//                     notifier.horizontalScrollController,
//                 child: widget.child ?? Container(),
//               ),
//             ),
//           ),
//
//           ///Horizontal Scroll track
//           notifier.horizontalViewPort == notifier.horizontalMaxExtent
//               ? const SizedBox(
//                   width: 0,
//                   height: 0,
//                 )
//               : _scrollTrack(
//                   bar: hBar!,
//                   orientation: Axis.horizontal,
//                 ),
//
//           ///Horizontal scroll thumb
//           notifier.horizontalViewPort == notifier.horizontalMaxExtent
//               ? const SizedBox(
//                   width: 0,
//                   height: 0,
//                 )
//               : _scrollThumb(thumb: hBar!, orientation: Axis.horizontal),
//
//           ///Vertical Scroll track
//           notifier.verticalViewPort == notifier.verticalMaxExtent
//               ? const SizedBox(
//                   width: 0,
//                   height: 0,
//                 )
//               : _scrollTrack(
//                   bar: vBar!,
//                   orientation: Axis.vertical,
//                 ),
//
//           ///Vertical scroll thumb
//           notifier.verticalViewPort == notifier.verticalMaxExtent
//               ? const SizedBox(
//                   width: 0,
//                   height: 0,
//                 )
//               : _scrollThumb(thumb: vBar!, orientation: Axis.vertical),
//         ],
//       ),
//     );
//   }
//
//   BorderRadiusGeometry _thumbRadius(
//       {required CrossScrollTrack bar,
//       required bool hover,
//       required Axis orientation}) {
//     return BorderRadius.all(Radius.elliptical(
//         bar.thumbRadius?.x ?? bar.thickness ?? 8,
//         bar.thumbRadius?.y ?? bar.thickness ?? 8));
//   }
//
//   Color _thumbColor(
//     BuildContext context, {
//     required CrossScrollTrack bar,
//     required bool hover,
//     required Axis orientation,
//   }) {
//     ///called by Cross scroll constructor
//     Color normalColor =
//         widget.normalColor ?? const Color.fromARGB(228, 26, 26, 26);
//     Color dimColor = widget.dimColor ?? const Color.fromARGB(159, 24, 24, 24);
//
//     if (bar.thumb == ScrollThumb.hoverShow ||
//         bar.track == ScrollTrackBehaviour.onHover) {
//       return hover ? widget.hoverColor ?? normalColor : dimColor;
//     } else if (bar.thumb == ScrollThumb.alwaysDim) {
//       return dimColor;
//     } else if (bar.thumb == ScrollThumb.alwaysShow) {
//       return normalColor;
//     } else {
//       return normalColor;
//     }
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
//       {required CrossScrollTrack bar,
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
//               ? notifier.onTrackClick(tapDown,
//                   orientation: orientation,
//                   vCont: widget.verticalScrollController,
//                   hCont: widget.horizontalScrollController)
//               : null,
//           child: InkWell(
//             onHover: (hover) => _isHorizontal
//                 ? notifier.onHoverHorizontalTrack = hover
//                 : notifier.onHoverVerticalTrack = hover,
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
//               key: _isHorizontal
//                   ? notifier.horizontalTrackKey
//                   : notifier.verticalTrackKey,
//               width: !_isHorizontal
//                   ? notifier.onHoverVerticalTrack
//                       ? bar.hoverThickness! + padding * 1.4
//                       : bar.thickness! + padding * 1.4
//                   : null,
//               height: _isHorizontal
//                   ? notifier.onHoverHorizontalTrack
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
//           case ScrollTrackBehaviour.onHover:
//             return _trackWidget(
//               color: notifier.onHoverVerticalTrack ? _trackColor : _noColor,
//               borderColor:
//                   notifier.onHoverVerticalTrack ? _borderColor : _noColor,
//             );
//
//           case ScrollTrackBehaviour.show:
//             return _trackWidget(
//               color: _trackColor,
//               borderColor: _borderColor,
//             );
//           case ScrollTrackBehaviour.hidden:
//             return _trackWidget(
//               color: _noColor,
//               borderColor: _noColor,
//             );
//         }
//
//       case Axis.horizontal:
//         switch (bar.track) {
//           case ScrollTrackBehaviour.onHover:
//             return _trackWidget(
//               color: notifier.onHoverHorizontalTrack ? _trackColor : _noColor,
//               borderColor:
//                   notifier.onHoverHorizontalTrack ? _borderColor : _noColor,
//             );
//
//           case ScrollTrackBehaviour.show:
//             return _trackWidget(
//               color: _trackColor,
//               borderColor: _borderColor,
//             );
//           case ScrollTrackBehaviour.hidden:
//             return _trackWidget(
//               color: _noColor,
//               borderColor: _noColor,
//             );
//         }
//     }
//   }
//
//   Widget _scrollThumb(
//       {required CrossScrollTrack thumb, required Axis orientation}) {
//     bool _isHorizontal = orientation == Axis.horizontal ? true : false;
//     bool _trackHover = _isHorizontal
//         ? notifier.onHoverHorizontalTrack
//         : notifier.onHoverVerticalTrack;
//     double? _thumbThickness() =>
//         _trackHover ? thumb.hoverThickness : thumb.thickness;
//
//     Widget position = Positioned(
//       top: _isHorizontal ? null : notifier.verticalThumbCurrentPosition,
//       bottom: _isHorizontal ? 1 : null,
//       left: !_isHorizontal ? null : notifier.horizontalThumbCurrentPosition,
//       right: !_isHorizontal ? 1 : null,
//       child: SizedBox(
//           height: _isHorizontal
//               ? _thumbThickness()
//               : notifier.verticalThumbWidth < 55
//                   ? 55
//                   : notifier.verticalThumbWidth,
//           width: !_isHorizontal
//               ? _thumbThickness()
//               : notifier.horizontalThumbWidth < 55
//                   ? 55
//                   : notifier.horizontalThumbWidth,
//           child: GestureDetector(
//             // onTapDown: (tip) =>fingerTip= tip.localPosition.dx,
//             onPanUpdate: (drag) =>
//                 notifier.onDrag(drag, orientation: orientation),
//             child: InkWell(
//               onHover: (hover) {
//                 _isHorizontal
//                     ? notifier.onHoverHorizontalTrack = hover
//                     : notifier.onHoverVerticalTrack = hover;
//               },
//               autofocus: true,
//               enableFeedback: true,
//               excludeFromSemantics: true,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: _thumbRadius(
//                       bar: thumb,
//                       hover: _isHorizontal
//                           ? notifier.onHoverHorizontalTrack
//                           : notifier.onHoverVerticalTrack,
//                       orientation: orientation),
//                   color: _thumbColor(context,
//                       bar: thumb,
//                       hover: _isHorizontal
//                           ? notifier.onHoverHorizontalTrack
//                           : notifier.onHoverVerticalTrack,
//                       orientation: orientation),
//                 ),
//               ),
//             ),
//           )),
//     );
//
//     return position;
//   }
// }
