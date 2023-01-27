import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/radio_button.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/screen/auth/complete_user_account.dart';
import 'package:non_cognitive/ui/screen/auth/login.dart';
import 'package:non_cognitive/utils/user_type.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final idNumberController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final verifyPasswordController = TextEditingController();
  String _userType = "";
  String _genderType = "";

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
                text: "SELAMAT DATANG!"
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
                controller: emailController,
                hint: "Email",
                type: TextInputCustomType.WITH_ICON,
                icon: Icons.email,
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
              child: TextInputCustom(
                controller: verifyPasswordController,
                hint: "Verifikasi Password Anda",
                type: TextInputCustomType.WITH_ICON,
                icon: Icons.key,
              )
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: TextTypography(
                type: TextType.LABEL_TITLE,
                text: "Jenis Kelamin"
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
                  text: "Anda adalah seorang"
              ),
          ),
          Container(
            height: 30,
            margin: const EdgeInsets.only(top: 15),
            child: RadioButton(
              type: RadioType.HORIZONTAL,
              choiceList: const <String>["Siswa", "Guru"],
              selectedChoice: _userType,
              onSelectedChoice: (value) {
                _userType = value!;
              },
            )
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: ButtonWidget(
              type: ButtonType.LARGE_WIDE,
              background: green,
              tint: white,
              content: "Daftar",
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const CompleteUserAccount(type: UserType.SISWA),
                    )
                );
                /*if (idNumberController.text.isNotEmpty &&
                nameController.text.isNotEmpty && passwordController.text.isNotEmpty &&
                    _userType.isNotEmpty) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      )
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: "Pastikan semua kolom inputan terisi",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 12.0);
                }*/
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
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
                          text: "Masuk",
                          style: TextStyle(color: green),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  )
                              );
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