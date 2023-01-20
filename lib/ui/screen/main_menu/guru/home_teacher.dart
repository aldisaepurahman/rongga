import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({super.key});

  @override
  _TeacherHome createState() => _TeacherHome();
}

class _TeacherHome extends State<TeacherHome> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: TextTypography(
            type: TextType.DESCRIPTION,
            text: "Ini page utama guru",
          ),
        )
      ],
    );
  }

}