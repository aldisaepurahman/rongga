import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/card/rombel_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru_bk/rombel_page.dart';
import 'package:non_cognitive/utils/table_assets.dart';
import 'package:non_cognitive/utils/user_type.dart';

class CreateRombel extends StatefulWidget {
  final UserType type;
  bool extendedContents;

  CreateRombel({super.key, required this.type, required this.extendedContents});

  @override
  State<StatefulWidget> createState() => _CreateRombel();

}

class _CreateRombel extends State<CreateRombel> {
  String tingkatChoice = "VII (Tujuh)";
  final rombelController = TextEditingController();
  final _controller = PageController();
  static const _duration = Duration(milliseconds: 300);
  static const _curve = Curves.ease;

  int index = 0;

  @override
  void dispose() {
    _controller.dispose();
    rombelController.dispose();
    super.dispose();
  }

  void submitWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content: "Apakah anda yakin dengan hasil yang ditampilkan?",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            /*Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const StudentHome(type: UserType.SISWA, expandedContents: true),
                ));*/
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
        menu_name: "Buat Rombel",
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 25, bottom: 15),
                  child: TextTypography(
                      text: "Rombel Siswa",
                      type: TextType.HEADER
                  ),
                )
              ],
            ),
            RombelCard(
                type: widget.type,
                tingkatSiswa: tingkatChoice,
                onSelectedChoice: (String value) {
                  tingkatChoice = value;
                },
                rombelController: rombelController,
                isEmpty: widget.extendedContents,
              onPressedSubmit: () {},
              onReset: () {},
            ),
            if (widget.extendedContents)
              ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 600,
                    child: PageView(
                        controller: _controller,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (value) {},
                        children: [
                          RombelPage(
                              rombel_name: "7A",
                              description: "Siswa di rombel ini cenderung kuat dalam hal berhitung dan membaca, "
                                  "serta kuat dalam materi yang berkaitan dengan matematika, "
                                  "namun kurang baik dalam materi tentang Bahasa Inggris",
                              onSelectedWaliKelas: (value) {},
                              tableHeader: ["No", "Nama Siswa", "Gaya Belajar"],
                              tableContent: student_style_list
                          ),
                          RombelPage(
                              rombel_name: "7B",
                              description: "Siswa di rombel ini cenderung kuat dalam hal berhitung dan membaca, "
                                  "serta kuat dalam materi yang berkaitan dengan matematika, "
                                  "namun kurang baik dalam materi tentang Bahasa Inggris",
                              onSelectedWaliKelas: (value) {},
                              tableHeader: ["No", "Nama Siswa", "Gaya Belajar"],
                              tableContent: student_style_list_2
                          )
                        ]
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (index > 0)
                            ButtonWidget(
                              background: green,
                              tint: green,
                              type: ButtonType.OUTLINED,
                              content: "Sebelumnya",
                              onPressed: () {
                                setState(() {
                                  index--;
                                });
                                _controller.previousPage(
                                    duration: _duration, curve: _curve);
                              },
                            ),
                          const SizedBox(width: 10),
                          ButtonWidget(
                            background: green,
                            tint: white,
                            type: ButtonType.MEDIUM,
                            content: (index != 1)
                                ? "Selanjutnya"
                                : "Simpan Data Rombel",
                            onPressed: () {
                              (index != 1)
                                  ? _controller.nextPage(
                                  duration: _duration, curve: _curve)
                                  : submitWarningDialog();
                              setState(() {
                                index++;
                              });
                            },
                          )
                        ],
                      )),
                ],
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextTypography(
                      type: TextType.DESCRIPTION,
                      text: "Rombel di tahun ajaran saat ini belum dibuat",
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ButtonWidget(
                      background: green,
                      tint: white,
                      type: ButtonType.LARGE,
                      content: "Buat Rombel",
                      onPressed: () {
                        setState(() {
                          widget.extendedContents = true;
                        });
                      },
                    )
                  ],
                ),
              )
          ],
        )
    );
  }
}