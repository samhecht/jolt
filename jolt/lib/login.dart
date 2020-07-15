import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatelessWidget {
  String username = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jolt Login'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              child: Text(
                'Login to Jolt!',
                style: TextStyle(fontSize: 20),
              ),
              padding: EdgeInsets.only(bottom: 10, top: 10),
            ),
            Padding(
              child: CupertinoTextField(
                onChanged: (value) {
                  username = value;
                },
              ),
              padding: EdgeInsets.only(bottom: 5),
            ),
            CupertinoTextField(
              onChanged: (value) {
                password = value;
              },
            ),
            CupertinoButton(
                child: Text('Submit'),
                onPressed: () {
                  print('username: ' + username + ', password: ' + password);
                }),
          ],
        ),
      ),
    );
  }
}
