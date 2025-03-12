import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pilem/models/movie.dart';

class ApiServices {
  static const String apikey = '6a21aae48563a82f5b7ed29b430e6633';
  static const String baseURL = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getAllMovies() async {
    final res =
        await http.get(Uri.parse("$baseURL/movie/now_playing?api_key=$apikey"));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }

  Future<List<Movie>> getTrendingMovies() async {
    final res = await http
        .get(Uri.parse("$baseURL/trending/movie/week?api_key=$apikey"));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load trending movies");
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    final res =
        await http.get(Uri.parse("$baseURL/movie/popular?api_key=$apikey"));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load popular movies");
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final res = await http
        .get(Uri.parse("$baseURL/search/movie?query=$query&api_key=$apikey"));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }


}
