import 'package:flutter/cupertino.dart';

enum TextType { HEADER, DESCRIPTION, DESCRIPTION_SPAN, TITLE }

class TextTypography extends StatelessWidget {
  final TextType type;
  final String text;
  final String? jumbleText;

  TextTypography(
      {Key? key,
      required this.type,
      required this.text,
      this.jumbleText})
      : super(key: key);

  Map<TextType, double> fontSize = {
    TextType.HEADER: 20,
    TextType.DESCRIPTION: 14,
    TextType.TITLE: 16
  };

  @override
  Widget build(BuildContext context) {
    if (type == TextType.DESCRIPTION_SPAN) {
      return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: text,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins"
                )
              ),
              TextSpan(
                text: jumbleText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: "Poppins"
                )
              )
            ]
          )
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize[type],
        fontFamily: "Poppins",
        fontWeight: type == TextType.DESCRIPTION ? FontWeight.normal : FontWeight.bold
      ),
    );
  }
}
