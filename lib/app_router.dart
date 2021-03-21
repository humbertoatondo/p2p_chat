import 'package:communication_repository/communication_repository.dart';
import 'package:flutter/material.dart';
import 'package:p2p_chat/chat/chat.dart';
import 'package:p2p_chat/home/home.dart';
import 'package:p2p_chat/login/login.dart';

class AppRouter {
  Route<dynamic> generateRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (context) => HomePage(
            communicationRepository: CommunicationRepository(),
          ),
        );
      case '/chat':
        return MaterialPageRoute(
          builder: (context) => ChatPage(
            endUsername: args,
          ),
        );
    }
  }
}
