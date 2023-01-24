import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/circle_avatar.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/radio_button.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';

class StudentProfileUpdate extends StatefulWidget {
  const StudentProfileUpdate({super.key});

  @override
  State<StatefulWidget> createState() => _StudentProfileUpdate();
}

class _StudentProfileUpdate extends State<StudentProfileUpdate> {
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

  final idNumberController = TextEditingController(text: "198242749");
  final nameController = TextEditingController(text: "Rahman Aji");
  final emailController = TextEditingController(text: "ajirahman@gmail.com");
  String _genderType = "Laki-laki";
  final telpController = TextEditingController(text: "0895635117001");
  final addressController = TextEditingController(text: "Jl. Nusa Persada Jakarta");
  final tahunController = TextEditingController(text: "2022");
  final rombelController = TextEditingController(text: "7C");
  String _statusSiswa = "Peserta didik baru";
  String _tingkatSiswa = "VII (Tujuh)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: "Update Profil",
        useBackButton: true,
        onBackPressed: () {
          Navigator.of(context).pop();
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
                        onPressed: () {},
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
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 25),
              child: TextTypography(
                  type: TextType.TITLE,
                  text: "Status Siswa"
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
                hint: "Tahun Masuk",
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
        ]
      ),
      floatingActionButton: ButtonWidget(
        background: orange,
        tint: black,
        type: ButtonType.FLOAT,
        icon: Icons.save,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

}