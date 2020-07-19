import 'package:flutter/material.dart';
import './discovery_feed.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DiscoveryFeed(),
    );
  }
}

// class _MyAppState extends State<MyApp> {
//   var _questionIndex = 0;

//   void _answerQuestion() {
//     setState(() {
//       _questionIndex = (_questionIndex + 1) % 3;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var questions = [
//       'whats ur fav color',
//       'whats your fav animal',
//       'whats ur fav show',
//     ];
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('my first app')),
//         body: Column(
//           children: <Widget>[
//             Question(questions[_questionIndex]),
//             RaisedButton(
//               child: Text('Answer 1'),
//               onPressed: _answerQuestion,
//             ),
//             RaisedButton(
//               child: Text('Answer 2'),
//               onPressed: _answerQuestion,
//             ),
//             RaisedButton(
//               child: Text('Answer 3'),
//               onPressed: _answerQuestion,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
