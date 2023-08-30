import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/rombel_siswa.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/teacher_score_input.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/student_profile.dart';
import 'package:non_cognitive/utils/user_type.dart';

class RombelCreateTableData extends DataTableSource {
  BuildContext context;
  final List<RombelSiswa> content;
  final bool useLevel;
  final bool isFieldReadOnly;
  final UserType type;

  RombelCreateTableData({
    required this.context,
    required this.content,
    required this.useLevel,
    required this.isFieldReadOnly,
    required this.type,
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
            child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14, fontFamily: "Poppins", color: black, fontWeight: FontWeight.bold
                  ),
                  children: [
                    TextSpan(
                      text: content[index].name!,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          if (isFieldReadOnly) {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => TeacherScoreInput(
                                    type: type, student: content[index].student!, isFieldReadOnly: isFieldReadOnly))
                            );
                          } else {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => StudentProfile(
                                    userType: type, student: content[index].student!))
                            );
                          }
                        }
                    )
                  ]
                )
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