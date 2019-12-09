import 'package:flutter/material.dart';
//import 'package:english_words/english_words.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'Demo Json SystemNotification',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Demo Web Json'),
        ),
        body: new Center(
            child: new Container(
              margin: const EdgeInsets.all(32.0),
              child: new FutureBuilder<SystemNotification>(
                future: fetchPost(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return new Text(
                      snapshot.data.message,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    );
                  } else if (snapshot.hasError) {
                    return new Text("${snapshot.error}");
                  }

                  return new CircularProgressIndicator();
            },
          ),
        )),
      ),
    );
  }
}

Future<SystemNotification> fetchPost() async {
  final response =
      await http.get('https://staging-bulletin.svc.litv.tv/LTIOS03.json');

  final responseJson = json.decode(utf8.decode(response.bodyBytes));

  return new SystemNotification.fromJson(responseJson);
}

class SystemNotification {
  final String img;

  final String level;

  final String uri_caption;

  final String id;

  final String title;

  final String message;

  final String uri;

  SystemNotification(
      {this.img,
      this.level,
      this.uri_caption,
      this.id,
      this.title,
      this.message,
      this.uri});

  factory SystemNotification.fromJson(Map<String, dynamic> json) {
    return new SystemNotification(
      img: json['img'],
      level: json['level'],
      uri_caption: json['uri_caption'],
      id: json['id'],
      title: json['title'],
      message: json['message'],
      uri: json['uri'],
    );
  }
}
