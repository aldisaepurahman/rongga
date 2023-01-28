import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/screen/auth/login.dart';

class AppBarCustom extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool useBackButton;
  final VoidCallback? onBackPressed;

  const AppBarCustom({super.key, required this.title, required this.useBackButton, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
          title,
        style: const TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold
        ),
      ),
      backgroundColor: skyBlue,
      foregroundColor: white,
      leading: Visibility(
        visible: useBackButton,
        child: BackButton(color: white, onPressed: onBackPressed),
      ),
      actions: [
        IconButton(
          tooltip: "Logout",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DialogDoubleButton(
                    title: "Tunggu Dulu!",
                    content: "Apa anda yakin ingin keluar dari akun anda?",
                    path_image: "assets/images/questionmark.json",
                    buttonLeft: "Tidak",
                    buttonRight: "Ya",
                    onPressedButtonLeft: () {
                      Navigator.of(context).pop();
                    },
                    onPressedButtonRight: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ));
                    },
                  );
                },
              );
            },
            icon: const Icon(Icons.logout)
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);

}