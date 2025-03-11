import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_painting/features/smart_painting_start/widgets/widgets.dart';
import 'package:smart_painting/ui/colors/colors.dart';

class SmartPaintingStartScreen extends StatelessWidget {
  const SmartPaintingStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final conditionals = ResponsiveBreakpoints.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Align(
                alignment: conditionals.largerThan(MOBILE)
                    ? AlignmentDirectional(0.6, -1.5)
                    : AlignmentDirectional(3, -0.2),
                child: Container(
                  height: size.height * 0.4,
                  width: size.height * 0.4,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary_2,
                  ),
                ),
              ),
              Align(
                alignment: conditionals.largerThan(MOBILE)
                    ? AlignmentDirectional(-0.6, -1.5)
                    : AlignmentDirectional(-3, -0.2),
                child: Container(
                  height: size.height * 0.4,
                  width: size.height * 0.4,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary_2,
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, -1.1),
                child: Container(
                  height: conditionals.largerThan(MOBILE) ? 300 : 300,
                  width: conditionals.largerThan(MOBILE) ? 3000 : 600,
                  decoration: const BoxDecoration(
                    color: AppColors.primary_1,
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 200.0, sigmaY: 200.0),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Spacer(flex: 1), // Контролирует отступ сверху (1 доли)
                    Image.asset(
                      'assets/images/png/HomeLogo.png',
                      width: conditionals.largerThan(MOBILE) ? 450 : 300,
                      height: conditionals.largerThan(MOBILE) ? 450 : 300,
                    ),
                    Spacer(
                        flex:
                            1), // Контролирует отступ между картинкой и текстом
                    Text(
                      'Добро пожаловать\n в будущее!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: conditionals.largerThan(MOBILE)
                                ? 45
                                : Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.fontSize,
                          ),
                    ),
                    Spacer(flex: 4), // Отступ между текстом и кнопкой
                    SizedBox(
                      width: (size.width * 0.35).clamp(12.0, 230.0),
                      height: size.height * 0.06,
                      child: StartScreenButton(
                        color1: AppColors.primary_1,
                        color2: AppColors.secondary,
                      ),
                    ),
                    Spacer(flex: 2), // Отступ снизу
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
