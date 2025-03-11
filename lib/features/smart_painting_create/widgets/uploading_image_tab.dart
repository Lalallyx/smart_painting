import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart'; // Импортируем image_picker
import 'package:smart_painting/features/smart_painting_create/bloc/network/network_bloc.dart';
import 'package:smart_painting/repositories/mqtt_manager.dart';
import 'package:smart_painting/ui/colors/colors.dart';

class UploadingImageTab extends StatefulWidget {
  const UploadingImageTab({super.key});

  @override
  State<UploadingImageTab> createState() => _UploadingImageTabState();
}

class _UploadingImageTabState extends State<UploadingImageTab> {
  File? _image;
  bool _isLoading = false;
  bool _isImageLoading = false;

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isImageLoading = true;
      });

      final image = Image.file(_image!);
      image.image.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener(
              (info, _) {
                setState(() {
                  _isImageLoading = false;
                });
              },
              onError: (_, __) {
                setState(() {
                  _isImageLoading = false;
                });
              },
            ),
          );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Ваши существующие круги и декор
        Positioned(
          top: 0,
          left: 0,
          child: Transform.translate(
            offset: Offset(-size.height * 0.125, -size.height * 0.125),
            child: Container(
              height: (size.height * 0.25).clamp(100, 1200),
              width: (size.height * 0.25).clamp(250, 1200),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.uploading,
              ),
            ),
          ),
        ),
        // Правый верхний угол
        Positioned(
          top: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(size.height * 0.125, -size.height * 0.125),
            child: Container(
              height: (size.height * 0.25).clamp(100, 1200),
              width: (size.height * 0.25).clamp(250, 1200),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.uploading,
              ),
            ),
          ),
        ),
        // Левый нижний угол
        Positioned(
          bottom: 0,
          left: 0,
          child: Transform.translate(
            offset: Offset(-size.height * 0.125, size.height * 0.125),
            child: Container(
              height: (size.height * 0.25).clamp(100, 1200),
              width: (size.height * 0.25).clamp(250, 1200),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.uploading,
              ),
            ),
          ),
        ),
        // Правый нижний угол
        Positioned(
          bottom: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(size.height * 0.125, size.height * 0.125),
            child: Container(
              height: (size.height * 0.25).clamp(100, 1200),
              width: (size.height * 0.25).clamp(250, 1200),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.uploading,
              ),
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 300.0, sigmaY: 300.0),
          child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
          ),
        ),
        Center(
          child: Column(
            children: [
              Text(
                'Своя загрузка',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              BlocBuilder<NetworkBloc, NetworkState>(
                builder: (context, state) {
                  final isConnected = state is NetworkConnected;
                  return Text(
                    isConnected
                        ? 'Подключено к сети'
                        : 'Нет подключения к сети',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isConnected
                          ? AppColors.connected
                          : AppColors.disconnected,
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(180), // Цвет тени
                          offset: Offset(2, 2), // Смещение тени по X и Y
                          blurRadius: 4, // Радиус размытия
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // Центральная часть с изображением и кнопкой

        Padding(
          padding: const EdgeInsets.only(bottom: 1.2 * kToolbarHeight),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Отображение выбранного изображения или индикатора загрузки
                if (_isLoading || _isImageLoading)
                  CircularProgressIndicator(
                    color: AppColors.onPrimary,
                  )
                else if (_image != null)
                  Container(
                    width: MediaQuery.of(context).size.height * 0.4,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Text(
                    'Изображение не выбрано',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: 25),
                // Ряд с кнопкой выбора изображения и круглой кнопкой загрузки
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_image != null && !_isLoading && !_isImageLoading)
                        FloatingActionButton(
                          onPressed: () {},
                          backgroundColor:
                              const Color.fromARGB(47, 111, 4, 234),
                          shape: CircleBorder(),
                          child: const Icon(
                            Icons.edit_outlined,
                            color: AppColors.uploading,
                          ),
                        ),
                      Spacer(),
                      // Кнопка для выбора изображения
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.uploading,
                              AppColors.imageInfo,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            minimumSize: Size(200, 55),
                          ),
                          child: Text(
                            'Выбрать изображение',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ),
                      Spacer(),
                      // Круглая кнопка загрузки (появляется только после выбора изображения и не во время загрузки)
                      if (_image != null && !_isLoading && !_isImageLoading)
                        FloatingActionButton(
                          onPressed: () async {
                            if (_image != null) {
                              setState(() {
                                _isLoading = true;
                              });

                              final mqttClient = GetIt.I<MQTTManager>();
                              await mqttClient
                                  .connect(); // Дождитесь подключения
                              mqttClient.subscribe(
                                  'uploading_image/topic'); // Подписка на топик

                              // Убедитесь, что подключение и подписка завершены
                              if (MQTTManager.connectionState ==
                                      MqttCurrentConnectionState.CONNECTED &&
                                  mqttClient.subscriptionState ==
                                      MqttSubscriptionState.SUBSCRIBED) {
                                mqttClient.publishImage(
                                    'uploading_image/topic', _image!);
                              } else {
                                log('Connection or subscription failed');
                              }

                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          backgroundColor:
                              const Color.fromARGB(47, 111, 4, 234),
                          shape: CircleBorder(),
                          child: const Icon(
                            Icons.upload_outlined,
                            color: AppColors.uploading,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
