import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/screen/navigations.dart';
import 'package:non_cognitive/utils/user_type.dart';

class CompleteTeacherInfo extends StatefulWidget {
  const CompleteTeacherInfo({super.key});

  @override
  State<CompleteTeacherInfo> createState() => _CompleteTeacherInfo();

}

class _CompleteTeacherInfo extends State<CompleteTeacherInfo> {
  final List<String> statusGuruList = ["Guru Tetap", "Guru Honorer"];

  final List<String> mapelList = [
    "Pendidikan Agama dan Budi Pekerti",
    "Pendidikan Pancasila dan Kewarganegaraan",
    "Bahasa Indonesia",
    "Matematika",
    "Ilmu Pengetahuan Alam",
    "Ilmu Pengetahuan Sosial",
    "Bahasa Inggris",
    "Seni Budaya dan Prakarya",
    "Bahasa Daerah",
    "Pendidikan Jasmani, Olahraga dan Kesehatan",
    "Bimbingan dan Konseling"
  ];

  String _ahliMapel = "Pendidikan Agama dan Budi Pekerti";
  String _statusKerja = "Guru Tetap";

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
            // Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(
            //       builder: (context) => const Navigations(type: UserType.GURU, hasExpandedContents: false),
            //     ));
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
            // Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(
            //       builder: (context) => const Navigations(type: UserType.GURU, hasExpandedContents: false),
            //     ));
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
                  text: "Status Ikatan Kerja"
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 15),
                child: DropdownFilter(
                    onChanged: (String? value) {
                      setState(() {
                        if (value != null) {
                          _statusKerja = value;
                        }
                      });
                    },
                    content: _statusKerja,
                    items: statusGuruList
                )
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "Spesialisasi Mapel"
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 15),
                child: DropdownFilter(
                    onChanged: (String? value) {
                      setState(() {
                        if (value != null) {
                          _ahliMapel = value;
                        }
                      });
                    },
                    content: _ahliMapel,
                    items: mapelList
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