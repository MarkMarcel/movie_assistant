import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class HomeMovieRightFlank extends CustomPainter {
  double _angle;
  Canvas _canvas;
  final ui.Image _image;
  Paint _paint;
  final double _radius;
  Size _size;

  HomeMovieRightFlank({@required double radius, @required image})
      : _paint = Paint()
          ..isAntiAlias = true
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
          _image = image,
          _radius = radius;

  @override
  void paint(Canvas canvas, Size size) {
    _angle = atan(size.width/(size.height - _radius));
    _canvas = canvas;
    _size = size;
    final path = _getClipPath();
    canvas.clipPath(path);
    _resetCanvas();
    canvas.drawImage(_image, Offset(0, 0), this._paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  Map<String, Offset> _getAngledPoints(double angleTan) {
    final first = _getFirstPointInTranslatedAndRotatedPlane();
    final second = Offset(0, 0);
    return {
      'first': first,
      'second': second 
    };
  }

  Path _getClipPath() {
    final angleTan = _getTan(_angle);
    final anglePoints = _getAngledPoints(angleTan);
    final path = Path();
    _transformCanvas();
    path.moveTo(anglePoints['first'].dx, anglePoints['first'].dy);
    path.lineTo(anglePoints['second'].dx, anglePoints['second'].dy);
    path.arcTo(Rect.fromLTRB(0, -_radius, _size.width+_radius, _radius), -pi, -pi, false);
    path.lineTo(anglePoints['first'].dx, anglePoints['first'].dy);

    return path;
  }

  double _getTan(num radians) {
    return tan(radians).abs();
  }

  _transformCanvas(){
    final yTranslation = _size.height - _radius;
    _canvas.translate(0, yTranslation);
    _canvas.rotate(_angle);
  }

  _resetCanvas(){
    _canvas.rotate(-_angle);
    _canvas.translate(0, (
    -(_size.height - _radius)));
  }

  Offset _getFirstPointInTranslatedAndRotatedPlane() {
    final y2 = _size.height / cos((_angle));//correct
    return Offset(0, -y2);
  }
}
