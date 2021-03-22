import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:jolt/views/utilities/size_config.dart';
import 'package:jolt/views/discovery_screen/discovery_feed.dart';
import 'package:jolt/models/interactions_model.dart';
import 'package:jolt/models/nearby_users_model.dart';
import 'package:jolt/models/authentication_model.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback toggleLoginScreen;
  SignUpScreen({
    @required this.toggleLoginScreen,
  });
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String name = '';
  String password = '';
  String email = '';
  String birthDate = '';
  String phoneNumber = '';
  String gender = '';

  File profilePicture;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: Container(
        width: SizeConfig.blockSizeHorizontal * 80,
        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10),
        child: Form(
          // margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  child: Text(
                    'Sign up for Jolt!',
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
                    labelText: 'Name',
                    hintText: 'Full Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    name = value;
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
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    hintText: 'mm/dd/yy',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    birthDate = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'xxx-xxx-xxxx',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    hintText: 'M/F',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    gender = value;
                  },
                ),
                IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () async {
                    final picturePicked = await ImagePicker()
                        .getImage(source: ImageSource.camera);
                    profilePicture = File(picturePicked.path);
                  },
                ),
                CupertinoButton(
                  child: Text('Submit'),
                  onPressed: () async {
                    try {
                      String userId = await Provider.of<AuthenticationModel>(
                        context,
                        listen: false,
                      ).signUp(
                        name: name,
                        birthDate: birthDate,
                        phoneNumber: phoneNumber,
                        gender: gender,
                        email: email,
                        password: password,
                        location: '',
                        imageToUpload: profilePicture,
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
                        // handle login issues here
                        print('couldnt sign up user');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
                CupertinoButton(
                  child: Text('Already have an account? Login!'),
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
