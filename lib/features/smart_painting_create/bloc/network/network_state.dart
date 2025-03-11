part of 'network_bloc.dart';

abstract class NetworkState extends Equatable {
  const NetworkState();

  @override
  List<Object> get props => [];
}

class NetworkInitial extends NetworkState {}

class NetworkConnected extends NetworkState {
  final List<ConnectivityResult> connectionStatus;

  const NetworkConnected(this.connectionStatus);

  @override
  List<Object> get props => [connectionStatus];
}

class NetworkDisconnected extends NetworkState {}
