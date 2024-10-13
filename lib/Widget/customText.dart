import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class TextWithBorderPainter extends CustomPainter {
  final String text;
  final TextStyle style;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final TextAlign textAlign;

  TextWithBorderPainter({
    required this.text,
    required this.style,
    this.borderWidth = 2.0,
    this.borderColor = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.textAlign = TextAlign.left,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create a text painter for the text
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
    )..layout(maxWidth: size.width);

    // Calculate the offset for centering the text
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Draw the background rectangle with rounded corners
    final paintBackground = Paint()..color = backgroundColor;
    final backgroundRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(backgroundRect, Radius.circular(8.0)),
      paintBackground,
    );

    // Paint the text
    textPainter.paint(canvas, offset);

    // Prepare the paint for the border
    final paintBorder = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Draw the border with rounded corners
    final borderRect = Rect.fromLTWH(
      offset.dx - borderWidth / 2,
      offset.dy - borderWidth / 2,
      textPainter.width + borderWidth,
      textPainter.height + borderWidth,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(borderRect, Radius.circular(8.0)),
      paintBorder,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
