import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/navigation/sidebar_menu.dart';
import 'package:non_cognitive/utils/menu_list.dart';
import 'package:non_cognitive/utils/user_type.dart';

class SidebarCustom extends StatefulWidget {
  final UserType type;
  final String menu_name;

  const SidebarCustom({super.key, required this.type, required this.menu_name});

  @override
  State<StatefulWidget> createState() => _SidebarCustom();
}

class _SidebarCustom extends State<SidebarCustom> {
  @override
  Widget build(BuildContext context) {
    final _showMobile = MediaQuery.of(context).size.width < screenMd;

    return Container(
      decoration: BoxDecoration(color: skyBlue),
      width: _showMobile ? 70 : 220,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: _showMobile ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: lightGray),
            width: 45,
            height: 45,
            child: Center(
              child: TextTypography(type: TextType.HEADER, text: "C")
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.type == UserType.SISWA
                  ? studentMenu.map((e) => SidebarMenuCustom(item: e, isMobilePage: _showMobile, menu_name: widget.menu_name)).toList()
                  : widget.type == UserType.GURU_BK
                    ? guruBKMenu.map((e) => SidebarMenuCustom(item: e, isMobilePage: _showMobile, menu_name: widget.menu_name)).toList()
                    : widget.type == UserType.WALI_KELAS
                      ? waliKelasMenu.map((e) => SidebarMenuCustom(item: e, isMobilePage: _showMobile, menu_name: widget.menu_name)).toList()
                      : widget.type == UserType.GURU
                        ? guruMapelMenu.map((e) => SidebarMenuCustom(item: e, isMobilePage: _showMobile, menu_name: widget.menu_name)).toList()
                        : adminMenu.map((e) => SidebarMenuCustom(item: e, isMobilePage: _showMobile, menu_name: widget.menu_name)).toList(),
              )
          )
        ],
      ),
    );
  }

}