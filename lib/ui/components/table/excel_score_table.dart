import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/nilai_akhir_input.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class ExcelScoreTableData extends DataTableSource {
  BuildContext context;
  final List<Student> students;
  final List<NilaiAkhirInput> final_scores;

  ExcelScoreTableData({
    required this.context,
    required this.students,
    required this.final_scores
  });

  @override
  DataRow? getRow(int index) {
    if (index >= students.length) return null;

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
              text: students[index].name!,
            ),
          ),
        )),
        DataCell(SizedBox(
          width: double.infinity,
          child: Container(
            child: TextTypography(
              type: TextType.LABEL_TITLE,
              text: final_scores[index].nilai!.toString(),
            ),
          ),
        ))
      ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => students.length;

  @override
  int get selectedRowCount => 0;
}