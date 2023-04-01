import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/bottom_sheet_item.dart';
import 'package:non_cognitive/data/model/rombel_wali_kelas.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/bottom_sheet.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/table/rombel_wali.dart';
import 'package:non_cognitive/ui/components/table/table_column.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/utils/table_assets.dart';
import 'package:non_cognitive/utils/user_type.dart';

class RombelCheck extends StatefulWidget {
  const RombelCheck({super.key});

  @override
  State<StatefulWidget> createState() => _RombelCheck();

}

class _RombelCheck extends State<RombelCheck> {
  late List<BottomSheetCustomItem> bottom_sheet_profile_list = <BottomSheetCustomItem>[];

  void showChoiceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Tunggu Dulu!",
          content: "Apa anda yakin dengan pilihan anda?Setelah yakin, pilihan ini tidak dapat diubah kembali.",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            // Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    bottom_sheet_profile_list = [
      BottomSheetCustomItem(
        icon: Icons.upgrade,
        title: "Naikkan Tingkat Siswa ke Tingkat Berikutnya",
        onTap: () {
          Navigator.of(context).pop();
          showChoiceDialog();
        },
      ),
      BottomSheetCustomItem(
        icon: Icons.front_hand,
        title: "Putuskan Siswa untuk Tinggal Kelas",
        onTap: () {
          Navigator.of(context).pop();
          showChoiceDialog();
        },
      ),
    ];
  }

  void submitWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content: "Apakah anda yakin dengan perubahan ini?",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: UserType.WALI_KELAS,
        menu_name: "Rombel Saya",
        floatingButton: ButtonWidget(
          background: orange,
          tint: black,
          type: ButtonType.FLOAT,
          icon: Icons.save,
          onPressed: () {
            submitWarningDialog();
          },
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 25, bottom: 15),
                  child: TextTypography(
                      text: "Rombel Saya",
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
                          text: "Pada menu ini, anda dapat menentukan apakah siswa layak naik kelas atau tinggal kelas. "
                              "Cukup tekan tombol pada setiap daftar siswa, kemudian tentukan status dari siswa anda.",
                        )),
                  ],
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25),
              child: PaginatedDataTable(
                dataRowHeight: 50,
                columns: createTableHeaders(["No", "Nama Siswa", "Status", "Aksi"]),
                source: RombelWaliTableData(
                    context: context,
                    content: student_wali_list,
                    onChoose: (RombelWaliKelas siswa) {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder( // <-- SEE HERE
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (context) => BottomSheetCustom(items: bottom_sheet_profile_list),
                      );
                    },
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