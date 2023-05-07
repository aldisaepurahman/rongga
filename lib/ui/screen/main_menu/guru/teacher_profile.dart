import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/ui/components/card/biodata_card.dart';
import 'package:non_cognitive/ui/components/card/status_profile_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/circle_avatar.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/teacher_profile_update.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class TeacherProfile extends StatefulWidget {
  final UserType type;
  final Teacher? teacher;

  const TeacherProfile({super.key, required this.type, this.teacher});

  @override
  _TeacherProfile createState() => _TeacherProfile();
}

class _TeacherProfile extends State<TeacherProfile> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Teacher _teacher = Teacher(
      idNumber: "",
      name: "",
      email: "",
      password: "",
      gender: "",
      no_telp: "",
      photo: "",
      address: "",
      type: UserType.GURU,
      id_sekolah: 0,
      id_tahun_ajaran: 0,
      tahun_ajaran: '',
      token: ''
  );

  FutureOr onBackPage(dynamic value) {
    initProfile();
  }

  void initProfile() async {
    final SharedPreferences prefs = await _prefs;
    final String user = prefs.getString("user") ?? "";
    print("infokan $user");

    setState(() {
      if (widget.teacher != null) {
        _teacher = widget.teacher!;
      } else {
        _teacher = Teacher.fromJson(jsonDecode(user));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initProfile();
  }

  @override
  Widget build(BuildContext context) {
    final _showMobile = MediaQuery.of(context).size.width < screenMd;

    return MainLayout(
        type: widget.type,
        menu_name: "Profil",
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.type != UserType.GURU &&
                    widget.type != UserType.GURU_BK &&
                    widget.type != UserType.WALI_KELAS &&
                    widget.type != UserType.GURU_BK_WALI_KELAS)
                  Container(
                    margin: const EdgeInsets.only(top: 25, bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ButtonWidget(
                          background: gray,
                          tint: lightGray,
                          type: ButtonType.BACK,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
                  child: TextTypography(
                      text: "Profil Guru", type: TextType.HEADER),
                )
              ],
            ),
            _renderPage(_showMobile, _teacher)
          ],
        ));
  }

  ListView _renderPage(bool isMobile, Teacher teacher) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 25),
      children: [
        if (widget.type == UserType.GURU)
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
            child: Center(
              child: TextTypography(
                type: TextType.DESCRIPTION,
                text:
                    "Anda dapat mengubah profil anda pada kolom inputan dibawah",
                align: TextAlign.center,
              ),
            ),
          ),
        Center(
          child: CircleAvatarCustom(
              fromNetwork: teacher.photo,
              path: "assets/images/no_image.png",
              isWeb: kIsWeb,
              radius: isMobile ? 50 : 80),
        ),
        const SizedBox(height: 20),
        if (widget.type == UserType.GURU ||
            widget.type == UserType.GURU_BK ||
            widget.type == UserType.WALI_KELAS ||
            widget.type == UserType.GURU_BK_WALI_KELAS)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                background: green,
                tint: green,
                type: ButtonType.OUTLINED,
                content: "Ubah Profil",
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>
                        TeacherProfileUpdate(type: widget.type, teacher: teacher),
                  )).then(onBackPage);
                },
              ),
            ],
          ),
        const SizedBox(height: 20),
        BiodataCard(user_data: teacher),
        StatusProfileCard(type: UserType.GURU, teacher_data: teacher)
      ],
    );
  }
}
