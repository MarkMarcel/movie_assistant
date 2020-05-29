import 'package:flutter/material.dart';

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
          padding: EdgeInsets.only( top: 16),
          child: Column(children: <Widget>[
            DefaultTabController(
                length: myTabs.length,
                child: TabBar(
                  isScrollable: true,
                  tabs: myTabs,
                )),
            SizedBox(height: 16),
            Container(
              constraints: BoxConstraints(maxHeight: 60),
              child:
                  ListView(scrollDirection: Axis.horizontal, children: <Widget>[
                Container(
                    margin: EdgeInsets.symmetric(horizontal:16),
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
            )
          ])),
    );
  }
}
