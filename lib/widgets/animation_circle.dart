import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/theme/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final bool isRegistration;

  const AnimatedBackground({
    super.key,
    required this.isRegistration,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _topCircleX;
  late Animation<double> _topCircleY;
  late Animation<double> _topCircleSize;
  late Animation<double> _bottomCircleX;
  late Animation<double> _bottomCircleY;
  late Animation<double> _bottomCircleSize;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _setupAnimations();
    if (widget.isRegistration) {
      _controller.forward();
    }
  }

  void _setupAnimations() {
    // Top circle animations
    _topCircleX = Tween<double>(
      begin: -50, // Login position
      end: 50, // Registration position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _topCircleY = Tween<double>(
      begin: 50, // Login position
      end: 80, // Registration position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _topCircleSize = Tween<double>(
      begin: 300, // Login size
      end: 400, // Registration size
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Bottom circle animations
    _bottomCircleX = Tween<double>(
      begin: -80, // Login position
      end: -120, // Registration position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _bottomCircleY = Tween<double>(
      begin: -100, // Login position
      end: -150, // Registration position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _bottomCircleSize = Tween<double>(
      begin: 400, // Login size
      end: 500, // Registration size
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(AnimatedBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRegistration != oldWidget.isRegistration) {
      if (widget.isRegistration) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
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
        return Stack(
          children: [
            // Top circle
            Positioned(
              top: _topCircleY.value,
              right: _topCircleX.value,
              child: Container(
                width: _topCircleSize.value,
                height: _topCircleSize.value,
                decoration: BoxDecoration(
                  color: AppColors.blueDark.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Bottom circle
            Positioned(
              bottom: _bottomCircleY.value,
              left: _bottomCircleX.value,
              child: Container(
                width: _bottomCircleSize.value,
                height: _bottomCircleSize.value,
                decoration: BoxDecoration(
                  color: AppColors.gray2.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
