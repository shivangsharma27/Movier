import 'package:flutter/foundation.dart';

class Movie {
  final String filePath;
  final String title;
  final String director;
  final double rating;
  

  Movie({
    @required this.filePath,
    @required this.title,
    @required this.director,
    @required this.rating,
  });
}
