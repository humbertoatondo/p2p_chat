part of 'peer_bloc.dart';

abstract class PeerEvent extends Equatable {
  const PeerEvent();

  @override
  List<Object> get props => [];
}

class DataChannelEventOccurred extends PeerEvent {
  final DataChannelEvent dataChannelEvent;

  const DataChannelEventOccurred(this.dataChannelEvent);

  @override
  List<Object> get props => [dataChannelEvent];
}
