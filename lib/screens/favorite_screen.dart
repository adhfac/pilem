import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Your Favorite Movies',
            style: TextStyle(fontFamily: 'iceberg', color: Color.fromARGB(255, 255, 45, 45))),
        backgroundColor: Colors.black,
        elevation: 4,
        centerTitle: true,
      ),
      body: Column(),
    );
  }
}
