import 'dart:io';

import 'package:http/http.dart' as http;
const posterPath = 'http://image.tmdb.org/t/p/original/';
const _token = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzOGZmNTI5YjFkNjVhNWMxMDQzZjg2MmJmNzk0YTIxNCIsInN1YiI6IjVlZTE1ZmVhNGMxYmIwMDAxZWEzNjRhMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.MRseAgIWSaHOOEu7ObcJ64URJH4cwjg6wrAeZBoVdx4';
const _authString = 'Bearer $_token';
const _v3BaseUrl = 'https://api.themoviedb.org/3/';
//const _v4BaseUrl = 'https://api.themoviedb.org/4/';


Future<http.Response> getGenres() async{
  const url = '${_v3BaseUrl}genre/movie/list';
  final response = await http.get(url,headers:{HttpHeaders.authorizationHeader:_authString});
  return response;
}

Future<http.Response> getPopularMoviesFromServer() async{
    const url = '${_v3BaseUrl}movie/popular';
    final response = await http.get(url,headers: {HttpHeaders.authorizationHeader:_authString});
    return response;
}