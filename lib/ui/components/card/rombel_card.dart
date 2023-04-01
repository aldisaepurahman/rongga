import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/utils/user_type.dart';

class RombelCard extends StatefulWidget {
  final UserType type;
  String tingkatSiswa;
  final ValueChanged<String> onSelectedChoice;
  final TextEditingController rombelController;
  final bool isEmpty;
  final VoidCallback? onPressedSubmit;
  final VoidCallback? onReset;

  RombelCard(
      {super.key,
        required this.type,
        required this.tingkatSiswa,
        required this.onSelectedChoice,
        required this.rombelController,
        required this.isEmpty,
        this.onPressedSubmit,
        this.onReset});

  @override
  State<StatefulWidget> createState() => _RombelCard();

}

class _RombelCard extends State<RombelCard> {
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
                                widget.tingkatSiswa = value;
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 130,
                    child: TextTypography(
                      type: TextType.DESCRIPTION,
                      text: "Nama Rombel",
                    ),
                  ),
                  Expanded(
                      child: TextInputCustom(
                          controller: widget.rombelController,
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
                  if (widget.type == UserType.GURU_BK && widget.isEmpty)...[
                    ButtonWidget(
                      background: orange,
                      tint: black,
                      type: ButtonType.MEDIUM,
                      content: "Buat Ulang Rombel",
                      onPressed: widget.onReset,
                    ),
                    const SizedBox(width: 20)
                  ],
                  ButtonWidget(
                    background: green,
                    tint: white,
                    type: ButtonType.MEDIUM,
                    content: widget.type == UserType.ADMIN ? "Simpan" : "Cek",
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
