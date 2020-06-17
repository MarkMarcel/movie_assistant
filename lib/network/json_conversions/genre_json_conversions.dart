import 'package:movie_assistant/models/genre.dart';

const _genreJsonKeys = <String, String>{
  'id': 'id',
  'name':'name'
  };

Genre genreFromJson(Map<String, dynamic> json){
  return Genre(json[_genreJsonKeys['id']], json[_genreJsonKeys['name']]);
}

