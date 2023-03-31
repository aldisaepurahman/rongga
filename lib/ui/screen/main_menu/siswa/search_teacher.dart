import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/card/item_search_card.dart';
import 'package:non_cognitive/ui/components/card/teacher_search_card.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/teacher_profile.dart';
import 'package:non_cognitive/utils/teacher_list_dummy.dart';
import 'package:non_cognitive/utils/user_type.dart';

class SearchTeacher extends StatefulWidget {
  const SearchTeacher({super.key});

  @override
  _SearchTeacher createState() => _SearchTeacher();
}

class _SearchTeacher extends State<SearchTeacher> {
  final namaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: UserType.SISWA,
        menu_name: "Cari Guru",
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
              child: TextTypography(
                  text: "Cari Guru",
                  type: TextType.HEADER
              ),
            ),
            TeacherSearchCard(
              namaController: namaController,
              onPressedSubmit: () {},
            ),
            for (var item in teachers)
              ItemSearchCard(
                id_number: item.idNumber,
                name: item.name,
                image: item.photo,
                type: item.type,
                onCheckDetailed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TeacherProfile(type: UserType.SISWA),
                      ));
                },
              )
          ],
        )
    );
  }

}