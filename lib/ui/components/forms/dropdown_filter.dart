import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/color.dart';

class DropdownFilter extends StatelessWidget {
  final List<String> items;
  final Function(String?) onChanged;
  final String content;

  const DropdownFilter(
      {Key? key,
        required this.onChanged,
        required this.content,
        required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: lightGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: DropdownButton(
            value: content,
            isExpanded: true,
            underline: SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  value,
                  maxLines: 1,
                  style: TextStyle(
                    color: gray,
                    fontFamily: 'Poppins')),
              );
            }).toList(),
            onChanged: onChanged,
          )),
    );
  }
}