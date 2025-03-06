import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/screens/detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Movie> _favoriteMovies = [];

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
                          Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            height: 160,
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
