import 'package:flutter/material.dart';
import 'package:movie_assistant/models/genre.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/network/tmdb_api.dart';
import 'package:movie_assistant/ui/app_state.dart';
import 'package:movie_assistant/ui/custom_painters/home_movie_left_flank.dart';
import 'package:movie_assistant/ui/custom_painters/home_movie_right_flank.dart';
import 'package:movie_assistant/ui/screens/home/home_view_model.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

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

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget{
  
  HomeAppBar()
  :preferredSize = Size.fromHeight(kToolbarHeight); //whenever needed  + (bottom?.preferredSize?.height ?? 0.0)
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<AppState,HomeAppBarViewModel>(
      create: (_) => HomeAppBarViewModel(),
      update: (_,__,_homeAppBarViewModel) => _homeAppBarViewModel,
      child: Consumer<HomeAppBarViewModel>(
        builder: (_,_homeAppBarViewModel,__) => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _homeAppBarViewModel.isSearchMode? TextField(
          decoration:InputDecoration(
            hintText:'Search movies'
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (text){
            final _appState = Provider.of<AppState>(context,listen: false);
            _appState.getMovies(movieListType: MovieListType.search,search: text);
            _homeAppBarViewModel.leaveSearchMode();
          },
        ) : Text('Vietant',style: TextStyle(color:Theme.of(context).primaryColor),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search,color: Colors.grey,),
             onPressed: (){_homeAppBarViewModel.enterSearchMode();})
        ],
      )),);
  }

  @override
  final Size preferredSize;
   
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appState = Provider.of<AppState>(context, listen: false);
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
      backgroundColor: Colors.white,
      appBar: HomeAppBar(),
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
            ChangeNotifierProxyProvider<AppState, HomeViewModel>(
              create: (_) => HomeViewModel(),
              update: (_, _appState, _homeViewModel) =>
                  _homeViewModel..update(_appState.movies),
              child: Consumer<HomeViewModel>(
                  builder: (context, homeViewModel, child) =>
                      homeViewModel.movies.isEmpty
                          ? _getIndicator()
                          : _getMainContent(context)),
            )
          ])),
    );
  }

  Widget _getIndicator() =>
      Expanded(child: Center(child: CircularProgressIndicator()));

  Widget _getMainContent(BuildContext context) {
    // if builder gets called why doesn't this change
    final _homeViewModel = Provider.of<HomeViewModel>(context);
    final _pageController = PageController();

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

    return Expanded(
      child: Column(children: <Widget>[
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
        Expanded(
          child: PageView.builder(
              controller: _pageController,
              itemCount: _homeViewModel.movies.length,
              itemBuilder: (context, index) =>
                  HomeMovie(_homeViewModel.movies[index])),
        )
      ]),
    );
  }
}

class HomeMovie extends StatelessWidget {
  final Movie _movie;
  HomeMovie(this._movie);

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _imageHeight = _getImageHeight(_screenWidth);

    return Container(
        margin: EdgeInsets.only(top: 32),
        child: FutureBuilder<ui.Image>(
            future: getMovieBackdrop(_movie.backdropPath),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Container(
                                    child: CustomPaint(
                                        painter: HomeMovieLeftFlank(
                                            radius: 16,
                                            image: snapshot.data)),
                                    height: _imageHeight,
                                    width: 50,
                                  )),
                      SizedBox(width: imageAndFlanksGutter),
                      Expanded(
                          flex: 5,
                          child:
                              _addMovieBuilder(context, _movie, _imageHeight)),
                      SizedBox(width: imageAndFlanksGutter),
                      Expanded(
                          flex: 1,
                          child: Container(
                                    child: CustomPaint(
                                        painter: HomeMovieRightFlank(
                                            radius: 16,
                                            image: snapshot.data)),
                                    height: _imageHeight,
                                    width: 50,
                                  ))
                    ]);
              else
                return Center(child: Text('loading'));
            }));
  }

  Widget _addMovieBuilder(
      BuildContext context, Movie movie, double _imageHeight) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/movie'),
          child: Container(
            height: _imageHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 4),
                    blurRadius: 3 * pi,
                    spreadRadius: pi / 24)
              ],
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage('$posterPath${movie.posterPath}')),
            ),
          ),
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
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 18,
                ),
                Text(
                  '${movie.rating}',
                  style: TextStyle(
                    fontSize: 15,
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
