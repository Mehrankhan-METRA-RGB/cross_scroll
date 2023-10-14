import 'package:cross_scroll/cross_scroll.dart';
import 'package:cross_scroll/src/Interactive/controller.dart';
import 'package:cross_scroll/src/Interactive/daignol_scrolling.dart';
import 'package:flutter/material.dart';

class InteractiveViewerScroll extends StatelessWidget {
  const InteractiveViewerScroll({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    MatrixController _controller = MatrixController();
    GlobalKey _key = GlobalKey();
    _controller.addListener(() {
      print("= = = = = = = = = = = = = = = = = = = =");

      print(
          "absolute Transitions: ${_controller.value.absolute().getTranslation()}");
      // print("dimension: ${_controller.value.dimension}");
      // print("right: ${_controller.value.right}");
      // print("up: ${_controller.value.up}");
      // print("getTranslation: ${_controller.value}");

      print("= = = = = = = = = = = = = = = = = = = =");
    });

    return CrossScrollViewer.builder(
        crossScrollController: _controller,
        trackpadScrollCausesScale: false,
        builder: (context, quad) {
          return SizedBox(key: _key, child: child);
        });
  }
}
