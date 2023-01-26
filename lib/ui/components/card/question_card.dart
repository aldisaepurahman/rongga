import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_cognitive/data/model/question_item.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/radio_button.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';

import '../core/color.dart';

class QuestionCard extends StatefulWidget {
  final QuestionItem question;
  final ValueChanged<String?> onSelectedChoice;
  final ValueChanged<String?> onAlternativeFilled;

  const QuestionCard({super.key, required this.question, required this.onSelectedChoice, required this.onAlternativeFilled});

  @override
  QuestionCardState createState() => QuestionCardState();

}

class QuestionCardState extends State<QuestionCard> {
  final alternativeController = TextEditingController();
  bool isAlternativeVisible = false;

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
            selectedChoice: widget.question.groupValue,
            onSelectedChoice: (value) {
              widget.question.groupValue = value!;
              widget.onSelectedChoice(widget.question.groupValue);
              setState(() {
                if (widget.question.groupValue == "Lainnya") {
                  isAlternativeVisible = true;
                } else {
                  isAlternativeVisible = false;
                }
              });
            },
          ),
          Visibility(
            visible: isAlternativeVisible,
            child: TextInputCustom(
              controller: alternativeController,
              hint: "Masukkan nama suku anda",
              type: TextInputCustomType.NORMAL,
              onChanged: (value) {
                widget.onAlternativeFilled(value);
              },
            )
          )
        ],
      ),
    );
  }

}