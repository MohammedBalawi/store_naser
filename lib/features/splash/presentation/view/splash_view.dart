import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_width.dart';
import '../../../../core/widgets/scaffold_with_background.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldWithImageBackground(
      child: Padding(
        padding: const EdgeInsets.only(top: 150),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            ManagerImages.logo,
            width: ManagerWidth.w480,
          ),
        ),
      ),
    );
  }
}
