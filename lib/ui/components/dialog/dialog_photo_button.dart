import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class DialogPhotoButton extends StatelessWidget {
  final String title;
  final String content;
  final String path_image;
  final String buttonLeft;
  final String buttonRight;
  final String buttonBottom;
  final VoidCallback? onPressedButtonLeft;
  final VoidCallback? onPressedButtonRight;
  final VoidCallback? onPressedButtonBottom;

  const DialogPhotoButton(
      {super.key,
        required this.title,
        required this.content,
        required this.path_image,
        required this.buttonLeft,
        required this.buttonRight,
        required this.onPressedButtonLeft,
        required this.onPressedButtonRight,
        required this.buttonBottom,
        required this.onPressedButtonBottom});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 420,
        height: 450,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                ButtonWidget(
                    background: white,
                    tint: red,
                    type: ButtonType.OUTLINED,
                    content: buttonLeft,
                    onPressed: onPressedButtonLeft
                ),
                const SizedBox(height: 20),
                ButtonWidget(
                    background: red,
                    tint: white,
                    type: ButtonType.LARGE,
                    content: buttonRight,
                    onPressed: onPressedButtonRight
                ),
                const SizedBox(height: 20),
                ButtonWidget(
                    background: white,
                    tint: red,
                    type: ButtonType.OUTLINED,
                    content: buttonBottom,
                    onPressed: onPressedButtonBottom
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}