import 'package:flutter/material.dart';
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

class TeacherProfile extends StatefulWidget {
  final UserType type;
  const TeacherProfile({super.key, required this.type});

  @override
  _TeacherProfile createState() => _TeacherProfile();
}

class _TeacherProfile extends State<TeacherProfile> {
  @override
  Widget build(BuildContext context) {
    /*if (widget.type == UserType.SISWA) {
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
    return _renderPage();*/
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
                if (widget.type != UserType.GURU)
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
                      text: "Profil Guru",
                      type: TextType.HEADER
                  ),
                )
              ],
            ),
            _renderPage(_showMobile)
          ],
        )
    );
  }

  ListView _renderPage(bool isMobile) {
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
        Center(
          child: CircleAvatarCustom(
              image: "",
              radius: isMobile ? 50 : 80),
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