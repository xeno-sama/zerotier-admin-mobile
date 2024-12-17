import 'package:flutter/material.dart';

class LogoPainter extends CustomPainter {
  final Paint _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.square;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Calculate dimensions based on available space
    // final totalHeight = size.height * 0.8; // 80% of height for T
    final horizontalWidth = size.width * 0.6; // 60% of width for T top
    final circleRadius = size.width * 0.22; // 30% of width for circle diameter

    // Draw T vertical line
    canvas
      ..drawLine(
        Offset(centerX, size.height * 0.2), // Start from top with small margin
        Offset(centerX, size.height * 0.85), // End at bottom with small margin
        _paint,
      )

      // Draw T horizontal line
      ..drawLine(
        Offset(centerX - horizontalWidth / 2, size.height * 0.18),
        Offset(centerX + horizontalWidth / 2, size.height * 0.15),
        _paint,
      )

      // Draw circle in the center of T
      ..drawCircle(
        Offset(centerX, centerY),
        circleRadius,
        _paint,
      );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
