import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/services/api_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiServices _apiServices = ApiServices();
  final TextEditingController _searchController = TextEditingController();
  List <Movie> _searchResults = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _searchMovies(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Search', style: TextStyle(fontFamily: 'iceberg', color: Colors.white),), backgroundColor: Colors.black,),
      body:  Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari film...',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(fontFamily: 'iceberg', color: Colors.white)
                    ),
                    onSubmitted: (_) => _searchMovies(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchMovies,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? const Center(child: Text('Belum ada hasil', style: TextStyle(fontFamily: 'iceberg', color: Colors.white)))
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final movie = _searchResults[index];
                      return ListTile(
                        leading: Image.network(
                          movie.posterPath,
                          width: 90,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                        title: Text(movie.title),
                        subtitle: Text(movie.releaseDate ?? 'Tidak diketahui'),
                        onTap: () {
                          
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}