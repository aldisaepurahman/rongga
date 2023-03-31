import 'package:flutter/cupertino.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';

class TeacherSearchCard extends StatefulWidget {
  final TextEditingController namaController;
  final VoidCallback? onPressedSubmit;
  const TeacherSearchCard({super.key, this.onPressedSubmit, required this.namaController});

  @override
  TeacherSearchState createState() => TeacherSearchState();
}

class TeacherSearchState extends State<TeacherSearchCard> {
  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextTypography(
            type: TextType.TITLE,
            text: "Daftar Guru",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextTypography(
              type: TextType.DESCRIPTION,
              text: "Masukkan nama guru untuk mendapatkan daftar guru yang ingin ditampilkan",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 130,
                  child: TextTypography(
                    type: TextType.DESCRIPTION,
                    text: "Nama Guru",
                  )
                ),
                Expanded(
                  child: TextInputCustom(
                      controller: widget.namaController,
                      hint: "Masukkan Nama Guru",
                      type: TextInputCustomType.NORMAL
                  )
                )
              ],
            )
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonWidget(
                      background: green,
                      tint: white,
                      type: ButtonType.MEDIUM,
                      content: "Cari",
                      onPressed: widget.onPressedSubmit,
                  )
                ],
              )
          ),
        ],
      ),
    );
  }
}