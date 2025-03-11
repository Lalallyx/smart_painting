import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_painting/features/smart_painting_create/bloc/create_screen/create_screen_bloc.dart';
import 'package:smart_painting/features/smart_painting_create/widgets/widgets.dart';

class SmartPaintingCreateScreen extends StatelessWidget {
  const SmartPaintingCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      // Создаем экземпляр CreateScreenBloc
      create: (context) => CreateScreenBloc(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 1.2 * kToolbarHeight, 0, 20),
          child: SizedBox(
            height: size.height,
            child: BlocBuilder<CreateScreenBloc, CreateScreenBlocState>(
              builder: (context, state) {
                // Приводим состояние к CreateScreenTabState
                final selectedTab = (state as CreateScreenTabState).selectedTab;

                // Выбираем текущую страницу в зависимости от выбранной вкладки
                Widget currentPage;
                switch (selectedTab) {
                  case 0:
                    currentPage = const AIGenerationTab();
                    break;
                  case 1:
                    currentPage = const UploadingImageTab();
                    break;
                  case 2:
                    currentPage = const ImageInfoTab();
                    break;
                  case 3:
                    currentPage = const SettingsTab();
                    break;
                  default:
                    currentPage = const AIGenerationTab();
                }

                return Stack(
                  children: [
                    currentPage,
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CreateScreenNavigationBar(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
