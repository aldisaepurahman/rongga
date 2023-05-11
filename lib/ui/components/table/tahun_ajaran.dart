import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class TahunAjaranTableData extends DataTableSource {
  BuildContext context;
  final List<TahunAjaran> content;
  Function(TahunAjaran) onTahunAjaranActive;
  Function(TahunAjaran) onEdited;
  Function(TahunAjaran) onDeleted;

  TahunAjaranTableData({
    required this.context,
    required this.content,
    required this.onTahunAjaranActive,
    required this.onEdited,
    required this.onDeleted,
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
                text: content[index].thnAjaran! + " - " + content[index].semester!,
              ),
            ),
          )),
          DataCell(SizedBox(
            width: double.infinity,
            child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!content[index].active!)...[
                      ButtonWidget(
                        background: skyBlue,
                        tint: white,
                        type: ButtonType.ICON_ONLY,
                        icon: Icons.check,
                        onPressed: () {
                          onTahunAjaranActive(content[index]);
                        },
                      ),
                      const SizedBox(width: 20)
                    ],
                    ButtonWidget(
                      background: orange,
                      tint: black,
                      type: ButtonType.ICON_ONLY,
                      icon: Icons.edit,
                      onPressed: () {
                        onEdited(content[index]);
                      },
                    ),
                    const SizedBox(width: 20),
                    ButtonWidget(
                      background: red,
                      tint: white,
                      type: ButtonType.ICON_ONLY,
                      icon: Icons.delete,
                      onPressed: () {
                        onDeleted(content[index]);
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