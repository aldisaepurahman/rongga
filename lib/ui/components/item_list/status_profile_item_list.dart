import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class StatusProfileItemList extends StatelessWidget {
  final String label;
  final String description;

  const StatusProfileItemList({super.key, required this.label, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
            width: 150,
            child: TextTypography(
              type: TextType.LABEL_TITLE,
              text: label,
            )
        ),
        SizedBox(
            width: 30,
            child: TextTypography(
              type: TextType.LABEL_TITLE,
              text: ":",
            )
        ),
        Expanded(
            child: TextTypography(
              type: TextType.DESCRIPTION,
              text: description,
            )
        ),
      ],
    );
  }

}