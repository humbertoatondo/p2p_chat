part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState([Object list]);

  @override
  List<Object> get props => [];
}

class UnknownState extends AuthenticationState {
  const UnknownState();

  @override
  List<Object> get props => [];
}

class AuthenticatedState extends AuthenticationState {
  final User user;

  const AuthenticatedState(this.user);
}

class UnauthenticatedState extends AuthenticationState {
  const UnauthenticatedState();

  @override
  List<Object> get props => [];
}
