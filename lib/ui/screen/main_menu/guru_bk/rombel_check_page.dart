import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/data/model/rombel_siswa.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/table/rombel_create.dart';
import 'package:non_cognitive/ui/components/table/rombel_style.dart';
import 'package:non_cognitive/ui/components/table/table_column.dart';

class RombelCheckPage extends StatefulWidget {
  final String rombel_name;
  final String description;
  final List<String> tableHeader;
  final List<RombelSiswa> tableContent;

  RombelCheckPage(
      {super.key,
      required this.rombel_name,
      required this.description,
      required this.tableHeader,
      required this.tableContent});

  @override
  State<StatefulWidget> createState() => _RombelCheckPage();
}

class _RombelCheckPage extends State<RombelCheckPage> {
  @override
  void initState() {
    super.initState();
  }

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
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
                      ],
                    )
                ),
                const SizedBox(width: 20),
                Align(
                  alignment: Alignment.center,
                  child: Lottie.asset("assets/images/woman-teacher.json",
                      repeat: true, animate: true, reverse: false, height: MediaQuery.of(context).size.height * 0.2),
                )
              ],
            )
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 25),
          child: PaginatedDataTable(
            dataRowHeight: 50,
            columns: createTableHeaders(widget.tableHeader),
            source: RombelCreateTableData(
                context: context,
                content: widget.tableContent,
              useLevel: false
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