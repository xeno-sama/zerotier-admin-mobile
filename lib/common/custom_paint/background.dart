import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  final ThemeMode themeMode;
  BackgroundPainter({required this.themeMode, super.repaint});

  @override
  void paint(Canvas canvas, Size size) {
    const cellSize = 30;
    const cellSpacing = 1;

    final blackPaint = Paint()
      ..color = themeMode == ThemeMode.dark ? Colors.black : Colors.white
      ..style = PaintingStyle.fill;

    final orangePaint = Paint()
      ..color = themeMode == ThemeMode.dark
          ? const Color.fromARGB(255, 239, 185, 78).withOpacity(.1)
          : const Color.fromARGB(255, 0, 0, 0).withOpacity(.1)
      ..style = PaintingStyle.fill;

    for (var x = 0; x < size.width; x += cellSize + cellSpacing) {
      for (var y = 0; y < size.height; y += cellSize + cellSpacing) {
        canvas
          ..drawRect(
            Rect.fromLTWH(
              x.toDouble() * .10,
              y.toDouble() * .10,
              cellSize.toDouble() * .10,
              cellSize.toDouble() * .10,
            ),
            blackPaint,
          )
          ..drawCircle(
            Offset(x + cellSize * .10, y + cellSize * .10),
            cellSize * .05,
            orangePaint,
          );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
