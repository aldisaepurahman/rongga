import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/card/biodata_card.dart';
import 'package:non_cognitive/ui/components/card/status_profile_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/circle_avatar.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/home_student.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/student_profile_update.dart';
import 'package:non_cognitive/ui/screen/questionnaire/questionnaire.dart';
import 'package:non_cognitive/utils/user_type.dart';

class StudentProfile extends StatefulWidget {
  final UserType userType;
  const StudentProfile({super.key, required this.userType});

  @override
  State<StudentProfile> createState() => _StudentProfile();
}

class _StudentProfile extends State<StudentProfile> {
  @override
  Widget build(BuildContext context) {
    if (widget.userType == UserType.GURU) {
      return Scaffold(
        appBar: AppBarCustom(
          title: "Profil Siswa",
          useBackButton: true,
          onBackPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: _renderPage(widget.userType),
      );
    }

    return _renderPage(widget.userType);
  }

  ListView _renderPage(UserType type) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 25),
      children: [
        if (type == UserType.SISWA)
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget(
              background: green,
              tint: white,
              type: ButtonType.MEDIUM,
              content: type == UserType.SISWA ? "Mulai Tes" : "Cek Hasil Tes",
              onPressed: () {
                if (type == UserType.SISWA) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Questionnaire(),
                      ));
                } else {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StudentHome(type: type, expandedContents: false),
                      ));
                }
              },
            ),
            if (type == UserType.SISWA)
              const SizedBox(width: 20),
            if (type == UserType.SISWA)
              ButtonWidget(
                background: green,
                tint: green,
                type: ButtonType.OUTLINED,
                content: "Ubah Profil",
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const StudentProfileUpdate(),
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