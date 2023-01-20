import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class TeacherProfile extends StatefulWidget {
  const TeacherProfile({super.key});

  @override
  _TeacherProfile createState() => _TeacherProfile();
}

class _TeacherProfile extends State<TeacherProfile> {
  @override
  Widget build(BuildContext context) {
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
  }

}