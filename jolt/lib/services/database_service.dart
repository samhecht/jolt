import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

// class that widgets can import to perform operations on the database
class DatabaseService {
  static final DatabaseService _database = DatabaseService._internal();
  final _databaseReference = Firestore.instance;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  StreamSubscription<QuerySnapshot> _nearbyUsersSubscription;
  List<StreamSubscription<QuerySnapshot>> _chatSubscriptions;
  StreamSubscription<QuerySnapshot> _waveSubscription;
  StreamSubscription<QuerySnapshot> _winkSubscription;
  StreamSubscription<QuerySnapshot> _interactionSubscription;

  // register a listener to process certain topic data
  void subscribe(
    JoltTopic topic,
    Function dataCallback,
    Map<String, String> arguments,
  ) {
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
      case JoltTopic.wave:
        {
          _waveSubscription = subscribeToWave(arguments, dataCallback);
        }
        break;
      case JoltTopic.wink:
        {
          _winkSubscription = subscribeToWink(arguments, dataCallback);
        }
        break;
      case JoltTopic.interactions:
        {
          _interactionSubscription =
              subscribeToInteractions(arguments, dataCallback);
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
        break;
      case JoltTopic.wave:
        {
          if (_waveSubscription != null) {
            _waveSubscription.cancel();
            _waveSubscription = null;
          }
        }
        break;
      case JoltTopic.wink:
        {
          if (_winkSubscription != null) {
            _winkSubscription.cancel();
            _winkSubscription = null;
          }
        }
        break;
      case JoltTopic.interactions:
        {
          if (_interactionSubscription != null) {
            _interactionSubscription.cancel();
            _interactionSubscription = null;
          }
        }
        break;
      default:
        {}
        break;
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
        'conversationIds': conversationIds,
      });
      return true;
    } catch (e) {
      print('Error: insertUser: ${e.message}');
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
              print('Added: subscribeToNearbyUsers: ${doc.documentID}');
            }
            break;
          case DocumentChangeType.removed:
            {
              nearbyUsers.remove(doc.documentID);
              print('Removed: subscribeToNearbyUsers: ${doc.documentID}');
            }
            break;
          case DocumentChangeType.modified:
            {
              if (user['location'] != myCurrentAddress) {
                nearbyUsers.remove(doc.documentID);
              }
              print('Modified: subscribeToNearbyUsers: ${doc.documentID}');
            }
            break;
          default:
            {
              print('Default: subscribeToNearbyUsers');
            }
            break;
        }
        callback(nearbyUsers);
      });
    });
  }

  // register a callback to listen to chat data
  List<StreamSubscription<QuerySnapshot>> subscribeToChats(
    Map<String, String> arguments,
    Function(JoltConversation) callback,
  ) {
    List<JoltConversation> myConversations = [];
    List<StreamSubscription<QuerySnapshot>> chatSubs = [];
    print("conversations: ${arguments['myConversations']}");
    if (arguments.containsKey('myConversations')) {
      // conversation ids will be supplied delimited by ';'
      myConversations = arguments['myConversations']
          .split(';')
          .map(
            (conversationId) => new JoltConversation(
              conversationId: conversationId,
              fromUser: null,
              messages: [],
            ),
          )
          .toList();

      myConversations
          .removeWhere((conversation) => conversation.conversationId.isEmpty);
    } else {
      throw Exception('Missing required myConversations parameter');
    }

    myConversations.forEach(
      (JoltConversation conversation) {
        var conversationStream = _databaseReference
            .collection('conversations')
            .document(conversation.conversationId)
            .collection('messages')
            .snapshots()
            .listen(
          (res) {
            res.documentChanges.forEach(
              (change) {
                switch (change.type) {
                  case DocumentChangeType.added:
                    {
                      conversation.addMessage(
                        change.document.data['text'],
                        change.document.data['sentBy'],
                        change.document.data['timestamp'],
                      );
                      print(
                        'Added: subscribeToChats: ${change.document.documentID}',
                      );
                    }
                    break;
                  case DocumentChangeType.removed:
                    {
                      print(
                        'Removed: subscribeToChats: ${change.document.documentID}',
                      );
                    }
                    break;
                  case DocumentChangeType.modified:
                    {
                      print(
                        'Modified: subscribeToChats: ${change.document.documentID}',
                      );
                    }
                    break;
                  default:
                    {
                      print('Default: subscribeToChats');
                    }
                    break;
                }
              },
            );
            callback(conversation);
          },
        );

        // Keep track of the stream subscriptions
        chatSubs.add(conversationStream);
      },
    );

    return chatSubs;
  }

  // listen for waves from other users
  StreamSubscription<QuerySnapshot> subscribeToWave(
    Map<String, String> arguments,
    Function(List<JoltNotification>) callback,
  ) {
    String userId;
    List<JoltNotification> waves = [];
    if (arguments.containsKey('userId')) {
      // conversation ids will be supplied delimited by ';'
      userId = arguments['userId'];
    } else {
      throw Exception('Missing required myConversations parameter');
    }

    return _databaseReference
        .collection('interactions/$userId/interactions')
        .snapshots()
        .listen((res) {
      res.documentChanges.forEach((change) async {
        if (change.document.data['interactionType'] == 'wave') {
          switch (change.type) {
            case DocumentChangeType.added:
              {
                waves.add(new JoltNotification(
                  fromUser:
                      await getUser(change.document.data['incomingUserId']),
                  type: NotificationType.wave,
                  timestamp: change.document.data['timestamp'],
                  acked: change.document.data['acked'],
                ));
                print(
                  'Added: subscribeToWaves: ${change.document.documentID}',
                );
              }
              break;
            case DocumentChangeType.removed:
              {
                print(
                  'Removed: subscribeToWaves: ${change.document.documentID}',
                );
              }
              break;
            case DocumentChangeType.modified:
              {
                print(
                  'Modified: subscribeToWaves: ${change.document.documentID}',
                );
              }
              break;
            default:
              {
                print('Default: subscribeToWaves');
              }
              break;
          }
          callback(waves);
        }
      });
    });
  }

  // listen for winks from other users
  StreamSubscription<QuerySnapshot> subscribeToWink(
    Map<String, String> arguments,
    Function(List<JoltNotification>) callback,
  ) {
    String userId;
    List<JoltNotification> winks = [];
    if (arguments.containsKey('userId')) {
      // conversation ids will be supplied delimited by ';'
      userId = arguments['userId'];
    } else {
      throw Exception('Missing required myConversations parameter');
    }

    return _databaseReference
        .collection('interactions/$userId/interactions')
        .snapshots()
        .listen((res) {
      res.documentChanges.forEach((change) async {
        if (change.document.data['interactionType'] == 'wink') {
          switch (change.type) {
            case DocumentChangeType.added:
              {
                winks.add(new JoltNotification(
                  fromUser:
                      await getUser(change.document.data['incomingUserId']),
                  type: NotificationType.wink,
                  timestamp: change.document.data['timestamp'],
                  acked: change.document.data['acked'],
                ));
                print(
                  'Added: subscribeToWink: ${change.document.documentID}',
                );
              }
              break;
            case DocumentChangeType.removed:
              {
                print(
                  'Removed: subscribeToWink: ${change.document.documentID}',
                );
              }
              break;
            case DocumentChangeType.modified:
              {
                print(
                  'Modified: subscribeToWink: ${change.document.documentID}',
                );
              }
              break;
            default:
              {
                print('Default: subscribeToWink');
              }
              break;
          }
          callback(winks);
        }
      });
    });
  }

  // listen for waves and winks from other users
  StreamSubscription<QuerySnapshot> subscribeToInteractions(
    Map<String, String> arguments,
    Function(List<JoltNotification>) callback,
  ) {
    String userId;
    List<JoltNotification> interactions = [];
    if (arguments.containsKey('userId')) {
      // conversation ids will be supplied delimited by ';'
      userId = arguments['userId'];
    } else {
      throw Exception('Missing required myConversations parameter');
    }

    return _databaseReference
        .collection('interactions/$userId/interactions')
        .snapshots()
        .listen(
      (res) {
        res.documentChanges.forEach(
          (change) async {
            switch (change.type) {
              case DocumentChangeType.added:
                {
                  // do some data validation here
                  interactions.add(
                    new JoltNotification(
                      fromUser: await getUser(
                        change.document.data['incomingUserId'],
                      ),
                      type: JoltNotification.getTypeFromString(
                        change.document.data['interactionType'],
                      ),
                      timestamp: change.document.data['timestamp'],
                      acked: change.document.data['acked'],
                    ),
                  );
                  print(
                    'Added: subscribeToInteractions: ${change.document.documentID}',
                  );
                }
                break;
              case DocumentChangeType.removed:
                {
                  print(
                    'Removed: subscribeToInteractions: ${change.document.documentID}',
                  );
                }
                break;
              case DocumentChangeType.modified:
                {
                  print(
                    'Modified: subscribeToInteractions: ${change.document.documentID}',
                  );
                }
                break;
              default:
                {
                  print('Default: subscribeToInteractions');
                }
                break;
            }
            callback(interactions);
          },
        );
      },
    );
  }

  // send a wave to another user
  Future<bool> wave(
    String idSource,
    String idTarget,
  ) async {
    try {
      var waveColl =
          _databaseReference.collection('interactions/$idTarget/interactions');
      await waveColl.add(
        {
          'incomingUserId': idSource,
          'timestamp': new DateTime.now().toString(),
          'interactionType': 'wave',
        },
      );
      return true;
    } catch (e) {
      print('Error: wave: ${e.message}');
      return false;
    }
  }

  Future<User> getUser(
    String userId,
  ) async {
    User currUser;
    try {
      DocumentSnapshot doc = await _databaseReference
          .document(
            'users/$userId',
          )
          .get();
      var user = doc.data;
      currUser = new User(
        name: user['name'],
        email: user['email'],
        phoneNumber: user['phoneNumber'],
        birthDate: user['birthDate'],
        userId: doc.documentID,
        gender: user['gender'],
        pictureUrl: user['pictureUrl'],
        location: user['location'],
        conversations: List<String>.from(user['conversationIds']),
      );
    } catch (e) {
      currUser = null;
      print('Error: getUser: ${e.message}');
    }

    return currUser;
  }

  // send a wink to another user
  Future<bool> wink(
    String idSource,
    String idTarget,
  ) async {
    try {
      var interactionsColl =
          _databaseReference.collection('interactions/$idTarget/interactions');
      await interactionsColl.add(
        {
          'incomingUserId': idSource,
          'timestamp': new DateTime.now().toString(),
          'interactionType': 'wink',
        },
      );
      return true;
    } catch (e) {
      print('Error: wink: ${e.message}');
      return false;
    }
  }

  // send a text message to another user
  Future<bool> sendMessage(
    String idSource,
    String idTarget,
    String text,
  ) async {
    try {
      String conversationId;

      if (idSource.compareTo(idTarget) < 0) {
        conversationId = '$idSource+$idTarget';
      } else {
        conversationId = '$idTarget+$idSource';
      }

      await addConversationId(idSource, conversationId);
      await addConversationId(idTarget, conversationId);

      var messagesColl = _databaseReference
          .collection('conversations/$conversationId/messages');
      await messagesColl.add(
        {
          'sentBy': idSource,
          'timestamp': new DateTime.now().toString(),
          'text': text,
        },
      );
      return true;
    } catch (e) {
      print('Error: wink: ${e.message}');
      return false;
    }
  }

  // adds a conversation id to be tracked by a user
  Future<bool> addConversationId(
    String userId,
    String conversationId,
  ) async {
    try {
      await _databaseReference.collection('users').document(userId).updateData(
        {
          'conversationIds': FieldValue.arrayUnion(
            [
              conversationId,
            ],
          ),
        },
      );
      return true;
    } catch (e) {
      print('Error: addConversationId: ${e.message}');
      return false;
    }
  }

  // update a users address, returns true if it works
  Future<bool> updateUserAddress({
    @required String userId,
    Function(String) callback,
  }) async {
    String newAddress = await _getAddressFromLatLng();
    try {
      await _databaseReference.collection('users').document(userId).updateData(
        {
          'location': newAddress,
        },
      );

      callback(newAddress);
      return true;
    } catch (e) {
      print('Error: updateUserAddress: ${e.message}');
      callback('error');
      return false;
    }
  }

  // Probably want to move the location stuff to the back end at some point
  Future<Position> _getCurrentLocation() async {
    return await geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  Future<String> _getAddressFromLatLng() async {
    try {
      Position currentPosition = await _getCurrentLocation();
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

      String address =
          '${place.subThoroughfare} ${place.thoroughfare}, ${place.locality}, ${place.administrativeArea}';
      return address;
    } catch (e) {
      print('Error: _getAddressFromLatLng: ${e.message}');
      return null;
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
  static User from(User old) {
    return new User(
      birthDate: old?.birthDate,
      phoneNumber: old?.phoneNumber,
      email: old?.email,
      gender: old?.gender,
      name: old?.name,
      userId: old?.userId,
      pictureUrl: old?.pictureUrl,
      location: old?.location,
      conversations: List<String>.from(
        old != null ? old.conversations : [],
      ),
    );
  }

  User({
    @required this.name,
    @required this.phoneNumber,
    @required this.email,
    @required this.gender,
    @required this.birthDate,
    @required this.userId,
    @required this.pictureUrl,
    @required this.location,
    this.conversations,
  }) {
    if (this.conversations == null) {
      this.conversations = [];
    }
  }
}

enum JoltTopic {
  nearbyUsers,
  chats,
  wave,
  wink,
  interactions,
}

class JoltNotification {
  final User fromUser;
  final NotificationType type;
  bool acked;
  final String timestamp;

  static NotificationType getTypeFromString(String typeString) {
    NotificationType type;
    if (typeString == 'wave') {
      type = NotificationType.wave;
    } else if (typeString == 'wink') {
      type = NotificationType.wink;
    } else if (typeString == 'text') {
      type = NotificationType.text;
    } else {
      type = NotificationType.unknown;
    }
    return type;
  }

  static String getStringFromType(NotificationType type) {
    String typeString = '';

    switch (type) {
      case NotificationType.wave:
        typeString = 'wave';
        break;
      case NotificationType.wink:
        typeString = 'wink';
        break;
      case NotificationType.text:
        typeString = 'text';
        break;
      case NotificationType.unknown:
      default:
        typeString = 'unknown';
        break;
    }

    return typeString;
  }

  // Compare function for sorting
  static int compare(JoltNotification a, JoltNotification b) {
    var timeA = DateTime.parse(a.timestamp);
    var timeB = DateTime.parse(b.timestamp);
    if (timeA.difference(timeB).inMilliseconds < 0) {
      return 1;
    } else {
      return -1;
    }
  }

  JoltNotification({
    @required this.fromUser,
    @required this.type,
    @required this.timestamp,
    @required this.acked,
  });
}

class JoltConversation {
  final String conversationId;
  User fromUser;
  List<JoltTextMessage> messages;

  static JoltConversation from(JoltConversation old) {
    return new JoltConversation(
      conversationId: old?.conversationId,
      fromUser: User.from(old?.fromUser),
      messages: List<JoltTextMessage>.from(
        old != null ? old.messages : [],
      ),
    );
  }

  void addMessage(
    String text,
    String sentBy,
    String timestamp,
  ) {
    messages.add(
      new JoltTextMessage(
        text: text,
        timestamp: timestamp,
        sentBy: sentBy,
      ),
    );
  }

  JoltConversation({
    @required this.conversationId,
    @required this.messages,
    this.fromUser,
  });
}

class JoltTextMessage {
  final String text;
  final String timestamp;
  final String sentBy;

  // Compare function for sorting
  static int compare(JoltTextMessage a, JoltTextMessage b) {
    if (a.timestamp == null ||
        b.timestamp == null ||
        a.timestamp.isEmpty ||
        b.timestamp.isEmpty) {
      return 1;
    }
    var timeA = DateTime.parse(a.timestamp);
    var timeB = DateTime.parse(b.timestamp);
    if (timeA.difference(timeB).inMilliseconds < 0) {
      return 1;
    } else {
      return -1;
    }
  }

  static JoltTextMessage from(JoltTextMessage old) {
    return new JoltTextMessage(
      text: old?.text,
      timestamp: old?.timestamp,
      sentBy: old?.sentBy,
    );
  }

  JoltTextMessage({
    @required this.text,
    @required this.timestamp,
    @required this.sentBy,
  });
}

enum NotificationType {
  wave,
  wink,
  text,
  unknown,
}
