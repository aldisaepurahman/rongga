import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/utils/user_type.dart';

class AdminFormRombel extends StatefulWidget {
  RombelSekolah? rombel;
  AdminFormRombel({super.key, this.rombel});

  @override
  State<StatefulWidget> createState() => _AdminFormRombel();
}

class _AdminFormRombel extends State<AdminFormRombel> {
  final rombelController = TextEditingController();
  String _tingkatChoice = "VII (Tujuh)";

  final List<String> tingkatOptList = ["VII (Tujuh)", "VIII (Delapan)", "IX (Sembilan)"];

  final Map<String, int> _tingkatOpt = {
    "VII (Tujuh)": 7,
    "VIII (Delapan)": 8,
    "IX (Sembilan)": 9
  };

  final Map<int, String> _tingkatFilled = {
    7: "VII (Tujuh)",
    8: "VIII (Delapan)",
    9: "IX (Sembilan)"
  };

  @override
  void initState() {
    super.initState();

    if (widget.rombel != null) {
      _tingkatChoice = _tingkatFilled[widget.rombel?.tingkat]!;
      rombelController.text = widget.rombel?.rombel ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: UserType.ADMIN,
        menu_name: "Rombel Sekolah",
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
                      text: "Rombel Sekolah",
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