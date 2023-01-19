import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/screen/onboarding/onboarding_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Non-Cognitive',
      home: OnboardingPage(),
    );
  }
}