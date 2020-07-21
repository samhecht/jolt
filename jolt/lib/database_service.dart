import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class DatabaseService {
  static final DatabaseService _database = DatabaseService._internal();
  final _databaseReference = Firestore.instance;

  void callDatabase() {
    print('called database');
  }

  Future<bool> insertUser({
    @required String name,
    @required String birthDate,
    @required String phoneNumber,
    @required String gender,
    @required String email,
    @required String location,
    @required String userId,
  }) async {
    try {
      await _databaseReference.collection("users").document(userId).setData({
        'name': name,
        'birthDate': birthDate,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'email': email,
        'location': location,
      });
      return true;
    } catch (e) {
      print('error adding document ${e.message}');
      return false;
    }
  }

  factory DatabaseService() {
    return _database;
  }

  DatabaseService._internal();
}
