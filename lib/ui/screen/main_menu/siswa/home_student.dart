import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/utils/user_type.dart';

class StudentHome extends StatefulWidget {
  final UserType type;
  final bool expandedContents;

  const StudentHome({super.key, required this.type, required this.expandedContents});

  @override
  _StudentHome createState() => _StudentHome();

}

class _StudentHome extends State<StudentHome> {
  @override
  Widget build(BuildContext context) {
    /*return SingleChildScrollView(
      child: SafeArea(
        child: (!widget.expandedContents)
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextTypography(
                  type: TextType.DESCRIPTION,
                  text: "Anda belum pernah melakukan tes sebelumnya\nSilahkan ikuti tes terlebih dahulu"
              ),
              ButtonWidget(
                  background: green,
                  tint: white,
                  type: ButtonType.LARGE,
                  content: "Ikuti Tes",
                  onPressed: () {},
              )
            ],
          ),
        ) : Column(
          children: [],
        ),
      ),
    );*/
    if (widget.type == UserType.GURU) {
      return ListView(
        children: [
          Center(
            child: TextTypography(
              type: TextType.DESCRIPTION,
              text: "Ini page profil guru",
            ),
          )
        ],
      );
    } else if (widget.expandedContents) {
      return ListView(
        children: [],
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextTypography(
              type: TextType.DESCRIPTION,
              text: "Anda belum pernah melakukan tes sebelumnya\nSilahkan ikuti tes terlebih dahulu"
          ),
          const SizedBox(height: 10),
          ButtonWidget(
            background: green,
            tint: white,
            type: ButtonType.LARGE,
            content: "Ikuti Tes",
            onPressed: () {},
          )
        ],
      ),
    );
  }

}