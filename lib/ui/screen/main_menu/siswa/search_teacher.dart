import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/card/item_search_card.dart';
import 'package:non_cognitive/ui/components/card/teacher_search_card.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/utils/teacher_list_dummy.dart';

class SearchTeacher extends StatefulWidget {
  const SearchTeacher({super.key});

  @override
  _SearchTeacher createState() => _SearchTeacher();
}

class _SearchTeacher extends State<SearchTeacher> {
  final namaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
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
            onCheckDetailed: () {},
          )
      ],
    );
  }

}