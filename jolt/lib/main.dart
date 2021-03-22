import 'package:flutter/material.dart';
import 'package:jolt/models/messages_model.dart';
import 'package:jolt/services/database_service.dart';
import 'package:jolt/views/active_chat_screen/active_chat_screen.dart';
import 'package:jolt/views/jolter_selected_screen/jolter_selected_screen.dart';
import 'package:jolt/views/messages_screen/messages_screen.dart';
import 'package:jolt/views/received_interaction_screen/received_interaction_screen.dart';
import 'package:provider/provider.dart';

import 'package:jolt/views/discovery_screen/discovery_feed.dart';
import 'package:jolt/views/notifications_screen/notifications_screen.dart';
import 'package:jolt/views/authentication_screen/login_signup_root.dart';
import 'package:jolt/models/authentication_model.dart';
import 'package:jolt/models/interactions_model.dart';
import 'package:jolt/models/nearby_users_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NearbyUsersModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => InteractionsModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthenticationModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MessagesModel(),
        ),
      ],
      child: MaterialApp(
        home: LoginSignupRoot(),
        onGenerateRoute: (settings) {
          final Arguments args = settings.arguments;

          switch (settings.name) {
            case NotificationsScreen.routeName:
              {
                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) {
                    return NotificationsScreen();
                  },
                );
              }
              break;
            case DiscoveryFeed.routeName:
              {
                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) {
                    return DiscoveryFeed();
                  },
                );
              }
              break;
            case LoginSignupRoot.routeName:
              {
                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) {
                    return LoginSignupRoot();
                  },
                );
              }
              break;
            case JolterSelectedScreen.routeName:
              {
                return MaterialPageRoute(
                  builder: (context) {
                    return JolterSelectedScreen(
                      selectedUser: args.selectedUser,
                    );
                  },
                );
              }
              break;
            case ReceivedInteractionScreen.routeName:
              {
                return MaterialPageRoute(
                  builder: (context) {
                    return ReceivedInteractionScreen(
                      notification: args.notification,
                    );
                  },
                );
              }
              break;
            case MessagesScreen.routeName:
              {
                return MaterialPageRoute(
                  builder: (context) {
                    return MessagesScreen();
                  },
                );
              }
              break;
            case ActiveChatScreen.routeName:
              {
                return MaterialPageRoute(
                  builder: (context) {
                    return ActiveChatScreen(
                      conversation: args.conversation,
                    );
                  },
                );
              }
              break;
            default:
              {
                return MaterialPageRoute(
                  builder: (context) {
                    return LoginSignupRoot();
                  },
                );
              }
              break;
          }
        },
      ),
    );
  }
}

class Arguments {
  final User selectedUser;
  final JoltNotification notification;
  final JoltConversation conversation;

  Arguments({
    this.selectedUser,
    this.notification,
    this.conversation,
  });
}
