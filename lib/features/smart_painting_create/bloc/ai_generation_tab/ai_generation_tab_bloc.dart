import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_painting/repositories/mqtt_manager.dart';
import 'package:smart_painting/utils/utils.dart';

part 'ai_generation_tab_event.dart';
part 'ai_generation_tab_state.dart';

class AiGenerationTabBloc
    extends Bloc<AiGenerationTabBlocEvent, AiGenerationTabBlocState> {
  AiGenerationTabBloc()
      : super(const SmartPaintingUpdatedState(isInitial: true)) {
    on<StyleChangedEvent>((event, emit) {
      final currentState = state as SmartPaintingUpdatedState;
      emit(currentState.copyWith(style: event.style, isInitial: false));
    });

    on<RequestTextChangedEvent>((event, emit) {
      final currentState = state as SmartPaintingUpdatedState;
      emit(currentState.copyWith(
          requestText: event.requestText, isInitial: false));
    });

    on<ExclusionTextChangedEvent>((event, emit) {
      final currentState = state as SmartPaintingUpdatedState;
      emit(currentState.copyWith(
          exclusionText: event.exclusionText, isInitial: false));
    });

    on<AutoGenerationToggleEvent>((event, emit) {
      final currentState = state as SmartPaintingUpdatedState;
      emit(currentState.copyWith(
        isAutoGenerationEnabled: event.isAutoGenerationEnabled,
        isInitial: false,
      ));
    });

    on<TimeSelectedEvent>((event, emit) {
      final currentState = state as SmartPaintingUpdatedState;
      emit(currentState.copyWith(
        selectedTime: event.time,
        selectedSecond: event.second,
        isInitial: false,
      ));
    });

    on<SendDataToServerEvent>((event, emit) async {
      final currentState = state as SmartPaintingUpdatedState;
      final mqttClient = GetIt.I<MQTTManager>();
      await mqttClient.connect();
      mqttClient.subscribe('smart_painting/topic');

      // Формируем данные для отправки
      final data = {
        'style': currentState.style,
        'requestText': currentState.requestText,
        'exclusionText': currentState.exclusionText,
        'selectedTime': currentState.selectedTime != null
            ? TimeUtils.formatTime(
                currentState.selectedTime!.hour,
                currentState.selectedTime!.minute,
                currentState.selectedSecond,
              )
            : null,
        'isAutoGenerationEnabled': currentState.isAutoGenerationEnabled,
      };

      // Отправляем данные на сервер
      if (MQTTManager.connectionState == MqttCurrentConnectionState.CONNECTED &&
          mqttClient.subscriptionState == MqttSubscriptionState.SUBSCRIBED) {
        mqttClient.publish('smart_painting/topic', data.toString());
      } else {
        log('Нет подключения к брокеру');
      }
    });
  }
}
