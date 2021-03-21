part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState([Object list]);

  @override
  List<Object> get props => [];
}

class Idle extends HomeState {}

class SearchingUsers extends HomeState {}

class DisplayingUsers extends HomeState {
  final List<String> usernames;

  DisplayingUsers(this.usernames) : super([usernames]);
}
