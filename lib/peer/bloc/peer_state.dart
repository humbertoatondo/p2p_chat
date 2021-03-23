part of 'peer_bloc.dart';

abstract class PeerState extends Equatable {
  const PeerState();

  @override
  List<Object> get props => [];
}

class PeersInitial extends PeerState {}
