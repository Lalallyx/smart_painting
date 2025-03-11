import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_painting/features/smart_painting_create/bloc/create_screen/create_screen_bloc.dart';
import 'package:smart_painting/ui/colors/colors.dart';

class CreateScreenNavigationBar extends StatelessWidget {
  const CreateScreenNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      Icons.auto_awesome,
      Icons.upload_file_outlined,
      Icons.image,
      Icons.settings,
    ];

    return SafeArea(
      child: BlocBuilder<CreateScreenBloc, CreateScreenBlocState>(
        builder: (context, state) {
          // Приводим состояние к CreateScreenTabState
          final selectedTab = (state as CreateScreenTabState).selectedTab;

          return Container(
            margin: const EdgeInsets.fromLTRB(80, 0, 80, 8),
            padding: const EdgeInsets.all(1),
            constraints: const BoxConstraints(maxWidth: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  AppColors.onPrimary.withAlpha(128),
                  AppColors.onPrimary.withAlpha(0),
                ],
              ),
            ),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: AppColors.createScreenWindows.withAlpha(204),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  icons.length,
                  (index) {
                    return Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(12),
                        child: AnimatedOpacity(
                          opacity: selectedTab == index ? 1 : 0.5,
                          duration: const Duration(milliseconds: 200),
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: -4,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 4,
                                  width: selectedTab == index ? 20 : 0,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              Icon(
                                icons[index],
                                size: 36,
                                color: selectedTab == index
                                    ? AppColors.onPrimary
                                    : AppColors.onPrimaryMute,
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          // Отправляем событие изменения вкладки через Bloc
                          context
                              .read<CreateScreenBloc>()
                              .add(TabChangedEvent(selectedTab: index));
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
