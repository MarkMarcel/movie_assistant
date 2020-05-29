import 'package:flutter/material.dart';

getAppTheme(BuildContext context) => ThemeData(
  tabBarTheme: TabBarTheme(
    labelColor: Colors.black,
    labelStyle: TextStyle(
      fontSize: 20,
      fontWeight:FontWeight.bold
    ),
    unselectedLabelColor: Colors.grey,
    unselectedLabelStyle: TextStyle(
      fontSize: 20,
      fontWeight:FontWeight.bold
    ),
    indicator: MyTabIndicator(color: Theme.of(context).primaryColor)
  )
);

class MyTabIndicator extends Decoration{
  final BoxPainter _painter;

  MyTabIndicator({@required Color color})
  : _painter = _TabIndicatorPainter(color);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;

}

 class _TabIndicatorPainter extends BoxPainter{
   final Paint _paint;

   _TabIndicatorPainter(Color color)
    : _paint = Paint()
      ..color = color
      ..isAntiAlias = true;

   @override  
   void paint(Canvas canvas, Offset offset, ImageConfiguration cfg){
     final double left = offset.dx + 16;  
     final double top = offset.dy + cfg.size.height - 3;
     final Rect rect = Rect.fromLTWH(left, top, 25, 3);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(15.0)), _paint);
   }
 }