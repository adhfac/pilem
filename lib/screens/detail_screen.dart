import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isFavorite = false;

  Future<void> _checkIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = prefs.containsKey('movie_${widget.movie.id}');
    });
  }

  Future<void> _toggleFav() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = !_isFavorite;
    });
    if (_isFavorite) {
      final String movieJson = jsonEncode(widget.movie.toJson());
      prefs.setString('movie_${widget.movie.id}', movieJson);

      List<String> favoriteMovieIds =
          prefs.getStringList('favoriteMovies') ?? [];
      favoriteMovieIds.add(widget.movie.id.toString());
      prefs.setStringList('favoriteMovies', favoriteMovieIds);
    } else {
      prefs.remove('movie_${widget.movie.id}');
      List<String> favoriteMovieIds =
          prefs.getStringList('favoriteMovies') ?? [];
      favoriteMovieIds.remove(widget.movie.id.toString());
      prefs.setStringList('favoriteMovies', favoriteMovieIds);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIsFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 10, top: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10, top: 10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
                icon: Icon(
                    _isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: Colors.white),
                onPressed: _toggleFav),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image with gradient overlay
            Stack(
              children: [
                // Backdrop image
                Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Gradient overlay
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF0D0D0D).withOpacity(0.8),
                        const Color(0xFF0D0D0D),
                      ],
                    ),
                  ),
                ),
                // Poster and info on top of backdrop
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Poster with elevation
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                              height: 150,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Title and rating
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.movie.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'iceberg',
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Rating with stars
                              Row(
                                children: [
                                  _buildRatingStars(widget.movie.voteAverage),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${widget.movie.voteAverage}/10',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'iceberg',
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Movie stats in a card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(Icons.calendar_today, 'Released',
                      _formatDate(widget.movie.releaseDate)),
                  _buildStatItem(Icons.thumb_up, 'Votes',
                      widget.movie.voteCount.toString()),
                  _buildStatItem(Icons.star, 'Rating',
                      widget.movie.voteAverage.toString()),
                ],
              ),
            ),

            // Overview section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'iceberg',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.movie.overview,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontFamily: 'iceberg',
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper method to build star rating
  Widget _buildRatingStars(double rating) {
    int fullStars = rating ~/ 2;
    bool hasHalfStar = (rating - fullStars * 2) >= 1;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      children: [
        ...List.generate(fullStars,
            (_) => const Icon(Icons.star, color: Colors.amber, size: 18)),
        if (hasHalfStar)
          const Icon(Icons.star_half, color: Colors.amber, size: 18),
        ...List.generate(
            emptyStars,
            (_) =>
                const Icon(Icons.star_border, color: Colors.amber, size: 18)),
      ],
    );
  }

  // Helper method to build stat item
  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'iceberg',
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'iceberg',
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Helper method to format date
  String _formatDate(String date) {
    try {
      final DateTime dateTime = DateTime.parse(date);
      return '${dateTime.year}';
    } catch (e) {
      return date;
    }
  }
}
