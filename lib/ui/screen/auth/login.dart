import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/radio_button.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/screen/auth/register.dart';
import 'package:non_cognitive/ui/screen/navigations.dart';
import 'package:non_cognitive/utils/user_type.dart';

class Login extends StatefulWidget {
  final bool isMobilePage;
  final VoidCallback onTextClicked;
  const Login({super.key, required this.isMobilePage, required this.onTextClicked});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final idNumberController = TextEditingController();
  final passwordController = TextEditingController();

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
            margin: const EdgeInsets.only(top: 20),
            child: TextInputCustom(
              controller: idNumberController,
              hint: "NIS atau NIP",
              type: TextInputCustomType.WITH_ICON,
              icon: Icons.mail,
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child: TextInputCustom(
                controller: passwordController,
                hint: "Password",
                type: TextInputCustomType.WITH_ICON,
                icon: Icons.key,
              )
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: ButtonWidget(
              type: ButtonType.LARGE_WIDE,
              background: green,
              tint: white,
              content: "Masuk",
              onPressed: () {
                if (idNumberController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  Fluttertoast.showToast(
                      msg: "Login sukses",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 12.0);
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Navigations(
                            type: UserType.SISWA,
                            hasExpandedContents: false
                        ),
                      )
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: "Pastikan NIS atau NIP, serta Password sesuai.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 12.0);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                        color: gray,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"),
                    children: [
                      const TextSpan(
                          text: "Belum punya akun? "),
                      TextSpan(
                          text: "Daftar",
                          style: TextStyle(color: green),
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onTextClicked
                      )
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}