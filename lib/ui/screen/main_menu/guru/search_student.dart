import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class SearchStudent extends StatefulWidget {
  const SearchStudent({super.key});

  @override
  _SearchStudent createState() => _SearchStudent();
}

class _SearchStudent extends State<SearchStudent> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: TextTypography(
            type: TextType.DESCRIPTION,
            text: "Ini page search siswa",
          ),
        )
      ],
    );
  }

}