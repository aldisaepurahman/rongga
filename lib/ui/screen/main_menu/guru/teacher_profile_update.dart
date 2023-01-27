import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/bottom_sheet_item.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/circle_avatar.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/bottom_sheet.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/radio_button.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';
import 'package:non_cognitive/ui/screen/main_menu/change_password.dart';

class TeacherProfileUpdate extends StatefulWidget {
  const TeacherProfileUpdate({super.key});

  @override
  State<StatefulWidget> createState() => _TeacherProfileUpdate();
}

class _TeacherProfileUpdate extends State<TeacherProfileUpdate> {
  /*final Map<String, int> tingkatKelasOpt = {
    "VII (Tujuh)": 7,
    "VIII (Delapan)": 8,
    "IX (Sembilan)": 9,
  };*/

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

  late List<BottomSheetCustomItem> bottom_sheet_profile_list = <BottomSheetCustomItem>[];

  final idNumberController = TextEditingController(text: "198242749");
  final nameController = TextEditingController(text: "Rahman Aji");
  final emailController = TextEditingController(text: "ajirahman@gmail.com");
  String _genderType = "Laki-laki";
  final telpController = TextEditingController(text: "0895635117001");
  final addressController = TextEditingController(text: "Jl. Nusa Persada Jakarta");
  String _ahliMapel = "Pendidikan Agama dan Budi Pekerti";
  String _statusKerja = "Guru Tetap";

  void backWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content: "Perubahan yang anda inginkan tidak akan tersimpan. Anda yakin akan membatalkan perubahan ini?",
          path_image: "assets/images/caution.json",
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
  void initState() {
    super.initState();

    bottom_sheet_profile_list = [
      BottomSheetCustomItem(
        icon: Icons.photo,
        title: "Ambil Gambar dari Galeri",
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      BottomSheetCustomItem(
        icon: Icons.camera_alt,
        title: "Ambil Gambar dari Camera",
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      BottomSheetCustomItem(
          icon: Icons.delete_outline,
          title: "Hapus Foto Profil",
          onTap: () {
            Navigator.of(context).pop();
          },
          color: red
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: "Update Profil",
        useBackButton: true,
        onBackPressed: () {
          backWarningDialog();
        },
      ),
      body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatarCustom(
                      image: "",
                      radius: 50),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: ButtonWidget(
                        background: green,
                        tint: white,
                        type: ButtonType.FLOAT,
                        icon: Icons.camera_alt,
                        miniButton: true,
                        onPressed: () {
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
                      )
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "NIS (Nomor Induk Siswa)"
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextInputCustom(
                controller: idNumberController,
                hint: "NIS atau NIP",
                type: TextInputCustomType.WITH_ICON,
                icon: Icons.numbers,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "Nama Lengkap"
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 15),
                child: TextInputCustom(
                  controller: nameController,
                  hint: "Nama Lengkap",
                  type: TextInputCustomType.WITH_ICON,
                  icon: Icons.person,
                )
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "Email"
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 15),
                child: TextInputCustom(
                  controller: emailController,
                  hint: "Email",
                  type: TextInputCustomType.WITH_ICON,
                  icon: Icons.email,
                )
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "Jenis Kelamin Anda"
              ),
            ),
            Container(
                height: 30,
                margin: const EdgeInsets.only(top: 15),
                child: RadioButton(
                  type: RadioType.HORIZONTAL,
                  choiceList: const <String>["Laki-laki", "Perempuan"],
                  selectedChoice: _genderType,
                  onSelectedChoice: (value) {
                    _genderType = value!;
                  },
                )
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "No. Telepon"
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 15),
                child: TextInputCustom(
                  controller: telpController,
                  hint: "No. Telepon",
                  type: TextInputCustomType.WITH_ICON,
                  icon: Icons.phone,
                )
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "Alamat"
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 15),
                child: TextInputCustom(
                  controller: addressController,
                  hint: "Alamat",
                  type: TextInputCustomType.WITH_ICON,
                  icon: Icons.location_on,
                )
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"),
                    children: [
                      TextSpan(
                          text: "Lupa password anda?",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const ChangePassword())
                              );
                            })
                    ]),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 25),
                child: TextTypography(
                    type: TextType.TITLE,
                    text: "Status Guru"
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
          ]
      ),
      floatingActionButton: ButtonWidget(
        background: orange,
        tint: black,
        type: ButtonType.FLOAT,
        icon: Icons.save,
        onPressed: () {
          submitWarningDialog();
        },
      ),
    );
  }

}