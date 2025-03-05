import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/services/api_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiServices _apiService = ApiServices();
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_searchMovies);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  void _searchMovies() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    final searchData = await _apiService.searchMovies(_searchController.text);
    setState(() {
      _searchResults = searchData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Search',
            style: TextStyle(
                fontFamily: 'iceberg',
                color: Color.fromARGB(255, 255, 45, 45))),
        backgroundColor: Colors.black,
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 130, 196, 251),
                      width: 1.0),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                          color: Colors.white, fontFamily: 'iceberg'),
                      decoration: const InputDecoration(
                        hintText: 'Find Movies...',
                        hintStyle: TextStyle(
                            fontFamily: 'iceberg', color: Colors.white),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _searchController.text.isNotEmpty,
                    child: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchResults.clear();
                        });
                      },
                      icon: const Icon(Icons.cleaning_services_outlined),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Visibility(
                visible: _searchController.text.isNotEmpty,
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_searchResults[index].title,
                          style: const TextStyle(color: Colors.white)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
