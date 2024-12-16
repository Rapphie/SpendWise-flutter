import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/features/auth/presentation/pages/login_register.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider(
        options: CarouselOptions(
          height: double.infinity,
          viewportFraction: 1.0,
          onPageChanged: (index, reason) {
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginRegisterPage()),
              );
            }
          },
        ),
        items: [
          'assets/images/1.png',
          'assets/images/2.png',
          'assets/images/3.png',
          'assets/images/3.png',
        ].map((imagePath) {
          return Builder(
            builder: (BuildContext context) {
              return Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
