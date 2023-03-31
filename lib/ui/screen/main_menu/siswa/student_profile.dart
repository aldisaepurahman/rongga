import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/bottom_sheet_item.dart';
import 'package:non_cognitive/ui/components/card/biodata_card.dart';
import 'package:non_cognitive/ui/components/card/status_profile_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/circle_avatar.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/bottom_sheet.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/home_student.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/student_profile_update.dart';
import 'package:non_cognitive/ui/screen/questionnaire/questionnaire.dart';
import 'package:non_cognitive/utils/user_type.dart';

class StudentProfile extends StatefulWidget {
  final UserType userType;
  const StudentProfile({super.key, required this.userType});

  @override
  State<StudentProfile> createState() => _StudentProfile();
}

class _StudentProfile extends State<StudentProfile> {
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

  @override
  Widget build(BuildContext context) {
    final _showMobile = MediaQuery.of(context).size.width < screenMd;

    return MainLayout(
        type: widget.userType,
        menu_name: "Profil",
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.userType != UserType.SISWA)
                  Container(
                    margin: const EdgeInsets.only(top: 25, bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ButtonWidget(
                          background: gray,
                          tint: lightGray,
                          type: ButtonType.BACK,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
                  child: TextTypography(
                      text: "Profil Siswa",
                      type: TextType.HEADER
                  ),
                )
              ],
            ),
            _renderPage(widget.userType, _showMobile)
          ],
        )
    );
  }

  ListView _renderPage(UserType type, bool isMobile) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 25),
      children: [
        if (type == UserType.SISWA)
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
            child: isMobile ? Center(
              child: TextTypography(
                type: TextType.DESCRIPTION,
                text: "Anda dapat mengubah profil anda pada kolom inputan dibawah",
              ),
            ) : TextTypography(
              type: TextType.DESCRIPTION,
              text: "Anda dapat mengubah profil anda pada kolom inputan dibawah",
            ),
          ),
        Center(
          child: CircleAvatarCustom(
              image: "",
              radius: isMobile ? 50: 80),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget(
              background: green,
              tint: white,
              type: ButtonType.MEDIUM,
              content: type == UserType.SISWA ? "Mulai Tes" : "Hasil Tes",
              onPressed: () {
                if (type == UserType.SISWA) {
                  /*Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Questionnaire(),
                      ));*/
                } else {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StudentHome(type: type, expandedContents: true),
                      ));
                }
              },
            ),
            const SizedBox(width: 20),
            ButtonWidget(
              background: green,
              tint: green,
              type: ButtonType.OUTLINED,
              content: type == UserType.SISWA ? "Ubah Profil" : "Input Nilai Akhir",
              onPressed: () {
                if (type == UserType.SISWA) {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const StudentProfileUpdate(),
                      ));
                } else {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder( // <-- SEE HERE
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    builder: (context) => BottomSheetCustom(items: bottom_sheet_profile_list),
                  );
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        const BiodataCard(),
        const StatusProfileCard()
      ],
    );
  }

}