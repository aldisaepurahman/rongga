import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/color.dart';

enum TextInputCustomType { NORMAL, WITH_ICON }

class TextInputCustom extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputCustomType type;
  final IconData? icon;

  const TextInputCustom(
      {super.key,
      required this.controller,
      required this.hint,
      required this.type,
      this.icon});

  @override
  TextInputState createState() => TextInputState();
}

class TextInputState extends State<TextInputCustom> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlignVertical: TextAlignVertical.bottom,
      controller: widget.controller,
      style: const TextStyle(
        fontSize: 13,
        fontFamily: "Poppins"
      ),
      cursorColor: gray,
      decoration: widget.type == TextInputCustomType.WITH_ICON
          ? InputDecoration(
              fillColor: white,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: gray,
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
              prefixIcon: SizedBox(
                child: Icon(widget.icon),
              ))
          : InputDecoration(
              fillColor: white,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: gray,
                fontSize: 13,
                fontFamily: 'Poppins',
              )),
    );
  }
}
