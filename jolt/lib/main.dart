import 'package:flutter/material.dart';
import './root_page.dart';
import './authentication.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootPage(auth: Auth()),
    );
  }
}
