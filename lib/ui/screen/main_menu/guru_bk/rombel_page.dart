import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/table/rombel_style.dart';
import 'package:non_cognitive/ui/components/table/table_column.dart';

class RombelPage extends StatefulWidget {
  final String rombel_name;
  final String description;
  final ValueChanged<String?> onSelectedWaliKelas;
  final List<String> tableHeader;
  final List<StudentStyle> tableContent;

  const RombelPage(
      {super.key,
      required this.rombel_name,
      required this.description,
      required this.onSelectedWaliKelas,
      required this.tableHeader,
      required this.tableContent});

  @override
  State<StatefulWidget> createState() => _RombelPage();
}

class _RombelPage extends State<RombelPage> {
  final List<String> guruList = ["Erni Nurhaeni, S.Pd", "Agus Riyadi, S.Pd", "Dedi Kusnadi, S.Pd"];
  String _guruChoice = "Erni Nurhaeni, S.Pd";

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25, bottom: 15),
              child: TextTypography(
                  text: "Rombel ${widget.rombel_name}",
                  type: TextType.HEADER
              ),
            )
          ],
        ),
        CardContainer(
            child: Column(
              children: [
                TextTypography(
                  type: TextType.TITLE,
                  text: "Informasi Detail",
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextTypography(
                      type: TextType.DESCRIPTION,
                      text: widget.description,
                    )),
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
                          child: DropdownFilter(
                              onChanged: (String? value) {
                                setState(() {
                                  if (value != null) {
                                    _guruChoice = value;
                                    widget.onSelectedWaliKelas(_guruChoice);
                                  }
                                });
                              },
                              content: _guruChoice,
                              items: guruList
                          )
                      )
                    ],
                  ),
                ),
              ],
            )),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 25),
          child: PaginatedDataTable(
            dataRowHeight: 50,
            columns: createTableHeaders(widget.tableHeader),
            source: RombelStyleTableData(
                context: context,
                content: widget.tableContent
            ),
            rowsPerPage: 5,
            columnSpacing: 0,
            horizontalMargin: 0,
            showCheckboxColumn: false,
          ),
        )
      ],
    );
  }

}