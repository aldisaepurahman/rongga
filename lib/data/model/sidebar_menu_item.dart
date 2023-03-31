import 'package:flutter/cupertino.dart';

class SidebarMenuItem {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  SidebarMenuItem(this.name, this.icon, this.onTap);
}