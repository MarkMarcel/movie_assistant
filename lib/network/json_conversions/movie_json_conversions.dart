import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/network/tmdb_api.dart';

const jsonKeys = <String, String>{
  'id': 'id',
  'backdropPath': 'backdrop_path',
  'genres': 'genre_ids',
  'name': 'title',
  'posterPath': 'poster_path',
  'rating':'vote_average'
};

Movie movieFromJson(Map<dynamic, dynamic> json,GetMovieGenres getMovieGenres) {
    return Movie(
        json[jsonKeys['id']],
        json[jsonKeys['backdropPath']],
        getMovieGenres(json[jsonKeys['genres']]),
        json[jsonKeys['name']],
        json[jsonKeys['posterPath']],
        json[jsonKeys['rating']],);
  }


