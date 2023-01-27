import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/chart/pie.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({super.key});

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
    return ListView(
      children: [
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
                  text: "Rekap Diagram Persentase",
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Pie()
                )
              ],
            )
        )
      ],
    );
  }

}