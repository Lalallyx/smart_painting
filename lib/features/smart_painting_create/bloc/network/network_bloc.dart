import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final Connectivity _connectivity = Connectivity();

  NetworkBloc() : super(NetworkInitial()) {
    on<CheckConnection>(_onCheckConnection);
    on<ConnectionChanged>(_onConnectionChanged);

    // Подписываемся на изменения состояния сети
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      add(ConnectionChanged(result));
    });
  }

  Future<void> _onCheckConnection(
    CheckConnection event,
    Emitter<NetworkState> emit,
  ) async {
    final result = await _connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      emit(NetworkDisconnected());
    } else {
      emit(NetworkConnected(result));
    }
  }

  void _onConnectionChanged(
    ConnectionChanged event,
    Emitter<NetworkState> emit,
  ) {
    final status = event.status;
    if (status.contains(ConnectivityResult.none)) {
      emit(NetworkDisconnected());
    } else {
      emit(NetworkConnected(status));
    }
  }
}
