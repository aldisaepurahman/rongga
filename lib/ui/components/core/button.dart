import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/color.dart';

enum ButtonType { SMALL, MEDIUM, LARGE, LARGE_WIDE, OUTLINED, OUTLINED_SMALL, FLOAT, BACK, ICON_ONLY }

class ButtonWidget extends StatelessWidget {
  final Color background;
  final Color tint;
  final VoidCallback? onPressed;
  final ButtonType type;
  final String content;
  final IconData? icon;
  final bool? miniButton;

  const ButtonWidget({
    super.key,
    required this.background,
    required this.tint,
    required this.type,
    required this.onPressed,
    this.content = "",
    this.icon,
    this.miniButton
  });

  @override
  Widget build(BuildContext context) {
    if (type == ButtonType.OUTLINED || type == ButtonType.OUTLINED_SMALL) {
      return OutlinedButton(
          style: OutlinedButton.styleFrom(
              foregroundColor: tint,
              backgroundColor: white,
              minimumSize: type == ButtonType.OUTLINED_SMALL ? const Size(60, 30) : const Size(60, 45),
              side: BorderSide(color: background, width: 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: onPressed,
          child: Text(
            content,
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),
          ));
    } else if (type == ButtonType.FLOAT) {
      return FloatingActionButton(
        heroTag: null,
        mini: miniButton ?? false,
        onPressed: onPressed,
        backgroundColor: background,
        foregroundColor: tint,
        child: Icon(icon),
      );
    } else if (type == ButtonType.BACK) {
      return Container(
        decoration: BoxDecoration(
          color: tint,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: background,
          ),
          onPressed: onPressed,
          icon: const Icon(Icons.arrow_back_rounded),
          iconSize: 25,
        ),
      );
    } else if (type == ButtonType.ICON_ONLY) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: background,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              minimumSize: const Size(45, 45)
          ),
          onPressed: onPressed,
          child: Icon(icon, color: tint)
      );
    }

    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: background,
            foregroundColor: tint,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            minimumSize: type == ButtonType.SMALL
                ? const Size(60, 30)
                : type == ButtonType.LARGE
                    ? const Size(60, 50)
                    : type == ButtonType.LARGE_WIDE
                        ? const Size.fromHeight(50)
                        : const Size(60, 45)),
        child: Text(
          content,
          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),
        ));
  }
}
