import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/list_screen.dart';
import 'models/food_waste_post.dart';

class App extends StatefulWidget {
  final String title;

  App({Key key, this.title}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: widget.title,
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.dark,
        home: ListScreen(title: widget.title));
  }
}
