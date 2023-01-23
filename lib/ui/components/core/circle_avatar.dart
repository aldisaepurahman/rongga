import 'package:flutter/material.dart';

class CircleAvatarCustom extends StatelessWidget {
  final String image;
  final double radius;

  const CircleAvatarCustom(
      {super.key, required this.image, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: radius,
      backgroundImage: AssetImage(image.isNotEmpty ? image : "assets/images/no_image.png"),
    );
  }

}