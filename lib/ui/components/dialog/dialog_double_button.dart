import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class DialogDoubleButton extends StatelessWidget {
  final String title;
  final String content;
  final String path_image;
  final String buttonLeft;
  final String buttonRight;
  final VoidCallback? onPressedButtonLeft;
  final VoidCallback? onPressedButtonRight;

  const DialogDoubleButton(
      {super.key,
        required this.title,
        required this.content,
        required this.path_image,
        required this.buttonLeft,
        required this.buttonRight,
        required this.onPressedButtonLeft,
        required this.onPressedButtonRight});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 320,
        height: 350,
        child: Column(
          children: [
            Expanded(
                child: Center(
                    child: Lottie.asset(path_image,
                        repeat: true, animate: true, reverse: false))),
            const SizedBox(height: 25),
            TextTypography(
                type: TextType.TITLE,
                text: title,
              align: TextAlign.center,
            ),
            const SizedBox(height: 15),
            TextTypography(
              type: TextType.DESCRIPTION,
              text: content,
              align: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                    onPressed: onPressedButtonLeft,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(20)),
                    child: TextTypography(
                      type: TextType.DESCRIPTION,
                      text: buttonLeft,
                      color: skyBlue,
                    )),
                ButtonWidget(
                    background: skyBlue,
                    tint: white,
                    type: ButtonType.LARGE,
                    content: buttonRight,
                    onPressed: onPressedButtonRight
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}