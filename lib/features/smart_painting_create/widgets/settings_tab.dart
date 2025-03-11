import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:smart_painting/ui/colors/colors.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
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
                color: AppColors.settings,
              ),
            ),
          ),
        ),
        // Правый верхний угол
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
                color: AppColors.settings,
              ),
            ),
          ),
        ),
        // Левый нижний угол
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
                color: AppColors.settings,
              ),
            ),
          ),
        ),
        // Правый нижний угол
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
                color: AppColors.settings,
              ),
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 300.0, sigmaY: 300.0),
          child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Настройки',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.09),
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: (size.width * 0.8).clamp(200, 800),
              height: size.height * 0.14,
              child: Column(
                children: [
                  const SizedBox(height: 10),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Подключение рамки',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.arrow_forward_ios,
                                color: AppColors.onPrimary),
                            onPressed: () {},
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Язык',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.arrow_forward_ios,
                                color: AppColors.onPrimary),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
