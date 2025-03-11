part of 'create_screen_bloc.dart';

abstract class CreateScreenBlocEvent extends Equatable {
  const CreateScreenBlocEvent();
}

class TabChangedEvent extends CreateScreenBlocEvent {
  final int selectedTab;
  const TabChangedEvent({required this.selectedTab});

  @override
  List<Object?> get props => [selectedTab];
}
