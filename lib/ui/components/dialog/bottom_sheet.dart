import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/bottom_sheet_item.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class BottomSheetCustom extends StatefulWidget {
  final List<BottomSheetCustomItem> items;
  const BottomSheetCustom({super.key, required this.items});

  @override
  State<StatefulWidget> createState() => _BottomSheetCustom();

}

class _BottomSheetCustom extends State<BottomSheetCustom> {

  List<Widget> _buildListItem() {
    List<Widget> listItem = [];

    for (var item in widget.items) {
      listItem.add(
        ListTile(
          leading: Icon(item.icon, color: item.color ?? black),
          title: TextTypography(
              type: TextType.LABEL_TITLE,
              text: item.title,
            color: item.color ?? black,
          ),
          onTap: item.onTap,
        )
      );
    }

    return listItem;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _buildListItem()
    );
  }

}