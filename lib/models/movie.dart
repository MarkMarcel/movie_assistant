import 'package:movie_assistant/models/cast.crew.dart';
import 'package:movie_assistant/models/genre.dart';

class Movie {
  final int id;
  final String backdropPath;
  final List<CastCrew> castAndCrew;
  final List<Genre> genres;
  final String name;
  final String pgRating;
  final String plot;
  final String posterPath;
  final num rating;
  final String releaseDate;
  final num runtime;

  Movie(
    this.id,
    this.backdropPath,
    this.castAndCrew,
    this.genres,
    this.name,
    this.pgRating,
    this.posterPath,
    this.plot,
    this.rating,
    this.releaseDate,
    this.runtime,
  );

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => id;

  @override
  String toString() => '$id $name';
}
