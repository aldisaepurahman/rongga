import 'package:flutter/cupertino.dart';
import 'package:non_cognitive/ui/components/core/color.dart';

enum BadgesType { KINESTETIK, VISUAL, AUDITORI }

extension BadgesExtension on BadgesType {
  Color get color {
    switch (this) {
      case BadgesType.KINESTETIK:
        return lightGreen;
      case BadgesType.VISUAL:
        return red;
      default:
        return blue;
    }
  }

  String get text {
    switch (this) {
      case BadgesType.KINESTETIK:
        return "Kinestetik";
      case BadgesType.VISUAL:
        return "Visual";
      default:
        return "Auditori";
    }
  }
}

class Badges extends StatelessWidget {
  final BadgesType type;

  const Badges({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: type.color
      ),
      constraints: const BoxConstraints(maxWidth: 100, maxHeight: 40),
      child: Text(
        type.text,
        style: TextStyle(
          color: white,
          fontSize: 13,
          fontFamily: "Poppins"
        ),
      ),
    );
  }

}