part of 'ai_generation_tab_bloc.dart';

abstract class AiGenerationTabBlocEvent extends Equatable {
  const AiGenerationTabBlocEvent();
}

class StyleChangedEvent extends AiGenerationTabBlocEvent {
  final String style;
  const StyleChangedEvent(this.style);

  @override
  List<Object?> get props => [style];
}

class RequestTextChangedEvent extends AiGenerationTabBlocEvent {
  final String requestText;
  const RequestTextChangedEvent(this.requestText);

  @override
  List<Object?> get props => [requestText];
}

class ExclusionTextChangedEvent extends AiGenerationTabBlocEvent {
  final String exclusionText;
  const ExclusionTextChangedEvent(this.exclusionText);

  @override
  List<Object?> get props => [exclusionText];
}

class TimeSelectedEvent extends AiGenerationTabBlocEvent {
  final TimeOfDay time;
  final int second;
  const TimeSelectedEvent(this.time, this.second);

  @override
  List<Object?> get props => [time, second];
}

class AutoGenerationToggleEvent extends AiGenerationTabBlocEvent {
  final bool isAutoGenerationEnabled;
  const AutoGenerationToggleEvent(this.isAutoGenerationEnabled);

  @override
  List<Object?> get props => [isAutoGenerationEnabled];
}

class SendDataToServerEvent extends AiGenerationTabBlocEvent {
  const SendDataToServerEvent();

  @override
  List<Object?> get props => [];
}
