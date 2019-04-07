import 'package:flutter/material.dart';
import './screenUi/TodoScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => TodoScreen(),
      },
    );
  }
}

class TodoSrceen {
}