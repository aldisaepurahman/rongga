import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_cognitive/data/bloc/auth/auth_bloc.dart';
import 'package:non_cognitive/data/bloc/auth/auth_event.dart';
import 'package:non_cognitive/data/bloc/auth/login_bloc.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/data/model/users.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_no_button.dart';
import 'package:non_cognitive/ui/components/dialog/loading_dialog.dart';
import 'package:non_cognitive/ui/components/forms/radio_button.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/screen/auth/register.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/home_teacher.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/home_student.dart';
import 'package:non_cognitive/ui/screen/navigations.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final bool isMobilePage;
  final VoidCallback onTextClicked;

  const Login(
      {super.key, required this.isMobilePage, required this.onTextClicked});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final idNumberController = TextEditingController();
  final passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isSubmitted = false;

  Future<void> _saveSession(Map<String, Object> user) async {
    final SharedPreferences prefs = await _prefs;
    var users;

    if (user["type"] == 0) {
      users = user["user_data"] as Users;
    } else if (user["type"] == 1) {
      users = user["user_data"] as Student;
    } else {
      users = user["user_data"] as Teacher;
    }

    prefs.setString("user", jsonEncode(users.toLocalJson()));
  }

  void showSubmitDialog(int dialogType, Users? user) {
    String imgPath = (dialogType > 1)
        ? (dialogType == 2)
            ? "assets/images/happy-student-success.json"
            : "assets/images/learn-incorrect.json"
        : "assets/images/loading_icon.json";
    String content = (dialogType > 1)
        ? (dialogType == 2)
            ? "Hai, Kau Berhasil Masuk!"
            : "Duh, loginnya gagal, coba cek lagi nomor induk dan passwordnya ya!"
        : "";

    showDialog(
      context: context,
      builder: (context) {
        if (dialogType == 2) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<LoginBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            if (user?.type == UserType.SISWA) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const StudentHome(
                      type: UserType.SISWA, expandedContents: false)));
            } else {
              var type = user?.type;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TeacherHome(type: type!)));
            }
          });
        } else if (dialogType == 3) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<LoginBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        }
        if (dialogType > 1) {
          return DialogNoButton(path_image: imgPath, content: content);
        }
        return LoadingDialog(path_image: imgPath);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        children: [
          const SizedBox(height: 50),
          Image.asset("assets/images/rongga-logo-blue.png",
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
              )),
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
                  isSubmitted = !isSubmitted;
                  BlocProvider.of<LoginBloc>(context).add(AuthLogin(
                      no_induk: idNumberController.text,
                      password: passwordController.text));
                  /*Fluttertoast.showToast(
                      msg: "Login sukses",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 12.0);
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TeacherHome(type: UserType.GURU) //StudentHome(type: UserType.SISWA, expandedContents: false)
                      )
                  );*/
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
                      const TextSpan(text: "Belum punya akun? "),
                      TextSpan(
                          text: "Daftar",
                          style: TextStyle(color: green),
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onTextClicked)
                    ]),
              ),
            ),
          ),
          BlocConsumer<LoginBloc, RonggaState>(
            listener: (_, state) {},
            builder: (_, state) {
              if (state is LoadingState) {
                if (isSubmitted) {
                  Future.delayed(const Duration(seconds: 1), () {
                    showSubmitDialog(1, Users());
                  });
                }
              } else if (state is FailureState) {
                isSubmitted = !isSubmitted;
                print(state.error);
                Future.delayed(const Duration(seconds: 1), () {
                  showSubmitDialog(3, Users());
                });
              } else if (state is SuccessState) {
                isSubmitted = !isSubmitted;
                if (state.datastore.isNotEmpty) {
                  _saveSession(state.datastore);
                  Future.delayed(const Duration(seconds: 1), () {
                    showSubmitDialog(2, state.datastore["user_data"]);
                  });
                } else {
                  print(state.datastore);
                  Future.delayed(const Duration(seconds: 1), () {
                    showSubmitDialog(3, Users());
                  });
                }
              }
              return const SizedBox(width: 0);
            },
          )
        ],
      ),
    );
  }
}
