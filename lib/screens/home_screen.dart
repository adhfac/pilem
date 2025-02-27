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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'PILEM',
          style: TextStyle(
            fontFamily: 'iceberg',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 3,
            shadows: [
              Shadow(
                color: Colors.cyanAccent,
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.7),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.cyanAccent),
            onPressed: () {
              // Search functionality
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background grid pattern
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(),
            ),
          ),
          _allMovies.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top space for AppBar
                      const SizedBox(height: 80),
                      
                      // All Movies Section
                      _buildSectionTitle('All Movies', Colors.greenAccent),
                      _buildMovieList(_allMovies),
                      
                      // Trending Movies Section
                      _buildSectionTitle('Trending Movies', Colors.cyanAccent),
                      _buildMovieList(_trendingMovies),
                      
                      // Popular Movies Section
                      _buildSectionTitle('Popular Movies', Colors.orangeAccent),
                      _buildMovieList(_popularMovies),
                      
                      // Bottom padding
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 24,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'iceberg',
              color: accentColor,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  color: accentColor.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            'View All',
            style: TextStyle(
              fontFamily: 'iceberg',
              color: accentColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: accentColor.withOpacity(0.7),
            size: 18,
          ),
        ],
      ),
    );
  }
  
  Widget _buildMovieList(List<Movie> movies) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => MovieDetailScreen(movie: movie),
                    transitionDuration: const Duration(milliseconds: 500),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Container(
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poster with rating badge
                    Stack(
                      children: [
                        // Poster
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 160,
                                color: Colors.grey[800],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white54,
                                ),
                              );
                            },
                          ),
                        ),
                        
                        // Rating badge
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getRatingColor(movie.voteAverage),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: _getRatingColor(movie.voteAverage),
                                  size: 12,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  movie.voteAverage.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: _getRatingColor(movie.voteAverage),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'iceberg',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Shimmer effect overlay
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.cyanAccent.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Title and year
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title.length > 14
                                ? '${movie.title.substring(0, 10)}...'
                                : movie.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'iceberg',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _extractYear(movie.releaseDate),
                            style: const TextStyle(
                              fontFamily: 'iceberg',
                              fontSize: 10,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Color _getRatingColor(double rating) {
    if (rating >= 8.0) return Colors.greenAccent;
    if (rating >= 6.0) return Colors.orangeAccent;
    return Colors.redAccent;
  }
  
  String _extractYear(String releaseDate) {
    try {
      return releaseDate.substring(0, 4);
    } catch (e) {
      return '';
    }
  }
}

// Grid pattern painter (reused from splash screen)
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.05)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
      
    const double step = 30;
    
    // Draw vertical lines
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}