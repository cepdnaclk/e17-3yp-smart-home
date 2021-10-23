import 'package:flutter/material.dart';
import 'package:exploreflutter/login.dart';

//Our app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mr Login',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LoginPage(),
    );
  }
}

//main function
void main() => runApp(MyApp());

