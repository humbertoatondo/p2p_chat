import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

enum AuthenticationStatus {
  unkown,
  authenticated,
  unauthenticated,
}

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  final String _host = "192.168.1.89";
  final String _port = "3000";
  final String _path = "/user/login";

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> login({
    @required username,
    @required password,
  }) async {
    final body = json.encode({
      'username': username,
      'password': password,
    });

    final url = Uri.parse("http://$_host:$_port$_path");
    final response = await http.post(url, body: body);

    if (response.statusCode == HttpStatus.OK) {
      _controller.add(AuthenticationStatus.authenticated);
    }
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
