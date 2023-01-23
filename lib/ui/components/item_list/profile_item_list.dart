import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class ProfileItemList extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;

  const ProfileItemList({super.key, required this.icon, required this.label, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.center,
          child: Icon(icon, size: 50, color: green),
        ),
        const SizedBox(width: 30),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextTypography(type: TextType.LABEL, text: label),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextTypography(
                  type: TextType.DESCRIPTION,
                  text: description,
                )
              ),
            ],
          )
        )
      ],
    );
  }

}