import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:jolt/services/database_service.dart';
import 'package:jolt/services/image_storage_service.dart';
import 'package:jolt/services/authentication.dart';

class AuthenticationModel extends ChangeNotifier {
  User _currentUser;
  final Auth auth = Auth();

  User get currentUser => _currentUser;

  bool get isSignedIn => _currentUser != null;

  bool get isNotSignedIn => _currentUser == null;

  Future<String> checkAuth() async {
    FirebaseUser currFirebaseUser = await auth.getCurrentUser();
    if (currFirebaseUser != null) {
      _currentUser = await DatabaseService().getUser(currFirebaseUser.uid);
      notifyListeners();
      return _currentUser?.userId;
    } else {
      print('not signed in');
      return '';
    }
  }

  Future<String> signIn(String email, String password) async {
    String userId = await auth.signIn(email, password);
    User user = await DatabaseService().getUser(userId);

    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return _currentUser?.userId;
    } else {
      print('coulnt sign in user');
      return '';
    }
  }

  Future<String> signUp({
    String name,
    String birthDate,
    String phoneNumber,
    String gender,
    String email,
    String password,
    String location,
    File imageToUpload,
  }) async {
    try {
      String userId = await auth.signUp(email.trim(), password);
      ImageStorageResult result = await ImageStorageService().uploadImage(
        imageToUpload: imageToUpload,
        userId: userId,
      );
      String pictureUrl = result.imageUrl;

      bool success = await DatabaseService().insertUser(
        name: name,
        birthDate: birthDate,
        phoneNumber: phoneNumber,
        gender: gender,
        email: email,
        location: '',
        userId: userId,
        pictureUrl: pictureUrl,
      );

      if (success) {
        _currentUser = await DatabaseService().getUser(userId);
        notifyListeners();
        return userId;
      } else {
        print('couldnt sign up user');
        return '';
      }
    } catch (e) {
      print('error signing up user $e');
      return '';
    }
  }

  void signOut() async {
    auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  AuthenticationModel();
}
