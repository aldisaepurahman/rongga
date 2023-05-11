import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/ui/components/card/biodata_card.dart';
import 'package:non_cognitive/ui/components/card/final_score_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/utils/mapel_nilai_list.dart';
import 'package:non_cognitive/utils/user_type.dart';

class TeacherScoreInput extends StatefulWidget {
  final UserType type;
  final Student student;

  const TeacherScoreInput({super.key, required this.type, required this.student});

  @override
  State<StatefulWidget> createState() => _TeacherScoreInput();

}

class _TeacherScoreInput extends State<TeacherScoreInput> {
  void submitWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content: "Apakah anda yakin dengan perubahan ini?",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: widget.type,
        menu_name: "Nilai Akhir",
        floatingButton: ButtonWidget(
          background: orange,
          tint: black,
          type: ButtonType.FLOAT,
          icon: Icons.save,
          onPressed: () {
            submitWarningDialog();
          },
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                      text: "Nilai Akhir",
                      type: TextType.HEADER
                  ),
                )
              ],
            ),
            BiodataCard(user_data: widget.student),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: TextTypography(
                type: TextType.TITLE,
                text: "Kolom Nilai Akhir",
                align: TextAlign.center,
              ),
            ),
            CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.type == UserType.GURU)
                    for (var nilai_akhir in nilai_akhir_list_guru_mapel)
                      FinalScoreCard(nama_mapel: nilai_akhir.nama_mapel, nilai: nilai_akhir.nilai, onScoreChanged: (value) {})
                  else
                    for (var nilai_akhir in nilai_akhir_list_all)
                      FinalScoreCard(nama_mapel: nilai_akhir.nama_mapel, nilai: nilai_akhir.nilai, onScoreChanged: (value) {})
                ],
              )
            )
          ],
        )
    );
  }

}