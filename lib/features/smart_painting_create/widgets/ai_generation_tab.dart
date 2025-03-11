import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_painting/features/smart_painting_create/bloc/ai_generation_tab/ai_generation_tab_bloc.dart';
import 'package:smart_painting/features/smart_painting_create/bloc/network/network_bloc.dart';
import 'package:smart_painting/features/smart_painting_create/widgets/widgets.dart';
import 'package:smart_painting/ui/colors/colors.dart';
import 'package:smart_painting/utils/utils.dart';

class AIGenerationTab extends StatefulWidget {
  const AIGenerationTab({super.key});

  @override
  State<AIGenerationTab> createState() => _AIGenerationTabState();
}

class _AIGenerationTabState extends State<AIGenerationTab> {
  @override
  void initState() {
    super.initState();
  }

  String dropDownValue = "Свой стиль";
  TextEditingController requestTextController = TextEditingController();
  TextEditingController exclusionTextController = TextEditingController();
  String statusText = "Ожидание";

  void _selectTime(BuildContext context) async {
    final bloc = context.read<AiGenerationTabBloc>();
    final currentState = bloc.state as SmartPaintingUpdatedState;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CustomTimePickerDialog(
        initialTime: currentState.selectedTime ?? TimeOfDay.now(),
        initialSecond: currentState.selectedSecond,
        bloc: bloc,
      ),
    );

