import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/screens/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Movie> _favoriteMovies = [];

  Future<void> _loadFavoriteMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favoriteMovieIds =
        prefs.getKeys().where((key) => key.startsWith('movie_')).toList();
    print('favoriteMovieIds : $favoriteMovieIds');

    setState(() {
      _favoriteMovies = favoriteMovieIds
          .map((id) {
            final String? movieJson = prefs.getString(id);
            if (movieJson != null && movieJson.isNotEmpty) {
              final Map<String, dynamic> movieData = jsonDecode(movieJson);
              return Movie.fromJson(movieData);
            }
            return null;
          })
          .whereType<Movie>()
          .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadFavoriteMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Your Favorite Movies',
            style: TextStyle(
                fontFamily: 'iceberg',
                color: Color.fromARGB(255, 255, 45, 45))),
        backgroundColor: Colors.black,
        elevation: 4,
        centerTitle: true,
      ),
      body: _favoriteMovies.isEmpty
          ? const Center(
              child: Text(
                'Tambahkan film favorit anda',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'iceberg',
                  color: Colors.white,
                ),
              ),
            )
          : GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _favoriteMovies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.55,
              ),
              itemBuilder: (context, index) {
                final movie = _favoriteMovies[index];
                return InkWell(
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
                          CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            height: 160,
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              );
                            },
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error_rounded,
                              color: Colors.white,
                            ),
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
                            textAlign: TextAlign.center,
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
}
