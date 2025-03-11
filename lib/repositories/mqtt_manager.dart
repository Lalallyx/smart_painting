// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer'; // Добавляем для использования log
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

enum MqttSubscriptionState {
  IDLE,
  SUBSCRIBED,
}

class MQTTManager {
  late MqttServerClient _client;

  static MqttCurrentConnectionState connectionState =
      MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  final String _broker;
  final String _clientId;
  final int _port;
  final String _username;
  final String _password;

  MQTTManager({
    required String broker,
    required String clientId,
    required int port,
    required String username,
    required String password,
  })  : _broker = broker,
        _clientId = clientId,
        _port = port,
        _username = username,
        _password = password;

  Future<void> connect() async {
    _setupMqttClient();
    await _connectClient();
  }

  void disconnect() {
    _client.disconnect();
  }

  void subscribe(String topicName) {
    _subscribeToTopic(topicName);
  }

  void publish(String topicName, String message) {
    _publishMessage(topicName, message);
  }

  Future<void> _connectClient() async {
    try {
      log('Connecting to $_broker...');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await _client.connect(_username, _password);
    } on Exception catch (e) {
      log('Exception: $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      _client.disconnect();
    }

    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      log('Connected to $_broker');
    } else {
      log('Connection failed - disconnecting');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      _client.disconnect();
    }
  }

  void _setupMqttClient() {
    _client = MqttServerClient.withPort(_broker, _clientId, _port);
    _client.secure = true;
    _client.securityContext = SecurityContext.defaultContext;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;
  }

  void _subscribeToTopic(String topicName) {
    log('Subscribing to $topicName');
    _client.subscribe(topicName, MqttQos.atMostOnce);

    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      var message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      log('Received message: $message');
    });
  }

  void _publishMessage(String topicName, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    final Uint8List encodedMessage =
        utf8.encode(message); // Кодируем строку в UTF-8

    // Добавляем байтовый массив в payload
    builder.payload?.addAll(encodedMessage);

    if (builder.payload != null) {
      log('Publishing message "$message" to topic $topicName');
      _client.publishMessage(topicName, MqttQos.exactlyOnce, builder.payload!);
    } else {
      log('Payload is null, cannot publish message');
    }
  }

  void publishImage(String topicName, File imageFile) async {
    try {
      // Сжимаем изображение с указанием ширины и высоты
      final compressedImageFile = await compressImage(
        imageFile,
        maxWidth: 800, // Максимальная ширина
        maxHeight: 480, // Максимальная высота
        quality: 50, // Качество сжатия
      );

      // Читаем сжатое изображение как байты
      final bytes = await compressedImageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Формируем JSON-сообщение
      final message = jsonEncode({
        'image': base64Image,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Публикуем сообщение
      publish(topicName, message);

      // Удаляем временный файл после отправки
      await compressedImageFile.delete();
    } catch (e) {
      log('Ошибка при сжатии или отправке изображения: $e');
    }
  }

  Future<File> compressImage(
    File imageFile, {
    int? maxWidth, // Максимальная ширина (опционально)
    int? maxHeight, // Максимальная высота (опционально)
    int quality = 85, // Качество сжатия (от 0 до 100)
  }) async {
    // Читаем изображение из файла
    final image = decodeImage(await imageFile.readAsBytes());
    if (image == null) {
      throw Exception('Не удалось декодировать изображение');
    }

    // Изменяем размер изображения с учетом пропорций
    final resizedImage = copyResize(
      image,
      width: maxWidth, // Новая ширина (если указана)
      height: maxHeight, // Новая высота (если указана)
    );

    // Кодируем изображение в формате JPEG с указанным качеством
    final compressedImageBytes = encodeJpg(resizedImage, quality: quality);

    // Сохраняем сжатое изображение во временный файл
    final compressedFile = File('${imageFile.path}_compressed.jpg');
    await compressedFile.writeAsBytes(compressedImageBytes);

    return compressedFile;
  }

  void _onSubscribed(String topic) {
    log('Subscribed to $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    log('Disconnected');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    log('Connected');
    connectionState = MqttCurrentConnectionState.CONNECTED;
  }
}
