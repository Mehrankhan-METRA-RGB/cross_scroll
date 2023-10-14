import 'package:flutter/material.dart';

class MovableContainer extends StatefulWidget {
  final double height;
  final double width;
  final Axis axis;
  MovableContainer(
      {required this.height, required this.width, this.axis = Axis.horizontal});
  @override
  _MovableContainerState createState() => _MovableContainerState();
}

class _MovableContainerState extends State<MovableContainer> {
  double x = 0.0;
  double y = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          if (widget.axis == Axis.horizontal)
            x += details.delta.dx;
          else
            y += details.delta.dy;
        });
      },
      child: Transform.translate(
          offset: Offset(x, y),
          child: CustomPaint(
            painter: Thumb(
                radius: 12,
                width: widget.width,
                height: widget.height,
                backgroundColor: Colors.lightBlue),
          )),
    );
  }
}

class Thumb extends CustomPainter {
  final double radius;
  final double width;
  final double height;
  final Color backgroundColor;

  Thumb({
    required this.radius,
    required this.width,
    required this.height,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final rect = Rect.fromPoints(
      Offset(0, 0),
      Offset(width, height),
    );

    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
