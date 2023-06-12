import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/utils/user_type.dart';

class NilaiAkhirExcelCard extends StatefulWidget {
  final TextEditingController rombelController;
  final VoidCallback? onPressedSubmit;
  final VoidCallback? onBrowse;

  NilaiAkhirExcelCard(
      {super.key,
        required this.rombelController,
        this.onPressedSubmit,
        this.onBrowse});

  @override
  State<StatefulWidget> createState() => _NilaiAkhirExcelCard();

}

class _NilaiAkhirExcelCard extends State<NilaiAkhirExcelCard> {
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
                      text: "Import Excel",
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 3,
                      child: TextInputCustom(
                          controller: widget.rombelController,
                          hint: "Nama File",
                          type: TextInputCustomType.NORMAL,
                        readOnly: true,
                      )
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                      child: ButtonWidget(
                        background: orange,
                        tint: black,
                        type: (_showMobile) ? ButtonType.ICON_ONLY : ButtonType.MEDIUM,
                        icon: Icons.upload,
                        content: "Import",
                        onPressed: widget.onBrowse,
                      )
                  ),
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
