import 'package:flutter/material.dart';
import 'package:movie_assistant/models/genre.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/network/tmdb_api.dart';
import 'package:movie_assistant/ui/custom_painters/home_movie_right.dart';
import 'package:movie_assistant/ui/screens/list_notifier.dart';
import 'dart:math';
import 'package:provider/provider.dart';

const imageAndFlanksGutter = 16.0;
const imageReversedAspectRatio = 4.0 / 3.0;
final List<Tab> myTabs = <Tab>[
  Tab(text: 'Popular'),
  Tab(
    text: 'Top Rated',
  ),
  Tab(
    text: 'Upcoming',
  ),
];

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    isLoadingPopularMovies.listen((event) {});

    return Consumer<MovieListModel>(builder: (context, movieList, child) {
      movieList.getMovies();
      return (movieList.isLoading)
          ? _getIndicator()
          : _getMainContent(context, movieList);
    });
  }

  Widget _addGenreBuilder(Genre genre) => Container(
      margin: EdgeInsets.only(right: 16),
      child: ActionChip(
          label: Text(genre.name),
          backgroundColor: Colors.transparent,
          shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
          onPressed: () {
            print(genre.name);
          }));

  _getIndicator() => Center(child: CircularProgressIndicator(backgroundColor: Colors.white,));

  _getMainContent(BuildContext context, MovieListModel movieList) {
    final genres = movieList.genres;
    print(genres);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Vietant'),
      ),
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
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movieList.genres.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _addGenreBuilder(movieList.genres.toList()[index]))),
            HomeMovie(movieList),
          ])),
    );
  }
}

class HomeMovie extends StatefulWidget {
  final MovieListModel _movieList;

  HomeMovie(this._movieList);

  @override
  _HomeMovieState createState() => _HomeMovieState(this._movieList);
}

class _HomeMovieState extends State<HomeMovie> {
  int _currentIndex = 0;
  final MovieListModel _movieList;
  double _imageHeight;

  _HomeMovieState(this._movieList);

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    _imageHeight = _getImageHeight(_screenWidth);
    final movie = _movieList.movies.toList()[_currentIndex];

    return Container(
        margin: EdgeInsets.only(top: 32),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    height: _imageHeight,
                    clipBehavior: Clip.antiAlias,
                    transform: Matrix4.tryInvert(Matrix4.rotationZ(-0.12)),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(32),
                        image: DecorationImage(
                    fit: BoxFit.fitHeight,
                            image: NetworkImage(
                                '$posterPath${movie.backdropPath}'))),
                  )),
              SizedBox(width: imageAndFlanksGutter),
              Expanded(flex: 7, child: _addMovieBuilder(context, movie)),
              SizedBox(width: imageAndFlanksGutter),
              Expanded(
                flex: 1,
                child: Container(
                  child: CustomPaint(
                      painter: MovieRight(
                          angle: pi / 6,
                          color: Theme.of(context).primaryColor)),
                  height: _imageHeight,
                  width: 50,
                ),
              )
            ]));
  }

  Widget _addMovieBuilder(BuildContext context, Movie movie) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/movie'),
            child: Dismissible(
            key: Key('${movie.id}'),
            background: Text('Previous'),
            dismissThresholds: {
              DismissDirection.endToStart: 20,
              DismissDirection.startToEnd: 20
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                 setState(() {
                  if((_currentIndex - 1) < 0)
                    _currentIndex = _movieList.movies.length - 1;
                  else _currentIndex--;  
                });
              }
              if (direction == DismissDirection.endToStart) {
                setState(() {
                  if((_currentIndex + 1) > (_movieList.movies.length - 1))
                    _currentIndex = 0;
                  else _currentIndex++;  
                });
              }
            },
            secondaryBackground: Text('Next'),
            child: Container(
              height: _imageHeight,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage('$posterPath${movie.posterPath}')),
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(32)),
            )),),
        Container(
            margin: EdgeInsets.only(top: 16),
            child: Text(
              movie.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
        Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.star, color: Colors.yellow),
                Text(
                  '${movie.rating}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )
              ],
            ))
      ],
    );
  }

  double _getImageHeight(double screenWidth) {
    final effectiveWidth = screenWidth - 32;
    final imageWidth = (effectiveWidth / 9.0) * 7;
    return imageReversedAspectRatio * imageWidth;
  }
}
