import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/rombel_wali_kelas.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class RombelWaliTableData extends DataTableSource {
  BuildContext context;
  final List<RombelWaliKelas> content;
  Function(RombelWaliKelas) onChoose;

  RombelWaliTableData({
    required this.context,
    required this.content,
    required this.onChoose
  });

  @override
  DataRow? getRow(int index) {
    if (index >= content.length) return null;

    return DataRow.byIndex(
        index: index,
        cells: <DataCell>[
          DataCell(SizedBox(
            width: double.infinity,
            child: Container(
              alignment: Alignment.center,
              child: TextTypography(
                type: TextType.LABEL_TITLE,
                text: "${index+1}",
              ),
            ),
          )),
          DataCell(SizedBox(
            width: double.infinity,
            child: Container(
              child: TextTypography(
                type: TextType.LABEL_TITLE,
                text: content[index].name,
              ),
            ),
          )),
          DataCell(SizedBox(
            width: double.infinity,
            child: Container(
              child: TextTypography(
                type: TextType.LABEL_TITLE,
                text: content[index].status == 2 ? "Naik Kelas" : content[index].status == 1 ? "Tinggal Kelas" : "-",
              ),
            ),
          )),
          DataCell(SizedBox(
            width: double.infinity,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWidget(
                    background: green,
                    tint: white,
                    type: ButtonType.ICON_ONLY,
                    icon: Icons.settings,
                    onPressed: () {
                      onChoose(content[index]);
                    },
                  )
                ],
              )
            ),
          ))
        ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => content.length;

  @override
  int get selectedRowCount => 0;

}