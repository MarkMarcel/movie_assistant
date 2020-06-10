import 'package:movie_assistant/models/genre.dart';

class Movie{
  int _id;
  int get id => this._id;
  List<Genre> _genres;
  List<Genre> get genres => this._genres;
  String _name;
  String get name => this._name;
  String _poster;
  String get poster => this._poster;

}