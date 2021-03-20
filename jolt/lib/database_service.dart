import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:async';

// class that widgets can import to perform operations on the database
class DatabaseService {
  static final DatabaseService _database = DatabaseService._internal();
  final _databaseReference = Firestore.instance;
  StreamSubscription<QuerySnapshot> _nearbyUsersSubscription;
  List<StreamSubscription<QuerySnapshot>> _chatSubscriptions;

  // test to make sure the integration works
  void callDatabase() {
    print('called database');
  }

  // register a listener to process certain topic data
  void subscribe(
      JoltTopic topic, Function dataCallback, Map<String, String> arguments) {
    switch (topic) {
      case JoltTopic.nearbyUsers:
        {
          _nearbyUsersSubscription =
              subscribeToNearbyUsers(arguments, dataCallback);
        }
        break;
      case JoltTopic.chats:
        {
          _chatSubscriptions = subscribeToChats(arguments, dataCallback);
        }
        break;
      default:
        break;
    }
  }

  // remove a listener and stop processing topic data
  void unsubscribe(JoltTopic topic) {
    switch (topic) {
      case JoltTopic.nearbyUsers:
        {
          // Cancel nearby users subscription
          if (_nearbyUsersSubscription != null) {
            _nearbyUsersSubscription.cancel();
            _nearbyUsersSubscription = null;
          }
        }
        break;
      case JoltTopic.chats:
        {
          // Cancel all chat subscriptions
          if (_chatSubscriptions.isNotEmpty) {
            _chatSubscriptions.forEach((chat) {
              chat.cancel();
            });
            _chatSubscriptions.clear();
          }
        }
    }
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
    List<String> conversationIds = const [],
  }) async {
    try {
      await _databaseReference.collection('users').document(userId).setData({
        'name': name,
        'birthDate': birthDate,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'email': email,
        'location': location,
        'pictureUrl': pictureUrl,
        'conversationIds': [],
      });
      return true;
    } catch (e) {
      print('error adding document ${e.message}');
      return false;
    }
  }

  // attach a listener to track nearby users to the current user
  // take a callback to handle any users that are nearby
  StreamSubscription<QuerySnapshot> subscribeToNearbyUsers(
    Map<String, String> arguments,
    Function(Map<String, User>) callback,
  ) {
    String myCurrentAddress;

    if (arguments.containsKey('myCurrentAddress')) {
      myCurrentAddress = arguments['myCurrentAddress'];
    } else {
      throw Exception('Missing required myCurrentAddress parameter');
    }

    Map<String, User> nearbyUsers = new Map();

    return _databaseReference
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

  // register a callback to listen to chat data
  List<StreamSubscription<QuerySnapshot>> subscribeToChats(
      Map<String, String> arguments, Function(Map<String, dynamic>) callback) {
    List<String> myConversations;
    List<StreamSubscription<QuerySnapshot>> chatSubs;

    if (arguments.containsKey('myCurrentAddress')) {
      // conversation ids will be supplied delimited by ';'
      myConversations = arguments['myConversations'].split(';');
    } else {
      throw Exception('Missing required myConversations parameter');
    }

    myConversations.forEach((String conversationId) {
      var conversationStream = _databaseReference
          .collection('conversations')
          .document('messages')
          .collection(conversationId)
          .snapshots()
          .listen((res) {
        res.documentChanges.forEach((change) {
          switch (change.type) {
            case DocumentChangeType.added:
              {
                print('document added text: ' + change.document.data['text']);
              }
              break;
            case DocumentChangeType.removed:
              {
                print('document removed' + change.document.data['text']);
              }
              break;
            case DocumentChangeType.modified:
              {
                print('document modified' + change.document.data['text']);
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

      // Keep track of the stream subscriptions
      chatSubs.add(conversationStream);
    });

    return chatSubs;
  }

  // send a wave to another user
  Future<bool> wave(String idSource, String idTarget) async {
    try {
      await _databaseReference
          .collection('interactions/$idTarget/interactions')
          .add({
        'incomingUserId': idSource,
        'timestamp': new DateTime.now().toString(),
        'interactionType': 'wave',
      });
      return true;
    } catch (e) {
      print('Couldn\'t wave at: $idTarget $e');
      return false;
    }
  }

  // send a wink to another user
  Future<bool> wink(String idSource, String idTarget) async {
    try {
      await _databaseReference
          .collection('interactions/$idTarget/interactions')
          .add({
        'incomingUserId': idSource,
        'timestamp': new DateTime.now().toString(),
        'interactionType': 'wink',
      });
      return true;
    } catch (e) {
      print('Couldn\'t wink at: $idTarget $e');
      return false;
    }
  }

  // send a text message to another user
  Future<bool> sendMessage(
      String idSource, String idTarget, String text) async {
    try {
      String conversationId;

      if (idSource.compareTo(idTarget) < 0) {
        conversationId = '$idSource+$idTarget';
      } else {
        conversationId = '$idTarget+$idSource';
      }

      await _databaseReference
          .collection('conversations/$conversationId/messages')
          .add({
        'sentBy': idSource,
        'timestamp': new DateTime.now().toString(),
        'text': text,
      });
      return true;
    } catch (e) {
      print('Couldn\'t wink at: $idTarget $e');
      return false;
    }
  }

  // adds a conversation id to be tracked by a user
  Future<bool> addConversationId(String userId, String conversationId) async {
    try {
      await _databaseReference.collection('users').document(userId).updateData({
        'conversationIds': FieldValue.arrayUnion([conversationId]),
      });
      return true;
    } catch (e) {
      print('error trying to add conversation id: $e.message');
      return false;
    }
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

  List<String> conversations = [];

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

enum JoltTopic {
  nearbyUsers,
  chats,
}
