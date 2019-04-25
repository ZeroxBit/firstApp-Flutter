import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:http/http.dart' as http;

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
  final _list = <dynamic>[];
  final _selectPair = Set<dynamic>();
  final _font = const TextStyle(fontSize: 18.0);

  List list; 

  final url = "";
  final body = {}; 

  Future getData() async {
    const jsonCode = const JsonCodec();
    final bodyJson = jsonCode.encode(body);

    http.Response response = await http.post( Uri.encodeFull(url), headers: { "Content-Type": "application/json" }, body: bodyJson );

    var listado = jsonCode.decode( response.body );

    setState(() {
     list = listado; 
    });
    debugPrint( list.toString() );
 
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

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
      body: ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: ( BuildContext context, int index ) {
          return Card(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.blue,
                ),
                Column(
                  children: <Widget>[
                    Text("Vendedor - ${list[index]["NombreVendedor"]}"),
                    Text("Razon social - ${list[index]["RazonSocial"]}"),
                    Text("Numero de documento - ${list[index]["NumDocumento"]}"),
                  ],
                )
              ],
            ),
          );
        },
      ),
      
    );
  }

  void pushReadyInSet() {
    Navigator.of(context).push( 
      MaterialPageRoute(
        builder: (context) {
          final titles = _selectPair.map( (pair) {
            return ListTile(
              title: Text( 
                "Nombre",
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
        // if (i >= list.length) {
        //   _list.addAll(generateWordPairs().take(10));
        // }

        final index = i ~/ 2;

        return _buildRow(list[index]);
      },
    );
  }

  Widget _buildRow(dynamic pair) {
    final readyInSet = _selectPair.contains( pair );
    return ListTile(
      title: Text(
        pair["NombreVendedor"],
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
