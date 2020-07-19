import 'package:flutter/material.dart';
import './jolter_selected_screen.dart';
import './discovery_feed.dart';
import './login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
