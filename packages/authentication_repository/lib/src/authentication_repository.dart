import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

abstract class AuthenticationStatus extends Equatable {
  const AuthenticationStatus();

  @override
  List<Object> get props => [];
}

class Unknown extends AuthenticationStatus {}

class Authenticated extends AuthenticationStatus {
  final String uuid;
  final String username;

  Authenticated(this.uuid, this.username);

  @override
  List<Object> get props => [uuid, username];
}

class Unauthenticated extends AuthenticationStatus {}

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  final String _host = "192.168.1.89";
  final String _port = "3000";
  final String _path = "/user/login";

  Stream<AuthenticationStatus> get status async* {
    yield Unauthenticated();
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

    if (response.statusCode == HttpStatus.ok) {
      _controller.add(Authenticated(Uuid().v4(), username));
    }
  }

  void logOut() {
    _controller.add(Unauthenticated());
  }

  void dispose() => _controller.close();
}
