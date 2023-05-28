import 'dart:convert';

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
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_siswa_add_bloc.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_siswa_check_bloc.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_siswa_delete_bloc.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_siswa_make_bloc.dart';
import 'package:non_cognitive/data/bloc/student/student_bloc.dart';
import 'package:non_cognitive/data/bloc/student/student_quest_bloc.dart';
import 'package:non_cognitive/data/bloc/teacher/student_mapel_bloc.dart';
import 'package:non_cognitive/data/bloc/teacher/student_mapel_score_bloc.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_bloc.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_home_bloc.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/data/model/users.dart';
import 'package:non_cognitive/ui/screen/auth/auth.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/home_teacher.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/home_student.dart';
import 'package:non_cognitive/ui/screen/navigations.dart';
import 'package:non_cognitive/ui/screen/onboarding/onboarding_page.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final String user = pref.getString("user") ?? "";
  final bool hasOnboard = pref.getBool("onboard") ?? false;

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<StudentBloc>(create: (context) => StudentBloc()),
      BlocProvider<StudentQuestBloc>(create: (context) => StudentQuestBloc()),
      BlocProvider<TeacherBloc>(create: (context) => TeacherBloc()),
      BlocProvider<TeacherHomeBloc>(create: (context) => TeacherHomeBloc()),
      BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
      BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
      BlocProvider<RegisterBloc>(create: (context) => RegisterBloc()),
      BlocProvider<RegisterDetailBloc>(create: (context) => RegisterDetailBloc()),
      BlocProvider<TahunAjaranBloc>(create: (context) => TahunAjaranBloc()),
      BlocProvider<TahunAjaranDelActBloc>(create: (context) => TahunAjaranDelActBloc()),
      BlocProvider<RombelSekolahBloc>(create: (context) => RombelSekolahBloc()),
      BlocProvider<RombelSiswaMakeBloc>(create: (context) => RombelSiswaMakeBloc()),
      BlocProvider<RombelSiswaCheckBloc>(create: (context) => RombelSiswaCheckBloc()),
      BlocProvider<RombelSiswaAddBloc>(create: (context) => RombelSiswaAddBloc()),
      BlocProvider<RombelSiswaDeleteBloc>(create: (context) => RombelSiswaDeleteBloc()),
      BlocProvider<RombelSekolahDelActBloc>(create: (context) => RombelSekolahDelActBloc()),
      BlocProvider<StudentMapelBloc>(create: (context) => StudentMapelBloc()),
      BlocProvider<StudentMapelScoreBloc>(create: (context) => StudentMapelScoreBloc()),
    ],
    child: MyApp(onBoard: hasOnboard, user: user),
  ));
}

class MyApp extends StatelessWidget {
  final bool onBoard;
  final String user;

  const MyApp({super.key, required this.onBoard, required this.user});

  Widget _getLandingPage() {
    var users;
    Widget redirected;

    if (user.contains("id_siswa")) {
      users = Student.fromJson(jsonDecode(user));
      redirected = const StudentHome(type: UserType.SISWA, expandedContents: false);
    } else if (user.contains("id_guru")) {
      users = Teacher.fromJson(jsonDecode(user));
      redirected = TeacherHome(type: users.type!);
    } else if (user.isNotEmpty) {
      users = Users.fromJson(jsonDecode(user));
      redirected = TeacherHome(type: users.type!);
    } else {
      users = "";
      redirected = AuthenticatePage(onboard: onBoard);
    }

    return redirected;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Non-Cognitive',
      // home: Navigations(type: UserType.GURU, hasExpandedContents: true),
      // home: OnboardingPage(),
      home: _getLandingPage(),
    );
  }
}