import 'package:flutter/cupertino.dart';
import 'package:non_cognitive/ui/components/core/color.dart';

enum TextType {
  SUPER_HEADER,
  HEADER,
  DESCRIPTION,
  DESCRIPTION_SPAN,
  MINI_DESCRIPTION,
  LABEL,
  LABEL_TITLE,
  TITLE
}

class TextTypography extends StatelessWidget {
  final TextType type;
  final String text;
  final String? jumbleText;
  final TextAlign? align;
  final Color? color;

  TextTypography(
      {Key? key,
      required this.type,
      required this.text,
      this.jumbleText,
      this.align,
      this.color})
      : super(key: key);

  Map<TextType, double> fontSize = {
    TextType.SUPER_HEADER: 24,
    TextType.HEADER: 20,
    TextType.DESCRIPTION: 14,
    TextType.TITLE: 16,
    TextType.LABEL: 12,
    TextType.LABEL_TITLE: 14,
    TextType.MINI_DESCRIPTION: 11,
  };

  @override
  Widget build(BuildContext context) {
    if (type == TextType.DESCRIPTION_SPAN) {
      return RichText(
          text: TextSpan(
              style: TextStyle(
                  fontSize: 14, fontFamily: "Poppins", color: color ?? black),
              children: [
            TextSpan(text: text),
            TextSpan(
                text: jumbleText,
                style: const TextStyle(fontWeight: FontWeight.bold))
          ]));
    }

    return Text(
      text,
      textAlign: align ?? TextAlign.start,
      style: TextStyle(
          fontSize: fontSize[type],
          fontFamily: "Poppins",
          color: color ?? black,
          fontWeight: type == TextType.DESCRIPTION
              ? FontWeight.normal
              : FontWeight.bold),
    );
  }
}
