part of 'communication_bloc.dart';

abstract class CommunicationState extends Equatable {
  const CommunicationState();
  
  @override
  List<Object> get props => [];
}

class CommunicationInitial extends CommunicationState {}
