import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/radio_button.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final idNumberController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  String _userType = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        children: [
          Container(
            margin: const EdgeInsets.only(top: 23),
            child: Center(
              child: TextTypography(
                type: TextType.HEADER,
                text: "SELAMAT DATANG KEMBALI!"
              ),
            ),
          ),
          Image.asset("assets/images/logo_sementara_resize.png",
              width: 300, height: 200, fit: BoxFit.contain),
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextInputCustom(
                controller: idNumberController,
                hint: "NIS atau NIP",
                type: TextInputCustomType.WITH_ICON,
                icon: Icons.mail,
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
            child: TextInputCustom(
              controller: passwordController,
              hint: "Password",
              type: TextInputCustomType.WITH_ICON,
              icon: Icons.key,
            )
          ),
          Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextTypography(
                  type: TextType.DESCRIPTION,
                  text: "Anda adalah seorang"
              ),
          ),
          Container(
            height: 30,
            margin: const EdgeInsets.only(top: 15),
            child: RadioButton(
              type: RadioType.HORIZONTAL,
              choiceList: const <String>["Siswa", "Guru"],
              onSelectedChoice: (value) {
                _userType = value!;
              },
            )
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 8),
            child: ButtonWidget(
              type: ButtonType.LARGE_WIDE,
              background: green,
              tint: white,
              content: "Daftar",
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                        color: gray,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"),
                    children: [
                      const TextSpan(
                          text: "Sudah punya akun? "),
                      TextSpan(
                          text: "Login",
                          style: TextStyle(color: green),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {

                            })
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}