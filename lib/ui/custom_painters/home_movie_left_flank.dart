import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class HomeMovieLeftFlank extends CustomPainter{
   final num _angle;
  Canvas _canvas;
  final ui.Image image;
  Paint _paint;
  Size _size;

  HomeMovieLeftFlank({@required angle, @required this.image})
  :_paint = Paint()
  ..isAntiAlias = true
  ..imageFilter = ui.ImageFilter.blur(sigmaX:3.0,sigmaY:3.0),
  _angle = -angle;

  @override
  void paint(Canvas canvas, Size size) {
       _canvas = canvas;
    _size = size;
    final path = _getClipPath();
    canvas.clipPath(path);
    canvas.drawImage(this.image, Offset(0, 0), this._paint);
    }
  
    @override
    bool shouldRepaint(CustomPainter oldDelegate) {
      return false;
  }

   Map<String,Offset> _getAngledPoints(Size size, num angleTan) => {
    'first':Offset(0, angleTan*size.width),
    'second':Offset(size.width, size.height-angleTan*size.width)
  };

  Path _getClipPath(){
    final angleTan = _getTan(_angle);
    final anglePoints = _getAngledPoints(_size, angleTan);
    final path = Path();
    path.moveTo(anglePoints['first'].dx, anglePoints['first'].dy);
    path.lineTo(anglePoints['second'].dx, anglePoints['second'].dy);
    _canvas.rotate(_angle);
    final x2 = (_size.width/cos((pi/2)-_angle)).abs();
    final y2 = ((_size.height - anglePoints['second'].dy)/cos(_angle)).abs();
    path.arcTo(Rect.fromLTRB(0-x2,anglePoints['second'].dy-64,anglePoints['second'].dx,anglePoints['second'].dy+y2), 0, pi, false);
    _canvas.rotate(-_angle);
    path.lineTo(anglePoints['first'].dx, anglePoints['first'].dy);
    return path;
  }

  double _getTan(num radians){
    return tan(radians).abs();
  }
  
}