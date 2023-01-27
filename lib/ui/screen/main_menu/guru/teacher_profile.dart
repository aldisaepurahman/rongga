import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/card/biodata_card.dart';
import 'package:non_cognitive/ui/components/card/status_profile_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/circle_avatar.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/teacher_profile_update.dart';
import 'package:non_cognitive/utils/user_type.dart';

class TeacherProfile extends StatefulWidget {
  final UserType type;
  const TeacherProfile({super.key, required this.type});

  @override
  _TeacherProfile createState() => _TeacherProfile();
}

class _TeacherProfile extends State<TeacherProfile> {
  @override
  Widget build(BuildContext context) {
    if (widget.type == UserType.SISWA) {
      return Scaffold(
        appBar: AppBarCustom(
          title: "Profil Guru",
          useBackButton: true,
          onBackPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: _renderPage(),
      );
    }
    return _renderPage();
  }

  ListView _renderPage() {
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
                text: "Anda dapat mengubah profil anda pada kolom inputan dibawah",
                align: TextAlign.center,
              ),
            ),
          ),
        const Center(
          child: CircleAvatarCustom(
              image: "",
              radius: 50),
        ),
        const SizedBox(height: 20),
        if (widget.type == UserType.GURU)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                background: green,
                tint: green,
                type: ButtonType.OUTLINED,
                content: "Ubah Profil",
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TeacherProfileUpdate(),
                      ));
                },
              ),
            ],
          ),
        const SizedBox(height: 20),
        const BiodataCard(),
        const StatusProfileCard()
      ],
    );
  }
}