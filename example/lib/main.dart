import 'dart:math';

import 'package:cross_scroll/cross_scroll.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  CrossScrollController controller = CrossScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      print("XPosition:${controller.offsetX}");
      print("YPosition:${controller.offsetY}");
    });
  }

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
          // Example(),

          CrossScrollBar(
        controller: controller,
        child: InfiniteCrossScroll(
          maxRows: 10,
          maxColumns: 10,
          controller: controller,
          cellSize: const Size(150, 150),
          builder: (context, vicinity) => Container(
            height: 150,
            width: 150,
            color: Color.fromARGB(255, Random().nextInt(255),
                Random().nextInt(255), Random().nextInt(255)),
          ),
        ),
      ),

      //     Stack(
      //   children: [
      //     CrossScrollBar(
      //       controller: controller,
      //       child: CrossScrollInfinite(
      //         maxRows: 10,
      //         maxColumns: 10,
      //         controller: controller,
      //         cellSize: const Size(150, 150),
      //         builder: (context, vicinity) => Container(
      //           height: 150,
      //           width: 150,
      //           color: Color.fromARGB(255, Random().nextInt(255),
      //               Random().nextInt(255), Random().nextInt(255)),
      //         ),
      //       ),
      //     ),
      //     ElevatedButton(
      //         onPressed: () {
      //           controller.animateXTo(20,
      //               duration: const Duration(seconds: 1), curve: Curves.linear);
      //           controller.animateYTo(20,
      //               duration: const Duration(seconds: 1), curve: Curves.linear);
      //           // controller.jumpYTo(130);
      //         },
      //         child: const Text("JUMP"))
      //   ],
      // ),
    );
  }
}

class Example extends StatelessWidget {
  Example({Key? key}) : super(key: key);
  final random = Random();
  @override
  Widget build(BuildContext context) {
    final List<Color?> rowColors = [
      Colors.blue[100],
      Colors.green[100],
      Colors.orange[100],
      Colors.pink[100],
      Colors.purple[100],
    ];
    return Scaffold(
        body: DiagonalCrossScroll.builder(
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
          for (var j = 1; j < 10; j++)
            Row(
              children: [
                for (var i = 1; i < 10; i++)
                  Container(
                      margin: const EdgeInsets.all(2),
                      width: 500,
                      height: 500,

                      ///get random color for container
                      color: Color.fromARGB(255, random.nextInt(255),
                          random.nextInt(255), random.nextInt(255))),
              ],
            )
        ],
      ),

      // DataTable(
      //   columns: List<DataColumn>.generate(
      //     60, // Number of columns
      //     (int index) => DataColumn(
      //       label: Text('Column ${index + 1}'),
      //     ),
      //   ),
      //   rows: List<DataRow>.generate(
      //     100, // Number of rows
      //     (int rowIndex) => DataRow(
      //       color: MaterialStateProperty.resolveWith<Color>(
      //         (Set<MaterialState> states) {
      //           return rowColors[rowIndex % rowColors.length]!;
      //         },
      //       ),
      //       cells: List<DataCell>.generate(
      //         60, // Number of cells in each row
      //         (int cellIndex) => DataCell(
      //           Text(
      //               'Data $cellIndex, Row $rowIndex'), // Replace with your dummy data
      //         ),
      //       ),
      //     ),
      //   ),
      //
      //
      // ),
    ));
  }
}

class CustomWidget extends StatelessWidget {
  const CustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    print("WIDTH:${MediaQuery.sizeOf(context).width}");
    return MaterialApp(
        color: Colors.grey,
        home: CustomPaint(
            size: const Size(550, 250), painter: RPSCustomPainter()));
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paintFill0 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    Paint paintStroke0 = Paint()
      ..color = const Color.fromARGB(255, 126, 177, 219)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path_0 = Path();

    // path_0.moveTo(size.width, size.height);

    ///TOP Left corner
    path_0.lineTo(0, 0);

    ///TOP Right corner
    path_0.lineTo(size.width, 0);

    path_0.lineTo(size.width, size.height * 0.2);
    for (Offset offset in createHalfCircleAntiClockwise(
        Offset(size.width + 2, size.height * 0.6),
        Offset(size.width + 2, size.height * 0.5),
        4)) {
      // if (i > 2 && i < 700) {
      path_0.lineTo(offset.dx, offset.dy);
      print(offset);
      // }
      // if (i > 700) {
      //   break;
      // }
      // print(i);
    }

    path_0.lineTo(size.width, size.height * 0.5);

    ///BOTTOM RIGHT CORNER
    path_0.lineTo(size.width, size.height);

    ///BOTTOM LEFT CORNER
    path_0.lineTo(0, size.height);

    for (Offset offset in fullCircle(
            Offset(0, size.height * 0.5), Offset(0, size.height * 0.6), 4)
        .reversed) {
      // if (i > 2 && i < 700) {
      path_0.lineTo(offset.dx, offset.dy);
      print(offset);
      // }
      // if (i > 700) {
      //   break;
      // }
      // print(i);
    }

    ///JOIN TOP LEFT AGAIN
    path_0.lineTo(0, 0);

    path_0.close();

    canvas.drawPath(path_0, paintFill0);
    canvas.drawPath(path_0, paintStroke0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  List<Offset> fullCircle(Offset start, Offset end, double angle) {
    final double centerX = (start.dx + end.dx) / 2;
    final double centerY = (start.dy + end.dy) / 2;
    final double radius = centerY / 2;

    final double startAngle = atan2(start.dy - centerY, start.dx - centerX);
    final double sweepAngle = angle;

    final List<Offset> points = [];
    const double step = 0.1; // Adjust this value for the desired granularity.

    for (double theta = startAngle;
        theta < startAngle + sweepAngle;
        theta += step) {
      final double x = centerX + radius * cos(theta);
      final double y = centerY + radius * sin(theta);
      points.add(Offset(x, y));
    }
    points.removeAt(points.length - 1);

    return points;
  }

  List<Offset> createHalfCircleAntiClockwise(
      Offset start, Offset end, double angle) {
    final double centerX = (start.dx + end.dx) / 2;
    final double centerY = (start.dy + end.dy) / 2;
    final double radius = centerY / 2;

    final double startAngle = atan2(start.dy - centerY, start.dx - centerX);
    final double sweepAngle = angle;

    final List<Offset> points = [];
    const double step = 0.01; // Adjust this value for the desired granularity.

    for (double theta = startAngle + sweepAngle;
        theta > startAngle;
        theta -= step) {
      final double x = centerX + radius * cos(theta);
      final double y = centerY + radius * sin(theta);
      points.add(Offset(x, y));
    }

    return points;
  }

  List<Offset> createHalfCircleStroke(
      Offset center, double radius, double angle) {
    final double startAngle = -angle / 2;
    final double endAngle = angle / 2;

    final List<Offset> points = [];
    const double step = 0.1; // Adjust this value for the desired granularity.

    for (double theta = startAngle; theta < endAngle; theta += step) {
      final double x = center.dx + radius * cos(theta);
      final double y = center.dy + radius * sin(theta);
      // if (endAngle / 2 <= theta) {
      points.add(Offset(x, y));
      // }
    }

    return points;
  }
}
