import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/table/rombel_admin.dart';
import 'package:non_cognitive/ui/components/table/table_column.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/admin_sekolah/admin_form_rombel.dart';
import 'package:non_cognitive/utils/admin_assets.dart';
import 'package:non_cognitive/utils/user_type.dart';

class AdminRombelList extends StatefulWidget {
  const AdminRombelList({super.key});

  @override
  State<StatefulWidget> createState() => _AdminRombelList();

}

class _AdminRombelList extends State<AdminRombelList> {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: UserType.ADMIN,
        menu_name: "Rombel Sekolah",
        floatingButton: ButtonWidget(
          background: green,
          tint: white,
          type: ButtonType.FLOAT,
          icon: Icons.add,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AdminFormRombel())
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
                      text: "Rombel Sekolah",
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
                          text: "Pada menu ini, anda dapat menambahkan rombel baru untuk setiap tingkat kelas di sekolah, "
                              "bahkan bisa untuk menghapus rombel tersebut",
                        )),
                  ],
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25),
              child: PaginatedDataTable(
                dataRowHeight: 50,
                columns: createTableHeaders(["No", "Nama Rombel", "Aksi"]),
                source: RombelAdminTableData(
                    context: context,
                    content: rombel_list,
                    onEdited: (RombelSekolah rombel) {},
                    onDeleted: (RombelSekolah rombel) {}
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