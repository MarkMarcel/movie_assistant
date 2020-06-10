import 'dart:math';

import 'package:flutter/material.dart';

class MovieRight extends CustomPainter{
  num angle;
  Paint _paint;
  MovieRight({@required this.angle, @required color})
  :_paint = Paint()
  ..color = color
  ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    final angleTan = _getTan(this.angle);
    final points = _getPoints(size, angleTan);
    final path = Path();
    path.moveTo(points['first'].dx, points['first'].dy);
    path.lineTo(points['second'].dx, points['second'].dy);
    path.arcTo(Rect.fromLTRB(points['second'].dx,points['second'].dy-32,size.width,size.height), -pi, -3*pi/5, false);
    path.lineTo(points['first'].dx, points['first'].dy);
    canvas.drawPath(path, _paint);
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  double _getTan(num radians){
    return tan(radians).abs();
  }

  Map<String,Offset> _getPoints(Size size, num angleTan) => {
    'first':Offset(size.width, angleTan*size.width),
    'second':Offset(0, size.height-angleTan*size.width)
  };
  
}