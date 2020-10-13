import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

// class that widgets can import to perform operations on the database
class DatabaseService {
  static final DatabaseService _database = DatabaseService._internal();
  final _databaseReference = Firestore.instance;

  // test to make sure the integration works
  void callDatabase() {
    print('called database');
  }

  // insert a new user into the database
  Future<bool> insertUser({
    @required String name,
    @required String birthDate,
    @required String phoneNumber,
    @required String gender,
    @required String email,
    @required String location,
    @required String userId,
    String pictureUrl,
  }) async {
    try {
      await _databaseReference.collection('users').document(userId).setData({
        'name': name,
        'birthDate': birthDate,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'email': email,
        'location': location,
        'pictureUrl':
            pictureUrl != null ? pictureUrl : 'assets/images/wink.png',
      });
      return true;
    } catch (e) {
      print('error adding document ${e.message}');
      return false;
    }
  }

  // attach a listener to track nearby users to the current user
  // take a callback to handle any users that are nearby
  void listenForNearbyUsers(
    String myCurrentAddress,
    Function(Map<String, User>) callback,
  ) async {
//    print('curr addy $myCurrentAddress');
//    Map<String, User> nearbyUsers = new Map();
//    _databaseReference
//        .collection('users')
//        .where('location', isEqualTo: myCurrentAddress)
//        .snapshots()
//        .listen(
//      (data) {
//        data.documents.forEach((user) {
//          User currUser = new User(
//            name: user['name'],
//            email: user['email'],
//            phoneNumber: user['phoneNumber'],
//            birthDate: user['birthDate'],
//            userId: user.documentID,
//            gender: user['gender'],
//            pictureUrl: user['pictureUrl'],
//            location: user['location'],
//          );
//          nearbyUsers[user.documentID] = currUser;
//          // need to hook into events like deletes and whatnot
//        });
//        callback(nearbyUsers);
//      },
//    );
    _databaseReference
        .collection('users')
        // .where('location', isEqualTo: myCurrentAddress)
        .snapshots()
        .listen((res) {
      res.documentChanges.forEach((change) {
        switch (change.type) {
          case DocumentChangeType.added:
            {
              print('document added');
            }
            break;
          case DocumentChangeType.removed:
            {
              print('document removed');
            }
            break;
          case DocumentChangeType.modified:
            {
              print('document modified');
            }
            break;
          default:
            {
              print('default case');
            }
            break;
        }
      });
    });
  }

  // update a users address, returns true if it works
  Future<bool> updateUserAddress({
    @required String userId,
    @required String newAddress,
  }) async {
    try {
      await _databaseReference
          .collection('users')
          .document(userId)
          .updateData({'location': newAddress});
      return true;
    } catch (e) {
      print('error updating user address $e.message');
      return false;
    }
  }

  // creates a database service singleton to create an entry to the db
  factory DatabaseService() {
    return _database;
  }

  DatabaseService._internal();
}

// create a user class to template user objects
class User {
  final String name;
  final String phoneNumber;
  final String email;
  final String gender;
  final String birthDate;
  final String userId;
  final String pictureUrl;
  final String location;

  User({
    @required this.name,
    @required this.phoneNumber,
    @required this.email,
    @required this.gender,
    @required this.birthDate,
    @required this.userId,
    @required this.pictureUrl,
    @required this.location,
  });
}
