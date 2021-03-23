import 'package:communication_repository/communication_repository.dart';
import 'package:flutter/material.dart';
import 'package:p2p_chat/chat/chat.dart';
import 'package:p2p_chat/home/home.dart';
import 'package:p2p_chat/login/login.dart';
import 'package:peer_repository/peer_repository.dart';

class AppRouter {
  CommunicationRepository _communicationRepository;
  PeerRepository _peerRepository;

  Route<dynamic> generateRoutes(RouteSettings settings) {
    final args = settings.arguments;

    if (_communicationRepository == null) {
      _communicationRepository = CommunicationRepository();
    }
    if (_peerRepository == null) {
      _peerRepository = PeerRepository();
    }

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
      case '/home':
        // if (_communicationRepository == null) {
        //   _communicationRepository = CommunicationRepository();
        //   _peerRepository = PeerRepository();
        // }
        return MaterialPageRoute(
          builder: (context) => HomePage(
            communicationRepository: _communicationRepository,
            peerRepository: _peerRepository,
          ),
        );
      case '/chat':
        return MaterialPageRoute(
          builder: (context) => ChatPage(
            endUsername: args,
            peerRepository: _peerRepository,
          ),
        );
    }
  }
}
