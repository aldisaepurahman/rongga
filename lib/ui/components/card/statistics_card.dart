import 'package:flutter/cupertino.dart';
import 'package:non_cognitive/ui/components/chart/pie.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextTypography(
            type: TextType.DESCRIPTION,
            text: "Rahman Aji",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextTypography(
              type: TextType.DESCRIPTION,
              text: "1920178263",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextTypography(
              type: TextType.DESCRIPTION_SPAN,
              text: "Gaya belajar anda adalah ",
              jumbleText: "Kinestetik",
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Pie()
          )
        ],
      )
    );
  }

}