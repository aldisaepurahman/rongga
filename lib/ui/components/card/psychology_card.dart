import 'package:flutter/cupertino.dart';
import 'package:non_cognitive/ui/components/chart/bar.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';

import '../core/color.dart';
import '../core/typography.dart';

class PsychologyCard extends StatelessWidget {
  final String title;
  final String chartTitle;
  const PsychologyCard({super.key, required this.title, required this.chartTitle});

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
              text: "Keterangan : Diagram di bawah ini dibentuk dari rata-rata"
                  "setiap dimensi kesejahteraan psikologi yang telah dipilih"
                  "siswa. Setiap jawaban pada setiap dimensi yang bernilai"
                  "\"selalu\" akan diberi poin 3, yang bernilai \"kadang-"
                  "kadang\" akan diberi poin 2, dan yang bernilai"
                  "\"tidak pernah\" diberi poin 1.",
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: TextTypography(
                  type: TextType.TITLE,
                  text: chartTitle,
                ),
              )
          ),
          const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Bar()
          )
        ],
      ),
    );
  }

}