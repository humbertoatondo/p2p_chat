part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent([Object list]);

  @override
  List<Object> get props => [];
}

class SearchInputChanged extends HomeEvent {
  final String username;

  SearchInputChanged(this.username) : super([username]);
}
