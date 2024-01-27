import 'package:cross_scroll/src/Interactive/controller.dart';
import 'package:cross_scroll/src/Interactive/diagonal_cross_scroll_base.dart';
import 'package:cross_scroll/src/cross_scroll_track.dart';
import 'package:flutter/material.dart';

class DiagonalCrossScroll extends StatelessWidget {
  DiagonalCrossScroll.builder(
      {required this.child,
      this.controller,
      this.normalColor,
      this.hoverColor,
      this.dimColor,
      this.horizontalBar = const CrossScrollTrack(),
      this.verticalBar = const CrossScrollTrack(),
      super.key});
  final Widget child;
  final CrossDiagnolController? controller;

  ///Modify Vertical scroll thumb and track
  final CrossScrollTrack verticalBar;

  ///Modify horizontal scroll thumb and track
  final CrossScrollTrack horizontalBar;

  ///Shown this color when you hovered over a thumb
  ///
  ///when [hoverColor] is null and [CrossScrollBar(thumb:ScrollThumb.hoverShow)] then [normalColor] will be assign to [hoverColor] if [normalColor] not null.
  final Color? hoverColor;

  ///Normal thumb color
  final Color? normalColor;

  ///dim Color
  final Color? dimColor;
  @override
  Widget build(BuildContext context) {
    return DiagonalScrollingBase.builder(
        crossScrollController: controller,
        hoverColor: hoverColor,
        verticalBar: verticalBar,
        horizontalBar: horizontalBar,
        dimColor: dimColor,
        normalColor: normalColor,
        builder: (context, quad) {
          return child;
        });
  }
}
