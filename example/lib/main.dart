import 'dart:math';

import 'package:cross_scroll/cross_scroll.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cross Scroll',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          // Stack(
          //   children: [
          //     Positioned(
          //         right: 0,
          //         child: SizedBox(
          //             height: MediaQuery.of(context).size.height,
          //             width: 50,
          //             child: MovableContainer(
          //               width: 30,
          //               height: 200,
          //               axis: Axis.vertical,
          //             ))),
          //     Positioned(
          //         bottom: 0,
          //         child: SizedBox(
          //             height: 50,
          //             width: MediaQuery.of(context).size.width,
          //             child: MovableContainer(
          //               width: 100,
          //               height: 50,
          //               axis: Axis.horizontal,
          //             )))
          //   ],
          // )

          Example(),
    );
  }
}

class Example extends StatelessWidget {
  Example({Key? key}) : super(key: key);
  final random = Random();
  @override
  Widget build(BuildContext context) {
    return InteractiveViewerScroll(
      ///Optional
      // normalColor: Colors.blue,
      ///Optional
      // hoverColor: Colors.red,
      ///Optional
      // dimColor: Colors.red.withOpacity(0.4),
      ///design track and thumb
      // verticalBar: const CrossScrollBar(),
      // horizontalBar: const CrossScrollBar(),

      child: Column(
        children: [
          for (var i = 1; i < 50; i++)
            Row(
              children: [
                for (var i = 1; i < 50; i++)
                  Container(
                      margin: const EdgeInsets.all(2),
                      width: 500,
                      height: 300,

                      ///get random color for container
                      color: Color.fromARGB(255, random.nextInt(255),
                          random.nextInt(255), random.nextInt(255))),
              ],
            )
        ],
      ),
    );
  }
}

class MyInteractiveViewerWidget extends StatelessWidget {
  MyInteractiveViewerWidget({super.key});
  final GlobalKey myWidgetKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    TransformationController _controller = TransformationController();
    double? widgetWidth = 1;
    double? widgetHeight = 1;
    _controller.addListener(() {
      double currentScale = _controller.value.getMaxScaleOnAxis();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Size? size = myWidgetKey.currentContext?.size;
      });
      print("Scale:$currentScale");
      print(
          'Widget Size: Width = ${(widgetWidth ?? 1) * currentScale}, Height = ${(widgetHeight ?? 1) * currentScale}');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mehran Ullah Khan'),
      ),
      body: InteractiveViewer.builder(
        scaleEnabled: true,
        transformationController: _controller,
        builder: (context, quad) {
          return SizedBox(
            key: myWidgetKey,
            child: Column(
              children: [
                for (var j = 1; j < 50; j++)
                  Row(
                    children: [
                      for (var i = 1; i < 50; i++)
                        Container(
                            margin: const EdgeInsets.all(2),
                            width: 500,
                            height: 300,

                            ///get random color for container
                            color: Color.fromARGB(255, i + 20, j + 30, j + 60)),
                    ],
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
