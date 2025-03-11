import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_painting/router/router.dart';
import 'package:smart_painting/theme/theme.dart';

class SmartPainting extends StatefulWidget {
  const SmartPainting({super.key});

  @override
  State<SmartPainting> createState() => _SmartPaintingState();
}

class _SmartPaintingState extends State<SmartPainting> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Painting',
      theme: darkTheme,
      routes: routes,
      builder: (context, child) => ResponsiveBreakpoints(
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
        breakpointsLandscape: [
          const Breakpoint(start: 0, end: 1023, name: MOBILE),
          const Breakpoint(start: 1024, end: 1599, name: TABLET),
          const Breakpoint(start: 1600, end: double.infinity, name: DESKTOP),
        ],
        child: child!,
      ),
    );
  }
}
