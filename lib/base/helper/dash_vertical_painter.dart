import 'package:flutter/material.dart';

class DashVerticalPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashHeight;
  final double dashSpace;

  DashVerticalPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashHeight = 5.0,
    this.dashSpace = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startY = 0;

    final paint = Paint()
      ..color = this.color
      ..strokeWidth = this.strokeWidth;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
