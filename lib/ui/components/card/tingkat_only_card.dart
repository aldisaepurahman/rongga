import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/utils/user_type.dart';

class TingkatOnlyCard extends StatefulWidget {
  final UserType type;
  String tingkatSiswa;
  final ValueChanged<String> onSelectedChoice;
  final bool isEmpty;
  final List<Student> listStudent;
  final int allStudent;
  final VoidCallback? onPressedSubmit;
  final VoidCallback? onManualInput;
  final VoidCallback? onReset;

  TingkatOnlyCard(
      {super.key,
        required this.type,
        required this.tingkatSiswa,
        required this.onSelectedChoice,
        required this.isEmpty,
        required this.listStudent,
        required this.allStudent,
        this.onPressedSubmit,
        this.onManualInput,
        this.onReset});

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
    final _showMobile = MediaQuery.of(context).size.width < screenMd;

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.listStudent.isNotEmpty && (widget.type == UserType.GURU_BK ||  widget.type == UserType.GURU_BK_WALI_KELAS)) ...[
                    Expanded(
                        child: ButtonWidget(
                          background: blue,
                          tint: white,
                          type: (_showMobile) ? ButtonType.ICON_ONLY : ButtonType.MEDIUM,
                          icon: Icons.add,
                          content: "Input Siswa Manual",
                          onPressed: widget.onManualInput,
                        )
                    ),
                    const SizedBox(width: 20)
                  ],
                  if (widget.allStudent > 0 && (widget.type == UserType.GURU_BK ||  widget.type == UserType.GURU_BK_WALI_KELAS)) ...[
                    Expanded(
                        child: ButtonWidget(
                          background: orange,
                          tint: black,
                          type: (_showMobile) ? ButtonType.ICON_ONLY : ButtonType.MEDIUM,
                          icon: Icons.lock_reset,
                          content: "Buat Ulang Rombel",
                          onPressed: widget.onReset,
                        )
                    ),
                    const SizedBox(width: 20)
                  ],
                  Expanded(
                      child: ButtonWidget(
                        background: green,
                        tint: white,
                        type: (_showMobile) ? ButtonType.ICON_ONLY : ButtonType.MEDIUM,
                        icon: Icons.search,
                        content: "Cek",
                        onPressed: widget.onPressedSubmit,
                      )
                  )
                ],
              )
          ),
        ],
      ),
    );
  }
}
