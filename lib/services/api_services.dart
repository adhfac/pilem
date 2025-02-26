import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String apikey = '6a21aae48563a82f5b7ed29b430e6633';
  static const String baseURL = 'https://api.themoviedb.org/3';

  Future<List<Map<String, dynamic>>> getAllMovies() async {
    final res =
        await http.get(Uri.parse("$baseURL/movie/now_playing?api_key=$apikey"));
    final data = json.decode(res.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  Future<List<Map<String, dynamic>>> getTrendingMovies() async {
    final res =
        await http.get(Uri.parse("$baseURL/movie/week?api_key=$apikey"));
    final data = json.decode(res.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  Future<List<Map<String, dynamic>>> getPopularMovies() async {
    final res =
        await http.get(Uri.parse("$baseURL/movie/popular?api_key=$apikey"));
    final data = json.decode(res.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }
}
