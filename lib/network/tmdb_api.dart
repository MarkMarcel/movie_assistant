import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:movie_assistant/models/genre.dart';
import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/network/json_conversions/genre_json_conversions.dart';
import 'package:movie_assistant/network/json_conversions/movie_json_conversions.dart';
import 'package:movie_assistant/ui/app_state.dart';

typedef GetMovieGenres = List<Genre> Function(dynamic);

const backdropPath = 'http://image.tmdb.org/t/p/original/';
const posterPath = 'http://image.tmdb.org/t/p/original/';
const _token =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzOGZmNTI5YjFkNjVhNWMxMDQzZjg2MmJmNzk0YTIxNCIsInN1YiI6IjVlZTE1ZmVhNGMxYmIwMDAxZWEzNjRhMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.MRseAgIWSaHOOEu7ObcJ64URJH4cwjg6wrAeZBoVdx4';
const _authString = 'Bearer $_token';
const _v3BaseUrl = 'https://api.themoviedb.org/3/';
//const _v4BaseUrl = 'https://api.themoviedb.org/4/';

final Set<Genre> _mainTmDbMovieGenreList = Set();

Future<void> _getGenres() async {
  const url = '${_v3BaseUrl}genre/movie/list';
  final response = await http
      .get(url, headers: {HttpHeaders.authorizationHeader: _authString});
  final parsed = jsonDecode(response.body)['genres'];
  final genres =
        parsed.map<Genre>((json) => genreFromJson(json)).toList();
    _mainTmDbMovieGenreList.addAll(genres);
}

Future<Image> getMovieBackdrop(String path) async{
    final url = '$backdropPath$path';
    final response = await http.get(url);
    final bytes = response.bodyBytes;
    final codec = await instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;

}

Future<List<Movie>> getMoviesFromServer({MovieListType movieListType}) async{
    if(_mainTmDbMovieGenreList.isEmpty) await _getGenres();
    switch(movieListType){
      case MovieListType.popular:return _getPopularMoviesFromServer();
      break;
      case MovieListType.topRated:return _getTopRatedMoviesFromServer();
      break;
      case MovieListType.upcoming:return _getUpcomingMoviesFromServer();
      break;
      default: return _getPopularMoviesFromServer();
    }
}

Future<List<Movie>> _getPopularMoviesFromServer() async {
  const url = '${_v3BaseUrl}movie/popular';
  final response = await http
      .get(url, headers: {HttpHeaders.authorizationHeader: _authString});
  return _processMovieResponse(response);
}

Future<List<Movie>> _getTopRatedMoviesFromServer() async {
  const url = '${_v3BaseUrl}movie/top_rated';
  final response = await http
      .get(url, headers: {HttpHeaders.authorizationHeader: _authString});
  return _processMovieResponse(response);
}

Future<List<Movie>> _getUpcomingMoviesFromServer() async {
  const url = '${_v3BaseUrl}movie/upcoming';
  final response = await http
      .get(url, headers: {HttpHeaders.authorizationHeader: _authString});
  return _processMovieResponse(response);
}

List<Movie> _processMovieResponse(dynamic response){
  final parsed = jsonDecode(response.body)['results'];
  final movies =
        parsed.map<Movie>((json) => movieFromJson(json,_getMovieGenres)).toList();
  return movies;  
}

List<Genre> _getMovieGenres(jsonArray) {
  final movieGenres = jsonArray.map<Genre>(
      (id) => _mainTmDbMovieGenreList.firstWhere((genre) => genre.id == id));
  return movieGenres.toList();
}
