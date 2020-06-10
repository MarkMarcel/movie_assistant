import 'package:flutter/material.dart';
import 'package:movie_assistant/ui/custom_painters/home_movie_right.dart';
import 'dart:math';

class Home extends StatelessWidget {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Popular Movies'),
    Tab(
      text: 'Top Rated Movies',
    ),
    Tab(
      text: 'Upcoming Movies',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: 16),
          child: Column(children: <Widget>[
            DefaultTabController(
                length: myTabs.length,
                child: TabBar(
                  isScrollable: true,
                  tabs: myTabs,
                )),
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(maxHeight: 60),
              margin: EdgeInsets.only(top: 24),
              child:
                  ListView(scrollDirection: Axis.horizontal, children: <Widget>[
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: ActionChip(
                        label: Text('Action'),
                        backgroundColor: Colors.transparent,
                        shape:
                            StadiumBorder(side: BorderSide(color: Colors.grey)),
                        onPressed: () {
                          print(
                              "If you stand for nothing, Burr, what’ll you fall for?");
                        })),
                Container(
                    margin: EdgeInsets.only(right: 16),
                    child: ActionChip(
                        label: Text('Crime'),
                        backgroundColor: Colors.transparent,
                        shape:
                            StadiumBorder(side: BorderSide(color: Colors.grey)),
                        onPressed: () {
                          print(
                              "If you stand for nothing, Burr, what’ll you fall for?");
                        })),
                Container(
                    margin: EdgeInsets.only(right: 16),
                    child: ActionChip(
                        label: Text('Comedy'),
                        backgroundColor: Colors.transparent,
                        shape:
                            StadiumBorder(side: BorderSide(color: Colors.grey)),
                        onPressed: () {
                          print(
                              "If you stand for nothing, Burr, what’ll you fall for?");
                        })),
                Container(
                    margin: EdgeInsets.only(right: 16),
                    child: ActionChip(
                        label: Text('Drama'),
                        backgroundColor: Colors.transparent,
                        shape:
                            StadiumBorder(side: BorderSide(color: Colors.grey)),
                        onPressed: () {
                          print(
                              "If you stand for nothing, Burr, what’ll you fall for?");
                        })),
                Container(
                    margin: EdgeInsets.only(right: 16),
                    child: ActionChip(
                        label: Text('Romance'),
                        backgroundColor: Colors.transparent,
                        shape:
                            StadiumBorder(side: BorderSide(color: Colors.grey)),
                        onPressed: () {
                          print(
                              "If you stand for nothing, Burr, what’ll you fall for?");
                        }))
              ]),
            ),
            Container(
                margin: EdgeInsets.only(top: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RotatedBox(quarterTurns: 2,
                    child:Container(
                    width: 30,
                    height: 294,
                    clipBehavior: Clip.antiAlias,
                    transform: Matrix4.tryInvert(Matrix4.rotationZ(-0.12)),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(32)),
                  ))
                  ,
                  SizedBox(width: 32),
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/movie'),
                        child:Container(
                        width: 196,
                        height: 294,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(32)),
                      )),
                      Container(
                        margin:EdgeInsets.only(top:16),
                        child:Text(
                        'Ford vs Ferrari',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                      ),
                      Container(
                        margin:EdgeInsets.only(top:8),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.star,color:Colors.yellow),
                            Text('8.2',style: TextStyle(
                            fontSize: 20, ),)
                          ],
                        )
                      )
                    ],
                  ),
                  SizedBox(width: 12),
                  Container(
                    child: CustomPaint(
                      painter:MovieRight(angle: pi/6,color: Theme.of(context).primaryColor)
                    ),
                    height: 294,
                    width: 50,
                  ),
                ]))
          ])),
    );
  }
}
