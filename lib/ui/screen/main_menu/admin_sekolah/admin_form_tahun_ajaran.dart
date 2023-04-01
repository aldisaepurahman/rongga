import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/utils/user_type.dart';

class AdminFormTahunAjaran extends StatefulWidget {
  TahunAjaran? thnAjaran;
  AdminFormTahunAjaran({super.key, this.thnAjaran});

  @override
  State<StatefulWidget> createState() => _AdminFormTahunAjaran();
}

class _AdminFormTahunAjaran extends State<AdminFormTahunAjaran> {
  final tahunController = TextEditingController();
  String _semesterChoice = "Ganjil";

  final List<String> semesterOptList = ["Ganjil", "Genap"];

  final Map<String, int> _tingkatOpt = {
    "VII (Tujuh)": 7,
    "VIII (Delapan)": 8,
    "IX (Sembilan)": 9
  };

  final Map<int, String> _semesterFilled = {
    0: "Ganjil",
    1: "Genap",
  };

  @override
  void initState() {
    super.initState();

    if (widget.thnAjaran != null) {
      _semesterChoice = _semesterFilled[widget.thnAjaran?.semester]!;
      tahunController.text = widget.thnAjaran?.thnAjaran ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: UserType.ADMIN,
        menu_name: "Tahun Ajaran",
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
                const SizedBox(width: 25),
                Container(
                  margin: const EdgeInsets.only(top: 25, bottom: 15),
                  child: TextTypography(
                      text: "Tahun Ajaran",
                      type: TextType.HEADER
                  ),
                )
              ],
            ),
            CardContainer(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 130,
                              child: TextTypography(
                                type: TextType.DESCRIPTION,
                                text: "Semester",
                              )
                          ),
                          Expanded(
                              child: DropdownFilter(
                                  onChanged: (String? value) {
                                    setState(() {
                                      if (value != null) {
                                        _semesterChoice = value;
                                      }
                                    });
                                  },
                                  content: _semesterChoice,
                                  items: semesterOptList
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
                                text: "Tahun Ajaran",
                              )
                          ),
                          Expanded(
                              child: TextInputCustom(
                                  controller: tahunController,
                                  hint: "Misal: 2022/2023",
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
                            content: "Submit",
                            onPressed: () {},
                          )
                        ],
                      )
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

}