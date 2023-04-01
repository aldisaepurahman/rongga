import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/badges/badges.dart';
import 'package:non_cognitive/ui/components/card/item_search_card.dart';
import 'package:non_cognitive/ui/components/card/student_search_card.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/student_profile.dart';
import 'package:non_cognitive/utils/student_list_dummy.dart';
import 'package:non_cognitive/utils/user_type.dart';

class SearchStudent extends StatefulWidget {
  final UserType type;
  const SearchStudent({super.key, required this.type});

  @override
  _SearchStudent createState() => _SearchStudent();
}

class _SearchStudent extends State<SearchStudent> {
  final namaController = TextEditingController();
  final rombelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: widget.type,
        menu_name: "Cari Siswa",
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
              child: TextTypography(
                  text: "Cari Siswa",
                  type: TextType.HEADER
              ),
            ),
            StudentSearchCard(
              namaController: namaController,
              rombelController: rombelController,
              onPressedSubmit: () {},
            ),
            for (var item in students)
              ItemSearchCard(
                id_number: item.idNumber,
                name: item.name,
                image: item.photo,
                type: item.type,
                badgesType: item.studyStyle == "Visual"
                    ? BadgesType.VISUAL
                    : item.studyStyle == "Auditori"
                    ? BadgesType.AUDITORI
                    : BadgesType.KINESTETIK,
                onCheckDetailed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const StudentProfile(userType: UserType.GURU),
                      ));
                },
              )
          ],
        )
    );
  }
}
