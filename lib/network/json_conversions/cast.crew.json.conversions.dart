

import 'package:movie_assistant/models/cast.crew.dart';

const _jsonKeys = <String,String>{
  'cast':'cast',
  'crew': 'crew',
};

const _castJsonKeys = <String,String>{
  'id':'id',
  'name':'name',
  'profilePath':'profile_path',
  'role':'character',
};

const _crewJsonKeys = <String,String>{
  'id':'id',
  'name':'name',
  'profilePath':'profile_path',
  'role':'job',
};

List<CastCrew> castAndCrewFromJson(Map<String,dynamic> json){
    final filteredCastJsonArray = _filterCastJsonArray(json[_jsonKeys['cast']]);
    final cast = filteredCastJsonArray.map<CastCrew>((json) => _castFromJson(json));
    final filteredCrewJsonArray = _filterCrewJsonArray(json[_jsonKeys['crew']]);
    final crew = filteredCrewJsonArray.map<CastCrew>((json) => _crewFromJson(json));
    final castAndCrew = [...cast,...crew];
    return castAndCrew;
}

CastCrew _castFromJson(Map<String,dynamic> json){
  return CastCrew(json[_castJsonKeys['id']], json[_castJsonKeys['name']], json[_castJsonKeys['profilePath']], json[_castJsonKeys['role']]);
}

CastCrew _crewFromJson(Map<String,dynamic> json){
  return CastCrew(json[_crewJsonKeys['id']], json[_crewJsonKeys['name']], json[_crewJsonKeys['profilePath']], json[_crewJsonKeys['role']]);
}

List<dynamic> _filterCastJsonArray(List<dynamic> jsonArray){
  final filtered = jsonArray.where((json) => _isValidCastJson(json));
  return [...filtered];
}

List<dynamic> _filterCrewJsonArray(List<dynamic> jsonArray){
  final filtered = jsonArray.where((json) => _isValidCrewJson(json));
  return [...filtered];
}

bool _isValidCastJson(Map<String,dynamic> json){
  return (json[_castJsonKeys['id']] != null) && (json[_castJsonKeys['name']] != null) && (json[_castJsonKeys['profilePath']] != null) && (json[_castJsonKeys['role']] != null); 
}

bool _isValidCrewJson(Map<String,dynamic> json){
  return (json[_crewJsonKeys['id']] != null) && (json[_crewJsonKeys['name']] != null) && (json[_crewJsonKeys['profilePath']] != null) && (json[_crewJsonKeys['role']] != null); 
}