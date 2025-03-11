part of 'create_screen_bloc.dart';

abstract class CreateScreenBlocState extends Equatable {}

// Общее состояние для начального и обновленного состояния
class CreateScreenTabState extends CreateScreenBlocState {
  final int selectedTab;

  CreateScreenTabState({this.selectedTab = 0});

  @override
  List<Object?> get props => [selectedTab];
}
