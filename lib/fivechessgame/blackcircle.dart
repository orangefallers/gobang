import 'package:flutter/material.dart';

class BlackCircle extends CustomPainter {
  Paint cusPaint;

  double px, py;

  BlackCircle(double px, double py) {
    this.px = px;
    this.py = py;

    cusPaint = new Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    canvas.drawCircle(Offset(px, py), 6.0, cusPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
