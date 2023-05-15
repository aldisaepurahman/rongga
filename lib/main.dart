import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/rombel_sekolah_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/rombel_sekolah_delact_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_delact_bloc.dart';
import 'package:non_cognitive/data/bloc/auth/auth_bloc.dart';
import 'package:non_cognitive/data/bloc/auth/login_bloc.dart';
import 'package:non_cognitive/data/bloc/auth/register_bloc.dart';
import 'package:non_cognitive/data/bloc/auth/register_detail_bloc.dart';
import 'package:non_cognitive/data/bloc/student/student_bloc.dart';
import 'package:non_cognitive/data/bloc/student/student_quest_bloc.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_bloc.dart';
import 'package:non_cognitive/ui/screen/auth/auth.dart';
import 'package:non_cognitive/ui/screen/navigations.dart';
import 'package:non_cognitive/ui/screen/onboarding/onboarding_page.dart';
import 'package:non_cognitive/utils/user_type.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<StudentBloc>(create: (context) => StudentBloc()),
      BlocProvider<StudentQuestBloc>(create: (context) => StudentQuestBloc()),
      BlocProvider<TeacherBloc>(create: (context) => TeacherBloc()),
      BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
      BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
      BlocProvider<RegisterBloc>(create: (context) => RegisterBloc()),
      BlocProvider<RegisterDetailBloc>(create: (context) => RegisterDetailBloc()),
      BlocProvider<TahunAjaranBloc>(create: (context) => TahunAjaranBloc()),
      BlocProvider<TahunAjaranDelActBloc>(create: (context) => TahunAjaranDelActBloc()),
      BlocProvider<RombelSekolahBloc>(create: (context) => RombelSekolahBloc()),
      BlocProvider<RombelSekolahDelActBloc>(create: (context) => RombelSekolahDelActBloc()),
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