import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class SearchTeacher extends StatefulWidget {
  const SearchTeacher({super.key});

  @override
  _SearchTeacher createState() => _SearchTeacher();
}

class _SearchTeacher extends State<SearchTeacher> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: TextTypography(
            type: TextType.DESCRIPTION,
            text: "Ini page search guru",
          ),
        )
      ],
    );
  }

}