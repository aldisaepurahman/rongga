import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/table/table_column.dart';
import 'package:non_cognitive/ui/components/table/tahun_ajaran.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/admin_sekolah/admin_form_tahun_ajaran.dart';
import 'package:non_cognitive/utils/admin_assets.dart';
import 'package:non_cognitive/utils/user_type.dart';

class AdminTahunAjaran extends StatefulWidget {
  const AdminTahunAjaran({super.key});

  @override
  State<StatefulWidget> createState() => _AdminTahunAjaran();

}

class _AdminTahunAjaran extends State<AdminTahunAjaran> {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: UserType.ADMIN,
        menu_name: "Tahun Ajaran",
        floatingButton: ButtonWidget(
          background: green,
          tint: white,
          type: ButtonType.FLOAT,
          icon: Icons.add,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AdminFormTahunAjaran())
            );
          },
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
                  child: TextTypography(
                      text: "Tahun Ajaran",
                      type: TextType.HEADER
                  ),
                )
              ],
            ),
            CardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTypography(
                      type: TextType.TITLE,
                      text: "Informasi Detail",
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextTypography(
                          type: TextType.DESCRIPTION,
                          text: "Pada menu ini, anda dapat menambahkan tahun ajaran baru dan mengatur tahun "
                              "ajaran mana yang aktif dalam sistem aplikasi ini.",
                        )),
                  ],
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25),
              child: PaginatedDataTable(
                dataRowHeight: 50,
                columns: createTableHeaders(["No", "Tahun Ajaran", "Aksi"]),
                source: TahunAjaranTableData(
                    context: context,
                    content: thn_ajaran_list,
                    onTahunAjaranActive: (TahunAjaran thn_ajaran) {},
                  onEdited: (TahunAjaran thn_ajaran) {},
                  onDeleted: (TahunAjaran thn_ajaran) {}
                ),
                rowsPerPage: 5,
                columnSpacing: 0,
                horizontalMargin: 0,
                showCheckboxColumn: false,
              ),
            )
          ],
        )
    );
  }

}