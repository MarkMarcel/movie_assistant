const _jsonKeys = <String, String>{
  'id': 'id',
  'name':'name'
  };

final Set<Genre> _genres = Set();
Set<Genre> get genres => _genres;

List<Genre> findGenres(List<int> ids) {
  final genres = _genres.where((genre) => ids.contains(genre.id));
  return genres;
}


class Genre {
  int _id;
  int get id => this._id;
  String _name;
  String get name => this._name;

  Genre(this._id, this._name);

  Genre.fromJson(Map<String, dynamic> json)
  :_id = json[_jsonKeys['id']],
  _name = json[_jsonKeys['name']];

  @override
  bool operator ==(Object other) => identical(this, other);

  @override 
  int get hashCode => _id;

@override 
String toString() => '$id $name';
}
