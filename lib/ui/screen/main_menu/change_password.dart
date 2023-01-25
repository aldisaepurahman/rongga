import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePassword();

}

class _ChangePassword extends State<ChangePassword> {
  final newPassController = TextEditingController();
  final verifyPassController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: "Ganti Password",
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
              child: TextTypography(
                type: TextType.DESCRIPTION,
                text: "Anda dapat mengubah password anda pada kolom inputan dibawah",
                align: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "Masukkan Password Anda"
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextInputCustom(
                controller: newPassController,
                hint: "Password",
                type: TextInputCustomType.WITH_ICON,
                icon: Icons.key,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "Verifikasi Password Anda"
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextInputCustom(
                controller: verifyPassController,
                hint: "Password",
                type: TextInputCustomType.WITH_ICON,
                icon: Icons.key,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ButtonWidget(
                type: ButtonType.LARGE_WIDE,
                background: green,
                tint: white,
                content: "Simpan",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ]
      ),
    );
  }

}