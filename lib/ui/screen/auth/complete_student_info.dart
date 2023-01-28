import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/screen/navigations.dart';
import 'package:non_cognitive/utils/user_type.dart';

class CompleteStudentInfo extends StatefulWidget {
  const CompleteStudentInfo({super.key});

  @override
  State<CompleteStudentInfo> createState() => _CompleteStudentInfo();

}

class _CompleteStudentInfo extends State<CompleteStudentInfo> {
  final Map<String, int> tingkatKelasOpt = {
    "VII (Tujuh)": 7,
    "VIII (Delapan)": 8,
    "IX (Sembilan)": 9,
  };

  final List<String> tingkatKelasList = ["VII (Tujuh)", "VIII (Delapan)", "IX (Sembilan)"];

  final Map<String, int> statusSiswaOpt = {
    "Peserta didik baru": 0,
    "Peserta didik pindahan dari sekolah lain": 1,
    // "Peserta didik tidak naik kelas 1x": 2,
    // "Lulus": 3,
    // "Keluar": 4,
  };

  final List<String> statusSiswaList = [
    "Peserta didik baru",
    "Peserta didik pindahan dari sekolah lain",
    // "Peserta didik tidak naik kelas 1x",
    // "Lulus",
    // "Keluar",
  ];

  final tahunController = TextEditingController(text: "2022");
  final rombelController = TextEditingController(text: "7C");
  String _statusSiswa = "Peserta didik baru";
  String _tingkatSiswa = "VII (Tujuh)";

  void backWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content:
          "Informasi yang anda masukkan tidak akan tersimpan. Anda yakin akan membatalkan proses melengkapi profil anda?",
          path_image: "assets/images/caution.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Navigations(type: UserType.SISWA, hasExpandedContents: false),
                ));
          },
        );
      },
    );
  }

  void submitWarningDialog(int type) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Tunggu Dulu!",
          content: type == 1 ? "Apakah anda yakin dengan informasi yang anda masukkan?" : "Jika tidak melengkapi data akun, anda bisa melengkapinya pada halaman profil anda, yakin untuk lewati?",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Navigations(type: UserType.SISWA, hasExpandedContents: false),
                ));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          children: [
            Container(
              margin: const EdgeInsets.only(top: 23),
              child: Center(
                child: TextTypography(
                    type: TextType.HEADER,
                    text: "Lengkapi Data Akun Anda"
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Center(
                child: TextTypography(
                  type: TextType.DESCRIPTION,
                  text: "Lengkapi data diri berikut ini untuk menyelesaikan proses registrasi akun anda",
                  align: TextAlign.center,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "Status Awal"
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 15),
                child: DropdownFilter(
                    onChanged: (String? value) {
                      setState(() {
                        if (value != null) {
                          _statusSiswa = value;
                        }
                      });
                    },
                    content: _statusSiswa,
                    items: statusSiswaList
                )
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "Tahun Masuk"
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 15),
                child: TextInputCustom(
                  controller: tahunController,
                  hint: "Tahun",
                  type: TextInputCustomType.WITH_ICON,
                  icon: Icons.date_range,
                )
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "Tingkat Kelas"
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 15),
                child: DropdownFilter(
                    onChanged: (String? value) {
                      setState(() {
                        if (value != null) {
                          _tingkatSiswa = value;
                        }
                      });
                    },
                    content: _tingkatSiswa,
                    items: tingkatKelasList
                )
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "Rombel Kelas"
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 15),
                child: TextInputCustom(
                  controller: rombelController,
                  hint: "Rombel Kelas",
                  type: TextInputCustomType.WITH_ICON,
                  icon: Icons.class_rounded,
                )
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton(
                      onPressed: () {
                        submitWarningDialog(2);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.all(20)),
                      child: TextTypography(
                        type: TextType.DESCRIPTION,
                        text: "Lewati",
                        color: green,
                      )),
                  ButtonWidget(
                    background: green,
                    tint: white,
                    type: ButtonType.LARGE,
                    content: "Simpan",
                    onPressed: () {
                      submitWarningDialog(1);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onWillPop: () async {
        backWarningDialog();
        return false;
      },
    );
  }

}