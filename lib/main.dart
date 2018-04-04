import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget i  s the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data;
  bool _progressBarActive = true;
  var subscription;

  Future<Null> _neverSatisfied() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      child: new AlertDialog(
        title: new Text('No network connection.'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('Your network connection seems to be disabled'),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Ok'),
            onPressed: () => exit(0),
          ),
        ],
      ),
    );
  }

  /// You need to use a FutureBuilder.
  /// Add your async function in the future argument otherwise the
  /// build method gets called before the data are obtained.
  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://api.github.com/users"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      _progressBarActive = false;
      data = json.decode(response.body);
    });
    return "Success!";
  }

  @override
  void initState() {
/*    var connectivityResult = new Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {*/
    this.getData();
    /* } else {
      _neverSatisfied();
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Listviews"),
      ),
      body: _progressBarActive == true
          ? new Center(child: const CircularProgressIndicator())
          : new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int position) {
          return new ListTile(
            title: new Text(data[position]['login'].toString()),
            subtitle: new Text(data[position]['url']),
            leading: new Image.network(data[position]['avatar_url']),
          );
        },
      ),
    );
  }
}
