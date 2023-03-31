import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/sidebar_menu_item.dart';
import 'package:non_cognitive/ui/components/core/color.dart';

class SidebarMenuCustom extends StatefulWidget {
  final SidebarMenuItem item;
  final String menu_name;
  final bool isMobilePage;

  const SidebarMenuCustom({super.key, required this.item, required this.isMobilePage, required this.menu_name});

  @override
  State<StatefulWidget> createState() => _SidebarMenuCustom();
}

class _SidebarMenuCustom extends State<SidebarMenuCustom> {
  var _iconColor = white;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (e) {
          setState(() {
            _iconColor = orange;
          });
        },
        onExit: (e) {
          setState(() {
            _iconColor = white;
          });
        },
        child: Container(
          width: widget.isMobilePage ? 44 : null,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: widget.isMobilePage
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                widget.item.icon,
                size: 20,
                color: widget.item.name == widget.menu_name ? orange : _iconColor,
              ),
              if (!widget.isMobilePage) ...[
                const SizedBox(width: 16),
                Text(
                  widget.item.name,
                  style: TextStyle(
                    color: widget.item.name == widget.menu_name ? orange : _iconColor,
                  ),
                )
              ] else
                const SizedBox.shrink(),
            ],
          ),
        ));
  }

}