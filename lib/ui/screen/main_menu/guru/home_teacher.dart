import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/chart/pie.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/utils/user_type.dart';

class TeacherHome extends StatefulWidget {
  final UserType type;
  const TeacherHome({super.key, required this.type});

  @override
  _TeacherHome createState() => _TeacherHome();
}

class _TeacherHome extends State<TeacherHome> {
  final rombelController = TextEditingController();
  String _tingkatChoice = "VII (Tujuh)";

  final List<String> tingkatOptList = ["VII (Tujuh)", "VIII (Delapan)", "IX (Sembilan)"];

  final Map<String, int> _tingkatOpt = {
    "VII (Tujuh)": 7,
    "VIII (Delapan)": 8,
    "IX (Sembilan)": 9
  };

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: widget.type,
        menu_name: "Beranda",
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 25, bottom: 15),
                  child: TextTypography(
                      text: "Statistik",
                      type: TextType.HEADER
                  ),
                )
              ],
            ),
            if (widget.type != UserType.WALI_KELAS)
              CardContainer(
                child: Column(
                  children: [
                    TextTypography(
                      type: TextType.TITLE,
                      text: "Diagram Persentase Setiap Kelompok Belajar",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextTypography(
                        type: TextType.DESCRIPTION,
                        text: "Berikut adalah persentase dari setiap kelompok gaya belajar dalam bentuk diagram. Jika ingin melihat berdasarkan tingkat kelas dan rombelnya, pilih dan masukkan rombel yang ingin dilihat.",
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
                                  text: "Tingkat Kelas",
                                )
                            ),
                            Expanded(
                                child: DropdownFilter(
                                    onChanged: (String? value) {
                                      setState(() {
                                        if (value != null) {
                                          _tingkatChoice = value;
                                        }
                                      });
                                    },
                                    content: _tingkatChoice,
                                    items: tingkatOptList
                                )
                            )
                          ],
                        )
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
                                  text: "Nama Rombel",
                                )
                            ),
                            Expanded(
                                child: TextInputCustom(
                                    controller: rombelController,
                                    hint: "Misal: 8A",
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
                              background: orange,
                              tint: white,
                              type: ButtonType.MEDIUM,
                              content: "Cek",
                              onPressed: () {},
                            )
                          ],
                        )
                    ),
                  ],
                ),
              ),
            CardContainer(
                child: Column(
                  children: [
                    TextTypography(
                      type: TextType.TITLE,
                      text: widget.type != UserType.WALI_KELAS ? "Rekap Diagram Persentase" : "Rekap Diagram Persentase Kelas 7A",
                    ),
                    const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Pie()
                    )
                  ],
                )
            ),
            if (widget.type == UserType.WALI_KELAS)
              CardContainer(
                  child: Column(
                    children: [
                      TextTypography(
                        type: TextType.TITLE,
                        text: "Informasi Detail",
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextTypography(
                            type: TextType.DESCRIPTION,
                            text: "Siswa di rombel ini cenderung kuat dalam hal berhitung dan membaca, "
                                "serta kuat dalam materi yang berkaitan dengan matematika, "
                                "namun kurang baik dalam materi tentang Bahasa Inggris",
                          )),
                    ],
                  )),
          ],
        )
    );
  }

}