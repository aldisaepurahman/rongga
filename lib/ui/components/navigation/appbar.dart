import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/color.dart';

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
            onPressed: () {},
            icon: const Icon(Icons.logout)
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);

}