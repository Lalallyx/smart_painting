import 'package:flutter/material.dart';
import 'package:smart_painting/features/smart_painting_create/bloc/ai_generation_tab/ai_generation_tab_bloc.dart';
import 'package:smart_painting/ui/colors/colors.dart';
// Импортируйте события

class CustomTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final int initialSecond;
  final AiGenerationTabBloc bloc; // Принимаем Bloc через конструктор

  const CustomTimePickerDialog({
    super.key,
    required this.initialTime,
    this.initialSecond = 0,
    required this.bloc, // Обязательный параметр
  });

  @override
  State<CustomTimePickerDialog> createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
  late int _selectedHour;
  late int _selectedMinute;
  late int _selectedSecond;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;
    _selectedSecond = widget.initialSecond;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.createScreenWindows.withAlpha(245),
      content: SizedBox(
        width: 270,
        height: 230,
        child: Column(
          children: [
            Text(
              'Выберите время',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDropdown(
                  _selectedHour,
                  0,
                  23,
                  (value) {
                    setState(() {
                      _selectedHour = value;
                    });
                  },
                  'Ч',
                ),
                _buildDropdown(_selectedMinute, 0, 59, (value) {
                  setState(() {
                    _selectedMinute = value;
                  });
                }, 'МИН'),
                _buildDropdown(_selectedSecond, 0, 59, (value) {
                  setState(() {
                    _selectedSecond = value;
                  });
                }, 'С'),
              ],
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                TextButton(
                  onPressed: () {
                    final selectedTime =
                        TimeOfDay(hour: _selectedHour, minute: _selectedMinute);
                    // Отправляем событие в Bloc
                    widget.bloc
                        .add(TimeSelectedEvent(selectedTime, _selectedSecond));
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
  }

  Widget _buildDropdown(
      int value, int min, int max, Function(int) onChanged, String label) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(180, 255, 255, 255),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              onChanged: (newValue) {
                onChanged(newValue!);
              },
              iconSize: 22,
              alignment: Alignment.center,
              dropdownColor: const Color.fromARGB(180, 255, 255, 255),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
              menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
              borderRadius: BorderRadius.circular(5),
              items: List.generate(max - min + 1, (index) {
                int number = min + index;
                String formattedNumber = number.toString().padLeft(2, '0');
                return DropdownMenuItem<int>(
                  value: number,
                  child: Text(
                    formattedNumber,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
