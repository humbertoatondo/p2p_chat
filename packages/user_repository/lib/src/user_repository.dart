import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  User? _user;

  Future<User?> getUser() async {
    if (_user != null) {
      return _user;
    }
    // TODO: Replace code below to create a new user.
    return Future<User?>.delayed(
      const Duration(milliseconds: 400),
      () => _user = User(
        Uuid().v4(),
      ),
    );
  }
}
