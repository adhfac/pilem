import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/screens/detail_screen.dart';
import 'package:pilem/services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiServices _apiServices = ApiServices();
  List<Movie> _allMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];

  Future<void> _loadMovies() async {
    try {
      final movies = await _apiServices.getAllMovies();
      final trending = await _apiServices.getTrendingMovies();
      final popular = await _apiServices.getPopularMovies();
      setState(() {
        _allMovies = movies;
        _trendingMovies = trending;
        _popularMovies = popular;
      });
    } catch (e) {
      print("Error loading movies: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Widget _buildTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'iceberg',
          color: color,
        ),
      ),
    );
  }

  Widget _buildMovies(List<Movie> movies) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(15),
              splashColor: Colors.blueAccent.withOpacity(0.5),
              highlightColor: Colors.greenAccent.withOpacity(0.3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        movie.posterPath.isNotEmpty
                            ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                            : 'https://via.placeholder.com/90x160?text=No+Image',
                        height: 160,
                        width: 90,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        movie.title.length > 14
                            ? '${movie.title.substring(0, 10)}...'
                            : movie.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'iceberg',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Top Mov',
            style: TextStyle(
                fontFamily: 'iceberg',
                color: Color.fromARGB(255, 255, 45, 45))),
        backgroundColor: Colors.black,
        elevation: 4,
        centerTitle: true,
      ),
      body: _allMovies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle('All Movies', Colors.greenAccent),
                  _buildMovies(_allMovies),
                  _buildTitle('Trending Movies', Colors.cyanAccent),
                  _buildMovies(_trendingMovies),
                  _buildTitle('Popular Movies', Colors.orangeAccent),
                  _buildMovies(_popularMovies),
                ],
              ),
            ),
    );
  }
}
