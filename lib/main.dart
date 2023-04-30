import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/auth/auth_bloc.dart';
import 'package:non_cognitive/data/bloc/student/student_bloc.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_bloc.dart';
import 'package:non_cognitive/ui/screen/auth/auth.dart';
import 'package:non_cognitive/ui/screen/navigations.dart';
import 'package:non_cognitive/ui/screen/onboarding/onboarding_page.dart';
import 'package:non_cognitive/utils/user_type.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<StudentBloc>(create: (context) => StudentBloc()),
      BlocProvider<TeacherBloc>(create: (context) => TeacherBloc()),
      BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
    ],
    child: const MyApp(),
  ));
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