import 'package:flutter/cupertino.dart';
import 'package:non_cognitive/data/model/question_item.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class FamilyCard extends StatelessWidget {
  final List<QuestionItem> items;
  const FamilyCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
        child: Column(
          children: [
            TextTypography(
              type: TextType.TITLE,
              text: "Kondisi Keluarga",
            ),
            for (var item in items)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextTypography(
                  type: TextType.DESCRIPTION_SPAN,
                  text: item.question,
                  jumbleText: item.groupValue == "Lainnya" ? item.alternativeValue : item.groupValue,
                ),
              ),
          ],
        )
    );
  }

}