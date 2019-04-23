import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My first app",  
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightGreenAccent
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return randomWordsState();
  }
}

class randomWordsState extends State<RandomWords> {
  final _list = <WordPair>[];
  final _selectPair = Set<WordPair>();
  final _font = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generator random name"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.list
            ),
            onPressed: pushReadyInSet,
          )
        ],
      ),
      body: _buildList(),
    );
  }

  void pushReadyInSet() {
    Navigator.of(context).push( 
      MaterialPageRoute(
        builder: (context) {
          final titles = _selectPair.map( (pair) {
            return ListTile(
              title: Text( 
                pair.asPascalCase,
                style: _font,
              ),

            );
          });

          final divided = ListTile.divideTiles( 
            context: context,
            tiles: titles,  
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("Saved List"),
            ),
            body: ListView(
              children: divided,
            ),
          );
        }),
     );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if ( i.isOdd ) { // si el indice no es par !!
          return Divider();
        }
        if (i >= _list.length) {
          _list.addAll(generateWordPairs().take(10));
        }

        final index = i ~/ 2;

        return _buildRow(_list[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final readyInSet = _selectPair.contains( pair );
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _font,
      ),
      trailing: Icon(
        readyInSet ? Icons.favorite : Icons.favorite_border,
        color: readyInSet ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          readyInSet ? _selectPair.remove( pair ) : _selectPair.add( pair );
        });
      },
    );
  }
}
