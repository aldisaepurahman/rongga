import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/screen/auth/auth.dart';
import 'package:non_cognitive/ui/screen/navigations.dart';
import 'package:non_cognitive/ui/screen/onboarding/onboarding_page.dart';
import 'package:non_cognitive/utils/user_type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Non-Cognitive',
      // home: Navigations(type: UserType.GURU, hasExpandedContents: true),
      // home: OnboardingPage(),
      home: AuthenticatePage(),
    );
  }
}