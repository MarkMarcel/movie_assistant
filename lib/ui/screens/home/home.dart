import 'package:flutter/material.dart';
import 'package:movie_assistant/models/genre.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/network/tmdb_api.dart';
import 'package:movie_assistant/ui/app_state.dart';
import 'package:movie_assistant/ui/custom_painters/home_movie_right.dart';
import 'package:movie_assistant/ui/screens/home/home_view_model.dart';
import 'dart:math';
import 'package:provider/provider.dart';

CurrentMovieIndex _currentMovieIndex;
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
    final _appState = Provider.of<AppState>(context,listen: false);
    _getMovies(int index) {
      switch (index) {
        case 0:
          _appState.getMovies(movieListType: MovieListType.popular);
          break;
        case 1:
          _appState.getMovies(movieListType: MovieListType.topRated);
          break;
        case 2:
          _appState.getMovies(movieListType: MovieListType.upcoming);
          break;
      }
    }

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
                  onTap: _getMovies,
                )),
                PageView(),
            Consumer<AppState>(
                builder: (context, appState, child) => ChangeNotifierProvider(
                    create: (context) => HomeViewModel(appState.movies),
                    builder: (context,_) => appState.movies.isEmpty
                        ? _getIndicator()
                        : _getMainContent(context)))
          ])),
    );
  }

  _getIndicator() => Expanded(child: Center(child: CircularProgressIndicator()));

  _getMainContent(BuildContext context) {
    final _homeViewModel = Provider.of<HomeViewModel>(context);
    _currentMovieIndex = CurrentMovieIndex(0, _homeViewModel.movies.length - 1);

    Widget _addGenreBuilder(Genre genre) => Container(
        margin: EdgeInsets.only(right: 16),
        child: ChoiceChip(
          label: Text(genre.name),
          backgroundColor: Colors.transparent,
          shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
          selected: (_homeViewModel.filterGenres.contains(genre.id)),
          onSelected: (selected) {
            if (selected)
              _homeViewModel.addFilterGenre(genre.id);
            else
              _homeViewModel.removeFilterGenre(genre.id);
          },
        ));

    return Column(children: <Widget>[
      Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(maxHeight: 60),
          margin: EdgeInsets.only(top: 24),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _homeViewModel.displayGenreList.length,
              itemBuilder: (BuildContext context, int index) =>
                  _addGenreBuilder(
                      _homeViewModel.displayGenreList.toList()[index]))),
      ValueListenableBuilder(
        valueListenable: _currentMovieIndex,
        builder: (context, value, child) => HomeMovie(_homeViewModel),
      ),
    ]);
  }
}

class HomeMovie extends StatelessWidget {
  final HomeViewModel _movieList;
  HomeMovie(this._movieList);

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _imageHeight = _getImageHeight(_screenWidth);
    final movie = _movieList.movies.toList()[_currentMovieIndex.value];

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
              Expanded(
                  flex: 7,
                  child: _addMovieBuilder(context, movie, _imageHeight)),
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

  Widget _addMovieBuilder(
      BuildContext context, Movie movie, double _imageHeight) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/movie'),
          child: Dismissible(
              key: Key('${movie.id}'),
              background: Text('Previous'),
              dismissThresholds: {
                DismissDirection.endToStart: 2,
                DismissDirection.startToEnd: 2
              },
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  _currentMovieIndex.previousMovie();
                }
                if (direction == DismissDirection.endToStart) {
                  _currentMovieIndex.nextMovie();
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
              )),
        ),
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
