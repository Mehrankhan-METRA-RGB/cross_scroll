// import 'dart:math';
//
// import 'package:flutter/material.dart';
//
// class CustomWidget extends StatelessWidget {
//   const CustomWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     print("WIDTH:${MediaQuery.sizeOf(context).width}");
//     return MaterialApp(
//         color: Colors.grey,
//         home: CustomPaint(
//           size: const Size(550, 550),
//           foregroundPainter: RPSCustomPainter(),
//         ));
//   }
// }
//
// class RPSCustomPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     print("CUSTOM PAINTER: $size");
//     Paint paintFill0 = Paint()
//       ..color = const Color.fromARGB(255, 255, 255, 255)
//       ..style = PaintingStyle.fill
//       ..strokeWidth = 0;
//
//     Paint paintStroke0 = Paint()
//       ..color = const Color.fromARGB(255, 126, 177, 219)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;
//
//     Path path_0 = Path();
//
//     // path_0.moveTo(size.width, size.height);
//
//     ///TOP Left corner
//     path_0.lineTo(0, 0);
//
//     ///TOP Right corner
//     path_0.lineTo(size.width, 0);
//
//     path_0.lineTo(size.width, size.height * 0.2);
//     for (Offset offset in createHalfCircleAntiClockwise(
//         Offset(size.width + 2, size.height * 0.6),
//         Offset(size.width + 2, size.height * 0.5),
//         4)) {
//       // if (i > 2 && i < 700) {
//       path_0.lineTo(offset.dx, offset.dy);
//       print(offset);
//       // }
//       // if (i > 700) {
//       //   break;
//       // }
//       // print(i);
//     }
//
//     path_0.lineTo(size.width, size.height * 0.5);
//
//     ///BOTTOM RIGHT CORNER
//     path_0.lineTo(size.width, size.height);
//
//     ///BOTTOM LEFT CORNER
//     path_0.lineTo(0, size.height);
//
//     for (Offset offset in fullCircle(
//             Offset(0, size.height * 0.5), Offset(0, size.height * 0.6), 4)
//         .reversed) {
//       // if (i > 2 && i < 700) {
//       path_0.lineTo(offset.dx, offset.dy);
//       print(offset);
//       // }
//       // if (i > 700) {
//       //   break;
//       // }
//       // print(i);
//     }
//
//     ///JOIN TOP LEFT AGAIN
//     path_0.lineTo(0, 0);
//
//     path_0.close();
//
//     canvas.drawPath(path_0, paintFill0);
//     canvas.drawPath(path_0, paintStroke0);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     // print("CUSTOM PAINTER: ${oldDelegate.paint(canvas, size)}");
//     return true;
//   }
//
//   List<Offset> fullCircle(Offset start, Offset end, double angle) {
//     final double centerX = (start.dx + end.dx) / 2;
//     final double centerY = (start.dy + end.dy) / 2;
//     final double radius = centerY / 2;
//
//     final double startAngle = atan2(start.dy - centerY, start.dx - centerX);
//     final double sweepAngle = angle;
//
//     final List<Offset> points = [];
//     const double step = 0.1; // Adjust this value for the desired granularity.
//
//     for (double theta = startAngle;
//         theta < startAngle + sweepAngle;
//         theta += step) {
//       final double x = centerX + radius * cos(theta);
//       final double y = centerY + radius * sin(theta);
//       points.add(Offset(x, y));
//     }
//     points.removeAt(points.length - 1);
//
//     return points;
//   }
//
//   List<Offset> createHalfCircleAntiClockwise(
//       Offset start, Offset end, double angle) {
//     final double centerX = (start.dx + end.dx) / 2;
//     final double centerY = (start.dy + end.dy) / 2;
//     final double radius = centerY / 2;
//
//     final double startAngle = atan2(start.dy - centerY, start.dx - centerX);
//     final double sweepAngle = angle;
//
//     final List<Offset> points = [];
//     const double step = 0.01; // Adjust this value for the desired granularity.
//
//     for (double theta = startAngle + sweepAngle;
//         theta > startAngle;
//         theta -= step) {
//       final double x = centerX + radius * cos(theta);
//       final double y = centerY + radius * sin(theta);
//       points.add(Offset(x, y));
//     }
//
//     return points;
//   }
//
//   List<Offset> createHalfCircleStroke(
//       Offset center, double radius, double angle) {
//     final double startAngle = -angle / 2;
//     final double endAngle = angle / 2;
//
//     final List<Offset> points = [];
//     const double step = 0.1; // Adjust this value for the desired granularity.
//
//     for (double theta = startAngle; theta < endAngle; theta += step) {
//       final double x = center.dx + radius * cos(theta);
//       final double y = center.dy + radius * sin(theta);
//       // if (endAngle / 2 <= theta) {
//       points.add(Offset(x, y));
//       // }
//     }
//
//     return points;
//   }
// }
