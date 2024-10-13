import 'package:flutter/material.dart';

class ClipPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Starting point at the bottom left
    path.lineTo(0, size.height);

    // Bottom right corner
    path.lineTo(size.width, size.height);

    // Right edge to the top right corner
    path.lineTo(size.width, 0);

    // Top left corner curve
    var firstControlPoint = Offset(0, 0);
    var firstEndPoint = Offset(size.width * 0.2, size.height * 0.3);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Left middle curve
    var secondControlPoint = Offset(size.width * 0.25, size.height * 0.5);
    var secondEndPoint = Offset(size.width * 0.1, size.height * 0.7);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // Bottom left corner curve
    var thirdControlPoint = Offset(0, size.height);
    var thirdEndPoint = Offset(size.width * 0.5, size.height);
    path.quadraticBezierTo(
      thirdControlPoint.dx,
      thirdControlPoint.dy,
      thirdEndPoint.dx,
      thirdEndPoint.dy,
    );

    // Complete the path by returning to the bottom left
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; // Reclip on every rebuild
  }
}
