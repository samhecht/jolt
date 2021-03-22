import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:jolt/services/database_service.dart';

// This class notifies widgets when the nearby users change
class NearbyUsersModel extends ChangeNotifier {
  List<User> _nearbyUsers = [];
  String _userId = '';
  Timer refreshTimer;

  // Get nearby users
  UnmodifiableListView<User> get nearbyUsers =>
      UnmodifiableListView(_nearbyUsers);

  // Set the userId
  set userId(String userId) {
    _userId = userId;
    // Setup initially
    refreshListener();

    // Refresh every minute in case our location changes
    refreshTimer = Timer.periodic(
      Duration(minutes: 1),
      (Timer timer) {
        refreshListener();
      },
    );
  }

  void unsubscribe() {
    DatabaseService().unsubscribe(JoltTopic.nearbyUsers);
  }

  // Constructor and start listener for neighbors
  NearbyUsersModel();

  // Update list and notify widgets
  void updateNearbyUsers(Map<String, User> users) {
    _nearbyUsers = users.entries.map((user) => user.value).toList();
    notifyListeners();
  }

  // Logic to update address and start listening for nearby users
  void refreshListener() {
    DatabaseService().unsubscribe(JoltTopic.nearbyUsers);
    DatabaseService().updateUserAddress(
      userId: _userId,
      callback: (address) {
        DatabaseService().subscribe(
          JoltTopic.nearbyUsers,
          updateNearbyUsers,
          {'myCurrentAddress': address},
        );
      },
    );
  }

  @override
  void dispose() {
    refreshTimer.cancel();
    DatabaseService().unsubscribe(JoltTopic.nearbyUsers);
    super.dispose();
  }
}
