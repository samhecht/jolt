import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:jolt/views/utilities/size_config.dart';
import 'package:jolt/views/discovery_screen/discovery_feed.dart';
import 'package:jolt/models/interactions_model.dart';
import 'package:jolt/models/authentication_model.dart';
import 'package:jolt/models/nearby_users_model.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback toggleLoginScreen;
  LoginScreen({
    @required this.toggleLoginScreen,
  });
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';

  String password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        width: SizeConfig.blockSizeHorizontal * 80,
        margin: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 10,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'email@email.com',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    email = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'password',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    password = value;
                  },
                ),
                CupertinoButton(
                  child: Text('Submit'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        String userId = await Provider.of<AuthenticationModel>(
                          context,
                          listen: false,
                        ).signIn(
                          email.trim(),
                          password,
                        );
                        if (userId.isNotEmpty) {
                          Provider.of<InteractionsModel>(
                            context,
                            listen: false,
                          ).userId = userId;
                          Provider.of<NearbyUsersModel>(
                            context,
                            listen: false,
                          ).userId = userId;
                          Navigator.pushNamed(
                            context,
                            DiscoveryFeed.routeName,
                          );
                        } else {
                          print('couldnt login user');
                        }
                      } catch (e) {
                        print('Error logging in: ' + e.message);
                      }
                    } else {
                      print('form invalid');
                    }
                  },
                ),
                CupertinoButton(
                  child: Text('Don\'t have an account? Sign up!'),
                  onPressed: () {
                    widget.toggleLoginScreen();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
