import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/card/biodata_card.dart';
import 'package:non_cognitive/ui/components/card/status_profile_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/circle_avatar.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/item_list/profile_item_list.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/student_profile_update.dart';
import 'package:non_cognitive/ui/screen/questionnaire/questionnaire.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  _StudentProfile createState() => _StudentProfile();
}

class _StudentProfile extends State<StudentProfile> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 25),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Center(
            child: TextTypography(
                type: TextType.DESCRIPTION,
                text: "Anda dapat mengubah profil anda pada kolom inputan dibawah",
              align: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 20),
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
              content: "Mulai Tes",
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Questionnaire(),
                    ));
              },
            ),
            const SizedBox(width: 20),
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