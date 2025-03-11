import 'package:flutter/material.dart';
import 'package:smart_painting/ui/colors/colors.dart';

class StartScreenButton extends StatefulWidget {
  final Color color1;
  final Color color2;
  const StartScreenButton({
    super.key,
    this.color1 = AppColors.primary_1,
    this.color2 = AppColors.secondary,
  });

  @override
  State<StartScreenButton> createState() => _StartScreenButtonState();
}

class _StartScreenButtonState extends State<StartScreenButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/create-screen');
          },
          borderRadius: BorderRadius.circular(40),
          child: Container(
            height: 48,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(
                colors: [
                  widget.color1,
                  widget.color2,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color1.withAlpha((0.6 * 255).toInt()),
                  spreadRadius: 1,
                  blurRadius: 16,
                  offset: const Offset(-8, 0),
                ),
                BoxShadow(
                  color: widget.color2.withAlpha((0.6 * 255).toInt()),
                  spreadRadius: 1,
                  blurRadius: 16,
                  offset: const Offset(8, 0),
                ),
              ],
            ),
            child: Stack(
              children: [
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        colors: [
                          widget.color1,
                          widget.color2,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Начать",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize:
                                  (MediaQuery.of(context).size.width * 0.04)
                                      .clamp(12.0, 20.0),
                            ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.onPrimary,
                        size: (MediaQuery.of(context).size.width * 0.04)
                            .clamp(16.0, 25.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
