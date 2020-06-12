import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_assistant/models/genre.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/network/tmdb_api.dart';

final Stream<bool> isLoadingPopularMovies =
    _getPopularMovies().asBroadcastStream();
final Set<Genre> _mainGenresList = Set();
final Set<Movie> _movies = Set();

addMovies(List<Movie> movies) => _movies.addAll(movies);

clearGenres() => _mainGenresList.clear();

clearMovies() => _movies.clear();

List<Genre> getMovieGenres (jsonArray){
      final movieGenres = jsonArray.map<Genre>((id) => _mainGenresList.firstWhere((genre) => genre.id == id));
      return movieGenres.toList();
  }
Stream<bool> _getPopularMovies() async* {
  yield true;
    final genresResponse = await getGenres();
    final parsedGenres = jsonDecode(genresResponse.body)['genres'];
    _setGenres(parsedGenres);
    //await compute(_setGenres,parsedGenres);
    final response = await getPopularMoviesFromServer();
    final parsed = jsonDecode(response.body)['results'];
    _setMovies(parsed);
    //await compute(_setMovies, parsed);
   yield false;
}

_setGenres(jsonArray){
  final genres = jsonArray.map<Genre>((json) => Genre.fromJson(json)).toList();
  _mainGenresList.addAll(genres);
}

_setMovies(dynamic jsonArray) {
  final movies = jsonArray.map<Movie>((json) => Movie.fromJson(json)).toList();
  clearMovies();
  _movies.addAll(movies);
}


class MovieListModel extends ChangeNotifier {
  var _isLoading = true;
  bool get isLoading => _isLoading;
  final Set<Genre> _genres = Set();
  Set<Genre> get genres => _genres;
  Set<Movie> get movies => _movies;

  _setGenres(){
    this._genres.clear();
    _movies.forEach((movie) => movie.genres.forEach((genre) => this._genres.add(genre)));
  }

//handle errors
  getMovies() => isLoadingPopularMovies.listen((isLoading) { 
    if(!isLoading){
      _setGenres();
      _isLoading = false;
        notifyListeners();
        print('called');
    }
  });
}
