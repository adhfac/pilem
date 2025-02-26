import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiServices _apiServices = ApiServices();
  List<Movie> _allMovies = [];

  Future<void> _loadMovies() async {
    final List<Map<String, dynamic>> allMoviesData =
        await _apiServices.getAllMovies();

    setState(() {
      _allMovies = allMoviesData.map((e) => Movie.fromJson(e)).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilem'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'All Movies',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _allMovies.length,
                itemBuilder: (BuildContext context, int index){
                  final Movie movie = _allMovies[index];
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.network('https://image.tmdb.org/t/p/w500${movie.posterPath}', height: 150, width: 150, fit: BoxFit.cover,),
                        const SizedBox(height: 5,),
                        Text(movie.title.length > 14 ? '${movie.title.substring(0, 10)}...' : movie.title),
                        
                      ],
                    ),
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
