import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/utils/user_type.dart';

class TingkatOnlyCard extends StatefulWidget {
  final UserType type;
  String tingkatSiswa;
  final ValueChanged<String> onSelectedChoice;
  final bool isEmpty;
  final VoidCallback? onPressedSubmit;

  TingkatOnlyCard(
      {super.key,
        required this.type,
        required this.tingkatSiswa,
        required this.onSelectedChoice,
        required this.isEmpty,
        this.onPressedSubmit});

  @override
  State<StatefulWidget> createState() => _TingkatOnlyCard();

}

class _TingkatOnlyCard extends State<TingkatOnlyCard> {
  final Map<String, int> tingkatKelasOpt = {
    "VII (Tujuh)": 7,
    "VIII (Delapan)": 8,
    "IX (Sembilan)": 9,
  };

  final List<String> tingkatKelasList = ["VII (Tujuh)", "VIII (Delapan)", "IX (Sembilan)"];

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                  ),
                  Expanded(
                      child: DropdownFilter(
                          onChanged: (String? value) {
                            setState(() {
                              if (value != null) {
                                // widget.tingkatSiswa = value;
                                widget.onSelectedChoice(widget.tingkatSiswa);
                              }
                            });
                          },
                          content: widget.tingkatSiswa,
                          items: tingkatKelasList
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
                    content: "Cek",
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
