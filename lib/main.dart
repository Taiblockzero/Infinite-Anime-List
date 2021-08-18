// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';

import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Anime List',
      home: RandomWords(),
    );
  }
}

//aaaaaa
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  var url;
  var _animeInfoJson = [];

  void fetchPosts(var urlParam) async {
    try {
      final response = await get(Uri.parse(urlParam));
      final jsonData = jsonDecode(response.body);
      setState(() {
        _animeInfoJson = (jsonData[data][attributes][titles][en] as List);
      });
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Anime List'),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildRow(var animeName) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            //generate 10 random numbers and put them in a temporary list
            var randomList = [];
            Random random = new Random();

            for (var j = 0; j < 10; j++) {
              int randomNum = random.nextInt(50000);
              randomList.add(randomNum);
            }
            //get the animes with those IDs from the mal api
            var animeNames = [];
            for (var randNum in randomList) {
              url = "https://kitsu.io/api/edge/anime/" + randNum.toString();
              fetchPosts(url);
              //put the anime name into the list

              _suggestions.add(_animeInfoJson[data][attributes][titles][en]);
            }

            //put the 10 anime names into the list
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(randomNum);
        });
  }
}
