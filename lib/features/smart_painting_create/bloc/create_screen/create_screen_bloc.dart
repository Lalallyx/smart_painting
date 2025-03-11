import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_screen_event.dart';
part 'create_screen_state.dart';

class CreateScreenBloc
    extends Bloc<CreateScreenBlocEvent, CreateScreenBlocState> {
  CreateScreenBloc() : super(CreateScreenTabState()) {
    on<TabChangedEvent>((event, emit) {
      // При изменении вкладки emit нового состояния с выбранной вкладкой
      emit(CreateScreenTabState(selectedTab: event.selectedTab));
    });
  }
}
