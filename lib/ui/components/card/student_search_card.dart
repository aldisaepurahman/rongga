import 'package:flutter/cupertino.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';

class StudentSearchCard extends StatefulWidget {
  final TextEditingController namaController;
  final TextEditingController tahunController;
  final VoidCallback? onPressedSubmit;
  const StudentSearchCard({super.key, this.onPressedSubmit, required this.namaController, required this.tahunController});

  @override
  StudentSearchState createState() => StudentSearchState();
}

class StudentSearchState extends State<StudentSearchCard> {
  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        children: [
          TextTypography(
            type: TextType.TITLE,
            text: "Daftar Gaya Belajar Siswa",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextTypography(
              type: TextType.DESCRIPTION,
              text: "Masukkan nama siswa dan tahun masuk"
                  "siswa untuk mendapatkan daftar gaya"
                  "belajar siswa yang ingin ditampilkan",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextTypography(
                  type: TextType.DESCRIPTION,
                  text: "Nama Siswa",
                ),
                TextInputCustom(
                  controller: widget.namaController,
                  hint: "Masukkan Nama Siswa",
                  type: TextInputCustomType.NORMAL
                )
              ],
            )
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextTypography(
                    type: TextType.DESCRIPTION,
                    text: "Tahun Masuk",
                  ),
                  TextInputCustom(
                      controller: widget.tahunController,
                      hint: "Masukkan Tahun Masuk",
                      type: TextInputCustomType.NORMAL
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
                      onPressed: () {},
                  )
                ],
              )
          ),
        ],
      ),
    );
  }
}