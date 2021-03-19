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
    String pictureUrl, // might want to make this required in the future
  }) async {
    try {
      await _databaseReference.collection('users').document(userId).setData({
        'name': name,
        'birthDate': birthDate,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'email': email,
        'location': location,
        'pictureUrl': pictureUrl
      });
      await initializeChat(userId);
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
    Map<String, User> nearbyUsers = new Map();
    _databaseReference
        .collection('users')
        .where('location', isEqualTo: myCurrentAddress)
        .snapshots()
        .listen((res) {
      res.documentChanges.forEach((change) {
        // Grab the current user
        var doc = change.document;
        var user = doc.data;
        User currUser = new User(
          name: user['name'],
          email: user['email'],
          phoneNumber: user['phoneNumber'],
          birthDate: user['birthDate'],
          userId: doc.documentID,
          gender: user['gender'],
          pictureUrl: user['pictureUrl'],
          location: user['location'],
        );

        switch (change.type) {
          case DocumentChangeType.added:
            {
              nearbyUsers[doc.documentID] = currUser;
              print('document added');
            }
            break;
          case DocumentChangeType.removed:
            {
              nearbyUsers.remove(doc.documentID);
              print('document removed');
            }
            break;
          case DocumentChangeType.modified:
            {
              if (user['location'] != myCurrentAddress) {
                nearbyUsers.remove(doc.documentID);
              }
              print('document modified');
            }
            break;
          default:
            {
              print('default case');
            }
            break;
        }
        callback(nearbyUsers);
      });
    });
  }

  void listenForChats(String userId, Function(Map<String, dynamic>) callback) {
    _databaseReference
        .collection('chats')
        // .document(userId)
        // .collection('interactions')
        // .snapshots()
        .where('documentID', isEqualTo: userId)
        .snapshots()
        .listen((res) {
      res.documentChanges.forEach((change) {
        print('got a change');
        if (change.type == DocumentChangeType.modified) {
          callback(change.document.data);
        }
      });
    });
  }

  Future<bool> wave(String idSource, String idTarget) async {
    try {
      await _databaseReference
          .collection('chats')
          .document(idTarget)
          .updateData({
        'interactions.$idSource': new DateTime.now().toString() + '+wave'
      });
      return true;
    } catch (e) {
      print('Couldn\'t wave at: $idTarget $e');
      return false;
    }
  }

  Future<void> initializeChat(String userId) {
    return _databaseReference
        .collection('chats')
        .document(userId)
        .setData({'chat': [], 'interactions': []});
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