    if (result != null) {
      bloc.add(TimeSelectedEvent(result['time'], result['second']));
    }
  }

  void _showTextInputDialog(
    BuildContext context,
    String title,
    String hintText,
    TextEditingController controller,
    Function(String) onSave,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.createScreenWindows.withAlpha(245),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth:
                  (MediaQuery.of(context).size.width * 0.7).clamp(200.0, 500.0),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    filled: true,
                    fillColor: const Color.fromARGB(180, 255, 255, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: AppColors.onPrimaryInverse),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Отмена',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        onSave(controller.text);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'ОК',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => AiGenerationTabBloc(),
      child: Scaffold(
        body: Stack(
          children: [
            // Фоновые круги
            Stack(
              children: [
                // Левый верхний круг
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
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
                // Правый верхний круг
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
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
                // Левый нижний круг
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
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
                // Правый нижний круг
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
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
                // Размытый фон
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 300.0, sigmaY: 300.0),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                  ),
                ),
              ],
            ),
            // Основной контент
            Column(
              children: [
                // Заголовок
                Column(
                  children: [
                    Text(
                      'Генерация с ИИ',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    BlocBuilder<NetworkBloc, NetworkState>(
                      builder: (context, state) {
                        final isConnected = state is NetworkConnected;
                        return Text(
                          isConnected
                              ? 'Подключено к сети'
                              : 'Нет подключения к сети',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
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
                // Основной интерфейс
                BlocBuilder<AiGenerationTabBloc, AiGenerationTabBlocState>(
                  builder: (context, state) {
                    final bloc = context.read<AiGenerationTabBloc>();
                    final currentState = state as SmartPaintingUpdatedState;

                    return Padding(
                      padding: EdgeInsets.only(top: size.height * 0.03),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: (size.width * 0.8).clamp(200, 800),
                          height: size.height * 0.6,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'Генерация',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.onPrimary.withAlpha(51),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Стиль',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: currentState.style.isNotEmpty
                                              ? currentState.style
                                              : dropDownValue,
                                          dropdownColor: AppColors
                                              .createScreenWindows
                                              .withAlpha(245),
                                          menuMaxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: AppColors.onPrimary),
                                          iconSize: 20,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                          alignment: Alignment.centerRight,
                                          items: const [
                                            DropdownMenuItem(
                                              value: "Свой стиль",
                                              child: Text('Свой стиль'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Детальное фото",
                                              child: Text('Детальное фото'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Малевич",
                                              child: Text('Малевич'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Студийное фото",
                                              child: Text('Студийное фото'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Киберпанк",
                                              child: Text('Киберпанк'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Айвазовский",
                                              child: Text('Айвазовский'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Картина маслом",
                                              child: Text('Картина маслом'),
                                            ),
                                            DropdownMenuItem(
                                              value: "3D рендер",
                                              child: Text('3D рендер'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Портретное фото",
                                              child: Text('Портретное фото'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Цифровая живопись",
                                              child: Text('Цифровая живопись'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Мультфильм",
                                              child: Text('Мультфильм'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Рисунок карандашом",
                                              child: Text('Рисунок карандашом'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Классицизм",
                                              child: Text('Классицизм'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Хохлома",
                                              child: Text('Хохлома'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Гикассо",
                                              child: Text('Гикассо'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Гиксель арт",
                                              child: Text('Гиксель арт'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Кандинский",
                                              child: Text('Кандинский'),
                                            ),
                                            DropdownMenuItem(
                                              value: "Аниме",
                                              child: Text('Аниме'),
                                            ),
                                          ],
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropDownValue = newValue!;
                                            });
                                            bloc.add(
                                                StyleChangedEvent(newValue!));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.onPrimary.withAlpha(51),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Запрос',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                      ),
                                      if (currentState.requestText.isNotEmpty)
                                        Expanded(
                                          flex: 3,
                                          child: GestureDetector(
                                            onTap: () {
                                              requestTextController.text =
                                                  currentState.requestText;
                                              _showTextInputDialog(
                                                context,
                                                'Введите запрос',
                                                'Запрос...',
                                                requestTextController,
                                                (text) {
                                                  bloc.add(
                                                      RequestTextChangedEvent(
                                                          text));
                                                },
                                              );
                                            },
                                            child: Text(
                                              currentState.requestText,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        )
                                      else
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.more_horiz,
                                              color: AppColors.onPrimary),
                                          iconSize: 30,
                                          onPressed: () {
                                            _showTextInputDialog(
                                              context,
                                              'Введите запрос',
                                              'Запрос...',
                                              requestTextController,
                                              (text) {
                                                bloc.add(
                                                    RequestTextChangedEvent(
                                                        text));
                                              },
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.onPrimary.withAlpha(51),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Исключить',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                      ),
                                      if (currentState.exclusionText.isNotEmpty)
                                        Expanded(
                                          flex: 3,
                                          child: GestureDetector(
                                            onTap: () {
                                              exclusionTextController.text =
                                                  currentState.exclusionText;
                                              _showTextInputDialog(
                                                context,
                                                'Введите исключение',
                                                'Исключить...',
                                                exclusionTextController,
                                                (text) {
                                                  bloc.add(
                                                      ExclusionTextChangedEvent(
                                                          text));
                                                },
                                              );
                                            },
                                            child: Text(
                                              currentState.exclusionText,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        )
                                      else
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.more_horiz,
                                              color: AppColors.onPrimary),
                                          iconSize: 30,
                                          onPressed: () {
                                            _showTextInputDialog(
                                              context,
                                              'Введите исключение',
                                              'Исключить...',
                                              exclusionTextController,
                                              (text) {
                                                bloc.add(
                                                    ExclusionTextChangedEvent(
                                                        text));
                                              },
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.onPrimary.withAlpha(51),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Статус',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Text(
                                        statusText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.secondary,
                                        AppColors.uploading,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      bloc.add(SendDataToServerEvent());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      minimumSize:
                                          const Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Сгенерировать',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'Автогенерация',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.onPrimary.withAlpha(51),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Включить',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Switch(
                                        value: currentState
                                            .isAutoGenerationEnabled,
                                        onChanged: (bool value) {
                                          bloc.add(
                                              AutoGenerationToggleEvent(value));
                                        },
                                        activeColor: AppColors.secondary,
                                        inactiveThumbColor:
                                            AppColors.onPrimaryMute,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.onPrimary.withAlpha(51),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Период',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      GestureDetector(
                                        onTap: () => _selectTime(context),
                                        child: Text(
                                          currentState.selectedTime == null
                                              ? 'Время не выбрано'
                                              : TimeUtils.formatTime(
                                                  currentState
                                                      .selectedTime!.hour,
                                                  currentState
                                                      .selectedTime!.minute,
                                                  currentState.selectedSecond,
                                                ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
