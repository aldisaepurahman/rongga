import 'package:flutter/cupertino.dart';
import 'package:non_cognitive/ui/components/chart/bar.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class PsychologyCard extends StatelessWidget {
  final String title;
  final String chartTitle;
  final String description;
  const PsychologyCard({super.key, required this.title, required this.chartTitle, required this.description});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        children: [
          TextTypography(
            type: TextType.TITLE,
            text: title,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextTypography(
              type: TextType.DESCRIPTION,
              text: description,
              align: TextAlign.justify,
            ),
          ),
          /*Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: TextTypography(
                  type: TextType.TITLE,
                  text: chartTitle,
                ),
              )
          ),
          const SizedBox(height: 10),
          const Expanded(child: Bar())*/
        ],
      ),
    );
  }

}