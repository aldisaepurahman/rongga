import 'package:flutter/cupertino.dart';
import 'package:non_cognitive/data/model/question_item.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/radio_button.dart';

import '../core/color.dart';

class QuestionCard extends StatefulWidget {
  final QuestionItem question;
  final ValueChanged<String?> onSelectedChoice;

  const QuestionCard({super.key, required this.question, required this.onSelectedChoice});

  @override
  QuestionCardState createState() => QuestionCardState();

}

class QuestionCardState extends State<QuestionCard> {

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextTypography(
            type: TextType.DESCRIPTION,
            text: widget.question.question,
          ),
          RadioButton(
            type: RadioType.VERTICAL,
            choiceList: widget.question.choices,
            onSelectedChoice: (value) {
              widget.question.groupValue = value!;
              widget.onSelectedChoice(widget.question.groupValue);
            },
          ),
        ],
      ),
    );
  }

}