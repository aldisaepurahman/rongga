import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/ui/components/core/color.dart';

class LoadingDialog extends StatelessWidget {
  final String path_image;

  const LoadingDialog({
    super.key,
    required this.path_image
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(10),
        height: 60,
        child: Column(
          children: [
            Expanded(
                child: Center(
                    child: Lottie.asset(path_image,
                        repeat: true, animate: true, reverse: false)))
          ],
        ),
      ),
    );
  }
}