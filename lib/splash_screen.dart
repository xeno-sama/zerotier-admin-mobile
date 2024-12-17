// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Задержка для отображения сплешскрина
    Future.delayed(const Duration(milliseconds: 3200), () {
      context.go('/'); // Переход на главный экран
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black, // Черный фон
      body: Center(
        child: RiveAnimation.asset(
          'assets/rive/zerotier.riv', // Путь к файлу .riv
          animations: ['Timeline 1'], // Название анимации внутри файла .riv
        ),
      ),
    );
  }
}
