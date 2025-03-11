part of 'network_bloc.dart';

abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object> get props => [];
}

class CheckConnection extends NetworkEvent {}

class ConnectionChanged extends NetworkEvent {
  final List<ConnectivityResult> status;

  const ConnectionChanged(this.status);

  @override
  List<Object> get props => [status];
}
