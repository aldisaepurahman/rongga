import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';
import 'package:non_cognitive/ui/components/navigation/bottombar.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/home_teacher.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/search_student.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/teacher_profile.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/home_student.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/search_teacher.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/student_profile.dart';
import 'package:non_cognitive/utils/user_type.dart';

class Navigations extends StatefulWidget {
  final UserType type;
  final bool hasExpandedContents;

  const Navigations(
      {super.key, required this.type, required this.hasExpandedContents});

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigations> {
  late Widget _screen;
  final ListQueue<int> _navigationQueue = ListQueue();
  int _previousPageIndex = 0;
  String _titlePage = "";

  @override
  void initState() {
    super.initState();
    _titlePage = "Statistik";
    _screen = widget.type == UserType.SISWA
        ? StudentHome(
            type: widget.type, expandedContents: widget.hasExpandedContents)
        : const TeacherHome();
  }

  void changeScreen(int index) {
    setState(() {
      switch (index) {
        case 0:
          _titlePage = "Statistik";
          _screen = widget.type == UserType.SISWA
              ? StudentHome(
                  type: widget.type,
                  expandedContents: widget.hasExpandedContents)
              : const TeacherHome();
          break;

        case 1:
          _titlePage = widget.type == UserType.SISWA ? "Daftar Guru" : "Daftar Siswa";
          _screen = widget.type == UserType.SISWA
              ? const SearchTeacher()
              : const SearchStudent();
          break;

        case 2:
          _titlePage = "Profil";
          _screen = widget.type == UserType.SISWA
              ? StudentProfile(userType: widget.type)
              : TeacherProfile(type: widget.type);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /*return WillPopScope(
        child: Scaffold(
          body: _screen,
          appBar: AppBarCustom(title: _titlePage, useBackButton: false),
          bottomNavigationBar: BottomNavBar(
            callback: changeScreen,
              *//*currentPageIndex: (value) => _navigationQueue.addLast(value),
              nextPageIndex: (value) => changeScreen(value),*//*
          ),
        ),
        onWillPop: () async {
          *//*if (_navigationQueue.isEmpty) return true;

          setState(() {
            _previousPageIndex = _navigationQueue.last;
            _navigationQueue.removeLast();
          });*//*
          return false;
        },
    );*/
    return Scaffold(
      body: _screen,
      appBar: AppBarCustom(title: _titlePage, useBackButton: false),
      bottomNavigationBar: BottomNavBar(
        callback: changeScreen,
        /*currentPageIndex: (value) => _navigationQueue.addLast(value),
              nextPageIndex: (value) => changeScreen(value),*/
      ),
    );
  }
}
