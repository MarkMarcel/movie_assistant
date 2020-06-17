import 'package:flutter/cupertino.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/network/tmdb_api.dart';

enum MovieListType{
  popular,
  topRated,
  upcoming
}

class AppState with ChangeNotifier{
  Set<Movie> _movies = Set();
  Set<Movie> get movies => this._movies;

  AppState(){
    this.getMovies();
  }

  getMovies({MovieListType movieListType}) async{
    _movies.clear();
    notifyListeners();
    final movies = await getMoviesFromServer(movieListType:movieListType);
    _setMovies(movies);
  }

  _setMovies(List<Movie> movies){
    _movies.addAll(movies);
    notifyListeners();
  }
}