import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/rombel_siswa.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class RombelCreateTableData extends DataTableSource {
  BuildContext context;
  final List<RombelSiswa> content;
  final bool useLevel;

  RombelCreateTableData({
    required this.context,
    required this.content,
    required this.useLevel
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
              text: content[index].name!,
            ),
          ),
        )),
        DataCell(SizedBox(
          width: double.infinity,
          child: Container(
            child: TextTypography(
              type: TextType.LABEL_TITLE,
              text: useLevel ? "${content[index].style.learningStyle!} - ${content[index].level!}" : content[index].style.learningStyle!,
            ),
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