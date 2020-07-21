import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import './authentication.dart';
import './image_storage_service.dart';
import './size_config.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback loginCallback;
  final BaseAuth auth;
  final VoidCallback toggleLoginScreen;
  SignUpScreen({
    @required this.loginCallback,
    @required this.auth,
    @required this.toggleLoginScreen,
  });
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String username = '';
  String password = '';
  String email = '';
  String birthDate = '';
  String phoneNumber = '';
  // keep as a string in case we want to add to this
  // maybe an enum would be better
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
                      print(
                          '$email, $password, $username, $birthDate, $gender, $phoneNumber, $profilePicture');
                      String userId =
                          await widget.auth.signUp(email.trim(), password);
                      print('signed up user ' + userId);
                      ImageStorageResult result = await ImageStorageService()
                          .uploadImage(
                              imageToUpload: profilePicture, userId: email);
                      print(result.imageUrl);
                      widget.loginCallback();
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
