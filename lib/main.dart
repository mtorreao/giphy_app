import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var _title = 'Giphy App';
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.black),
      ),
      home: HomeWidget(title: _title),
    );
  }
}

class HomeWidget extends StatefulWidget {
  String title = 'Giphy App';

  HomeWidget({Key key, String title}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  var _searchController = TextEditingController();
  var _offset = 0;

  Future<Map> _getData() async {
    http.Response response;
    response = _searchController.text.isEmpty
        ? await http.get(
            'https://api.giphy.com/v1/gifs/trending?api_key=kWnhoeSOCKwgU8aRREYw2AFWvtqe8mx4&limit=20rating=G')
        : await http.get(
            'https://api.giphy.com/v1/gifs/search?api_key=kWnhoeSOCKwgU8aRREYw2AFWvtqe8mx4&q=${_searchController.text}&limit=20&offset=$_offset&rating=G&lang=pt');
    return json.decode(response.body);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.network(
              'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Pesquisar por gifs',
                    hintText: 'gatos, cachorros...',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 15.0),
                    labelStyle: TextStyle(color: Colors.white, fontSize: 15.0)),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _getData(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          height: 200.0,
                          width: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if (snapshot.hasError)
                          return Container(
                            child: Text('Ocorreu um erro'),
                          );
                        return GridView.builder(
                            padding: EdgeInsets.all(10.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0),
                            itemCount: snapshot.data['data'].length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  child: Image.network(
                                snapshot.data['data'][index]['images']
                                    ['fixed_height']['url'],
                                height: 200,
                                fit: BoxFit.cover,
                              ));
                            });
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
