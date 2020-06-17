import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_assistant/models/genre.dart';
import 'package:movie_assistant/models/movie.dart';

class HomeViewModel with ChangeNotifier {
  var _isLoading = true;
  bool get isLoading => _isLoading;
  final Set<Genre> _displayGenreList = Set();
  Set<Genre> get displayGenreList => _displayGenreList;
  final Set<Movie> _mainMovieList;
  List<Movie> _displayMovieList;
  List<Movie> get movies => this._displayMovieList;
  Set<int> _filterGenres = Set();
  Set<int> get filterGenres => _filterGenres;

  HomeViewModel(this._mainMovieList){
    _init();
  }

 addFilterGenre(int genreId) {
    _filterGenres.add(genreId);
    _filterMovies();
    notifyListeners();
  }

  removeFilterGenre(int genreId) {
    _filterGenres.remove(genreId);
    _filterMovies();
    notifyListeners();
  }

  _init() async {
    _setGenres();
    _displayMovieList = [..._mainMovieList];
    _isLoading = _displayMovieList.isEmpty;
  }

  _filterMovies() {
    this._displayMovieList.clear();
    if (_filterGenres.isEmpty)
      this._displayMovieList = [..._mainMovieList];
    else
      this._displayMovieList.addAll(_mainMovieList
          .where((movie) => _isAnyFilterGenresInMovieGenres(movie)));   
  }


  bool _isAnyFilterGenresInMovieGenres(Movie movie) {
    var isContain = false;
    for (int i = 0; i < movie.genres.length; i++) {
      final genreId = movie.genres[i].id;
      if (filterGenres.contains(genreId)) {
        isContain = true;
        break;
      }
    }
    return isContain;
  }

  _setGenres() {
     this._mainMovieList.forEach((movie) => movie.genres.forEach((genre) => this._displayGenreList.add(genre)));
  }

}

class CurrentMovieIndex extends ValueNotifier {
  int index;
  int _listLastIndex;

  CurrentMovieIndex(this.index, this._listLastIndex) : super(index);

  nextMovie(){
    if(++index <= _listLastIndex) this.value = index;
      else {
        this.index = 0;
        this.value = 0;
      }
    }

  previousMovie(){
    if(--index >= 0) this.value = index;
      else {
        this.index = this._listLastIndex;
        this.value = this._listLastIndex;
      }
    }
}
