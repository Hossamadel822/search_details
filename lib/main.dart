import 'package:flutter/material.dart';
import 'package:search/searchScreenTab.dart';



void main() => runApp(TMDBApp());

class TMDBApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Searchsceentab(),
    );
  }
}
