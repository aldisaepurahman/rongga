import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';

class InsertStudentCard extends StatefulWidget {
  String student_name;
  final ValueChanged<String> onSelectedChoice;
  final List<String> listStudent;
  String rombel;
  final ValueChanged<String> onRombelChoice;
  final List<String> listRombel;
  final VoidCallback? onPressedSubmit;

  InsertStudentCard(
      {super.key,
        required this.student_name,
        required this.onSelectedChoice,
        required this.listStudent,
        required this.rombel,
        required this.onRombelChoice,
        required this.listRombel,
        this.onPressedSubmit});

  @override
  State<StatefulWidget> createState() => _InsertStudentCard();

}

class _InsertStudentCard extends State<InsertStudentCard> {
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
                      text: "Nama Siswa",
                    ),
                  ),
                  Expanded(
                      child: DropdownFilter(
                          onChanged: (String? value) {
                            setState(() {
                              if (value != null) {
                                widget.student_name = value;
                                widget.onSelectedChoice(widget.student_name);
                              }
                            });
                          },
                          content: widget.student_name,
                          items: widget.listStudent
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
                      text: "Rombel",
                    ),
                  ),
                  Expanded(
                      child: DropdownFilter(
                          onChanged: (String? value) {
                            setState(() {
                              if (value != null) {
                                widget.rombel = value;
                                widget.onRombelChoice(widget.rombel);
                              }
                            });
                          },
                          content: widget.rombel,
                          items: widget.listRombel
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
                    content: "Simpan",
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
