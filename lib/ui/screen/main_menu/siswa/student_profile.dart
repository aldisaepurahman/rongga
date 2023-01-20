import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  _StudentProfile createState() => _StudentProfile();
}

class _StudentProfile extends State<StudentProfile> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: TextTypography(
            type: TextType.DESCRIPTION,
            text: "Ini page profile siswa",
          ),
        )
      ],
    );
  }

}