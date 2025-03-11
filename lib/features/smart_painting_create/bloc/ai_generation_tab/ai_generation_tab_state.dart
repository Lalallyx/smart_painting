part of 'ai_generation_tab_bloc.dart';

abstract class AiGenerationTabBlocState extends Equatable {
  const AiGenerationTabBlocState();

  @override
  List<Object?> get props => [];
}

class SmartPaintingUpdatedState extends AiGenerationTabBlocState {
  final String style;
  final String requestText;
  final String exclusionText;
  final TimeOfDay? selectedTime;
  final int selectedSecond;
  final bool isAutoGenerationEnabled;
  final bool isInitial;

  const SmartPaintingUpdatedState({
    this.style = '',
    this.requestText = '',
    this.exclusionText = '',
    this.selectedTime,
    this.selectedSecond = 0,
    this.isAutoGenerationEnabled = false,
    this.isInitial = true,
  });

  @override
  List<Object?> get props => [
        style,
        requestText,
        exclusionText,
        selectedTime,
        selectedSecond,
        isAutoGenerationEnabled,
        isInitial,
      ];

  SmartPaintingUpdatedState copyWith({
    String? style,
    String? requestText,
    String? exclusionText,
    TimeOfDay? selectedTime,
    int? selectedSecond,
    bool? isAutoGenerationEnabled,
    bool? isInitial,
  }) {
    return SmartPaintingUpdatedState(
      style: style ?? this.style,
      requestText: requestText ?? this.requestText,
      exclusionText: exclusionText ?? this.exclusionText,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedSecond: selectedSecond ?? this.selectedSecond,
      isAutoGenerationEnabled:
          isAutoGenerationEnabled ?? this.isAutoGenerationEnabled,
      isInitial: isInitial ?? this.isInitial,
    );
  }
}
