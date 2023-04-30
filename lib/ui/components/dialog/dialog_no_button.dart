import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/ui/components/core/color.dart';

class DialogNoButton extends StatelessWidget {
  final String content;
  final String path_image;

  const DialogNoButton({
    super.key,
    required this.content,
    required this.path_image
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 150,
        padding: EdgeInsets.all(50),
        height: 360,
        child: Column(
          children: [
            Expanded(
                child: Center(
                    child: Lottie.asset(path_image,
                        repeat: true, animate: true, reverse: false))),
            const SizedBox(height: 35),
            Text(
              textAlign: TextAlign.center,
              content,
              style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}