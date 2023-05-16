import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/auth/auth_bloc.dart';
import 'package:non_cognitive/data/bloc/auth/auth_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_no_button.dart';
import 'package:non_cognitive/ui/components/dialog/loading_dialog.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/auth/auth.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  final UserType type;
  final int id_user;

  const ChangePassword({super.key, required this.type, required this.id_user});

  @override
  State<StatefulWidget> createState() => _ChangePassword();

}

class _ChangePassword extends State<ChangePassword> {
  final newPassController = TextEditingController();
  final verifyPassController = TextEditingController();

  bool isSubmitted = false;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _clearSession() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove("user");
  }

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
            isSubmitted = true;
            validateAndSend();
          },
        );
      },
    );
  }

  void validateAndSend() async {
    if (newPassController.text.isNotEmpty &&
        verifyPassController.text.isNotEmpty &&
        newPassController.text == verifyPassController.text) {
      BlocProvider.of<AuthBloc>(context).add(
          AuthChangePassword(id_user: widget.id_user, password: newPassController.text));
    }
    else {
      showSubmitDialog(4);
    }
  }

  void showSubmitDialog(int dialogType) {
    String imgPath = (dialogType > 1)
        ? (dialogType == 2)
        ? "assets/images/success.json"
        : "assets/images/incorrect.json"
        : "assets/images/loading_icon.json";
    String content = (dialogType > 1)
        ? (dialogType == 2)
        ? "Hore, passwordmu sudah berhasil diperbarui. Coba login ulang agar akun berfungsi dengan baik."
        : "Duh, pastiin semua data terisi dan kedua kolom password sesuai ya."
        : "";

    showDialog(
      context: context,
      builder: (context) {
        if (dialogType == 2) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<AuthBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const AuthenticatePage(onboard: false)));
          });
        } else if (dialogType == 3) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<AuthBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 4) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<AuthBloc>(context).add(ResetEvent());
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
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(ResetEvent());
  }

  @override
  Widget build(BuildContext context) {
    final _showMobile = MediaQuery
        .of(context)
        .size
        .width < screenMd;

    return MainLayout(
        type: UserType.SISWA,
        menu_name: "Ganti Password",
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                            backWarningDialog();
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 25, left: 25, bottom: 15),
                    child: TextTypography(
                        text: "Ganti Password",
                        type: TextType.HEADER
                    ),
                  )
                ],
              ),
              _showMobile ? Center(
                child: TextTypography(
                  type: TextType.DESCRIPTION,
                  text: "Anda dapat mengubah password anda pada kolom inputan dibawah",
                  align: TextAlign.center,
                ),
              ) : TextTypography(
                type: TextType.DESCRIPTION,
                text: "Anda dapat mengubah password anda pada kolom inputan dibawah",
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
                    submitWarningDialog();
                    // Navigator.of(context).pop();
                  },
                ),
              ),
              BlocConsumer<AuthBloc, RonggaState>(
                listener: (_, state) {},
                builder: (_, state) {
                  if (state is LoadingState) {
                    if (isSubmitted) {
                      Future.delayed(const Duration(seconds: 1), () {
                        showSubmitDialog(1);
                      });
                    }
                  } if (state is FailureState) {
                    isSubmitted = !isSubmitted;
                    Future.delayed(const Duration(seconds: 1), () {
                      showSubmitDialog(3);
                    });
                  } if (state is CrudState) {
                    isSubmitted = !isSubmitted;
                    if (state.datastore) {
                      _clearSession();
                      Future.delayed(const Duration(seconds: 1), () {
                        showSubmitDialog(2);
                      });
                    } else {
                      Future.delayed(const Duration(seconds: 1), () {
                        showSubmitDialog(3);
                      });
                    }
                  }
                  return const SizedBox(width: 0);
                },
              )
            ]
        )
    );
  }

}