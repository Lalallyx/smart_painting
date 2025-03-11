import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_painting/repositories/mqtt_manager.dart';
import 'package:smart_painting/smart_painting_app.dart';
import 'features/smart_painting_create/bloc/network/network_bloc.dart'; // Импортируйте NetworkBloc

void main() {
  // Регистрация MQTTManager в GetIt
  GetIt.I.registerLazySingleton(
    () => MQTTManager(
      broker: '8a181425a37940ad9cdf6859b8987e3a.s1.eu.hivemq.cloud',
      clientId: 'flutter_client',
      port: 8883,
      username: 'hivemq.webclient.1738675301450',
      password: '0h7jBQi;8ycW!.f4*KIA',
    ),
  );

  runApp(
    // Добавьте BlocProvider для NetworkBloc
    BlocProvider(
      create: (context) => NetworkBloc()..add(CheckConnection()),
      child: const SmartPainting(),
    ),
  );
}
