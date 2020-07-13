import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordState createState() => RandomWordState();
}

class RandomWordState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();
  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        if (item.isOdd) return Divider();

        final index = item ~/ 2;
        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_randomWordPairs[index]);
      },
    );
  }

  Widget _buildRow(WordPair _wordpair) {
    final _alreadysaved = _savedWordPairs.contains(_wordpair);
    return ListTile(
        title: Text(_wordpair.asPascalCase, style: TextStyle(fontSize: 18)),
        trailing: Icon(_alreadysaved ? Icons.favorite : Icons.favorite_border,
            color: _alreadysaved ? Colors.red : null),
        onTap: () {
          setState(() {
            if (_alreadysaved)
              _savedWordPairs.remove(_wordpair);
            else
              _savedWordPairs.add(_wordpair);
          });
        });
  }

  void _pushsaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair) {
        return ListTile(
            title: Text(pair.asPascalCase, style: TextStyle(fontSize: 16)));
      });

      final List<Widget> divider =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return Scaffold(
          appBar: AppBar(title: Text("Saved WordPairs")),
          body: ListView(children: divider));
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WordPair Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushsaved)
        ],
      ),
      body: _buildList(),
    );
  }
}
