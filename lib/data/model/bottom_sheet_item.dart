import 'package:flutter/material.dart';

class BottomSheetCustomItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  BottomSheetCustomItem({required this.icon, required this.title, required this.onTap, this.color});
}