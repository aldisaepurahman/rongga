import 'package:flutter/cupertino.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/ui/components/chart/pie.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class StatisticsCard extends StatelessWidget {
  final StudentStyle student_style;
  const StatisticsCard({super.key, required this.student_style});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: TextTypography(
              type: TextType.HEADER,
              text: "Statistik Gaya Belajar",
            ),
          ),
          /*TextTypography(
            type: TextType.DESCRIPTION,
            text: student_style.name!,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextTypography(
              type: TextType.DESCRIPTION,
              text: student_style.nis!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextTypography(
              type: TextType.DESCRIPTION_SPAN,
              text: "Gaya belajar anda adalah ",
              jumbleText: student_style.learningStyle!,
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Pie(visual_score: student_style.visual_score!, auditorial_score: student_style.auditorial_score!, kinestetik_score: student_style.kinestetik_score!,)
          )
        ],
      )
    );
  }

}