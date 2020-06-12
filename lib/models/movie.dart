import 'package:movie_assistant/models/genre.dart';
import 'package:movie_assistant/ui/screens/list_notifier.dart';

const jsonKeys = <String, String>{
  'id': 'id',
  'backdropPath': 'backdrop_path',
  'genres': 'genre_ids',
  'name': 'title',
  'posterPath': 'poster_path',
  'rating':'vote_average'
};

class Movie {
  int _id;
  int get id => this._id;
  String _backdropPath;
  String get backdropPath => this._backdropPath;
  List<Genre> _genres;
  List<Genre> get genres => this._genres;
  String _name;
  String get name => this._name;
  String _posterPath;
  String get posterPath => this._posterPath;
  num _rating;
  num get rating => _rating;

  Movie(
      this._id, this._backdropPath, this._genres, this._name, this._posterPath,this._rating);

  factory Movie.fromJson(Map<dynamic, dynamic> json) {
    return Movie(
        json[jsonKeys['id']],
        json[jsonKeys['backdropPath']],
        getMovieGenres(json[jsonKeys['genres']]),
        json[jsonKeys['name']],
        json[jsonKeys['posterPath']],
        json[jsonKeys['rating']],);
  }

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => _id;

  @override
  String toString() => '$id $name $posterPath';
}
