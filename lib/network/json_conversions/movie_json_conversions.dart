import 'package:movie_assistant/models/movie.dart';
import 'package:movie_assistant/network/json_conversions/cast.crew.json.conversions.dart';
import 'package:movie_assistant/network/tmdb_api.dart';

const jsonKeys = <String, String>{
  'id': 'id',
  'backdropPath': 'backdrop_path',
  'castAndCrew':'credits',
  'genres': 'genres',
  'genreIds':'genre_ids',
  'name': 'title',
  'pgRating':'certification',
  'plot':'overview',
  'posterPath': 'poster_path',
  'rating':'vote_average',
  'releaseDate':'release_date',
  'runtime':'runtime',
};

Movie movieFromJson(Map<String, dynamic> json,GetMovieGenresFromIdsArray getMovieGenres) {
    return Movie(
        json[jsonKeys['id']],
        json[jsonKeys['backdropPath']],
        null,
        getMovieGenres(json[jsonKeys['genreIds']]),
        json[jsonKeys['name']],
        null,
        json[jsonKeys['posterPath']],
        null,
        json[jsonKeys['rating']],
        null,
        null,);
  }

Movie movieFromDetailsJson(Map<String,dynamic> json, GetMovieGenresFromObjectArray getMovieGenres,GetMoviePGRating getMoviePGRating){
 return Movie(
        json[jsonKeys['id']],
        json[jsonKeys['backdropPath']],
        castAndCrewFromJson(json[jsonKeys['castAndCrew']]),
        getMovieGenres(json[jsonKeys['genres']]),
        json[jsonKeys['name']],
        getMoviePGRating(json['release_dates'],jsonKeys['pgRating']),
        json[jsonKeys['posterPath']],
        json[jsonKeys['plot']],
        json[jsonKeys['rating']],
        json[jsonKeys['releaseDate']],
        json[jsonKeys['runtime']],);
}



