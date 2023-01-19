import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/color.dart';

class AppBarNavigation extends StatelessWidget {
  final String title;
  final bool useBackButton;

  const AppBarNavigation({super.key, required this.title, required this.useBackButton});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      backgroundColor: skyBlue,
      leading: Visibility(
        visible: useBackButton,
        child: BackButton(color: white),
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

}