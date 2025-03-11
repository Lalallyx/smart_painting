import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_painting/ui/colors/colors.dart';
//import 'package:smart_painting/ui/colors/colors.dart';

class ImageInfoTab extends StatelessWidget {
  const ImageInfoTab({super.key});

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
                color: AppColors.imageInfo,
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
                color: AppColors.imageInfo,
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
                color: AppColors.imageInfo,
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
                color: AppColors.imageInfo,
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
            'Общие сведения',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
