import 'dart:collection';

import 'package:flutter/material.dart';

import '../database_service.dart';

class InteractionsModel extends ChangeNotifier {
  List<JoltNotification> _interactions = [];
  int _quantityReturned = 20;
  String _userId;

  InteractionsModel();

  set userId(String userId) {
    _userId = userId;
    // Subscribe for interactions
    DatabaseService().subscribe(
      JoltTopic.interactions,
      updateInteractions,
      {
        'userId': _userId,
      },
    );
  }

  void unsubscribe() {
    DatabaseService().unsubscribe(JoltTopic.interactions);
  }

  UnmodifiableListView<JoltNotification> get interactions =>
      UnmodifiableListView(_interactions);

  get quantityReturned => _quantityReturned;
  set quanitityReturned(int quantity) {
    _quantityReturned = quantity;
  }

  void updateInteractions(List<JoltNotification> interactions) {
    interactions.sort(JoltNotification.compare);

    // Don't want to load tons of old notifications
    if (_quantityReturned < interactions.length) {
      _interactions = interactions.sublist(0, _quantityReturned);
    } else {
      _interactions = interactions;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    DatabaseService().unsubscribe(JoltTopic.interactions);
    super.dispose();
  }
}
