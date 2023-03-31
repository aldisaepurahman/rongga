import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/sidebar_menu_item.dart';

final List<SidebarMenuItem> studentMenu = [
  SidebarMenuItem("Beranda", Icons.home, () {}),
  SidebarMenuItem("Cari Guru", Icons.search, () {}),
  SidebarMenuItem("Profil", Icons.person, () {}),
  SidebarMenuItem("Keluar", Icons.logout, () {})
];

final List<SidebarMenuItem> guruBKMenu = [
  SidebarMenuItem("Beranda", Icons.home, () {}),
  SidebarMenuItem("Cari Siswa", Icons.search, () {}),
  SidebarMenuItem("Buat Rombel", Icons.group_work, () {}),
  SidebarMenuItem("Profil", Icons.person, () {}),
  SidebarMenuItem("Keluar", Icons.logout, () {})
];

final List<SidebarMenuItem> waliKelasMenu = [
  SidebarMenuItem("Beranda", Icons.home, () {}),
  SidebarMenuItem("Cari Siswa", Icons.search, () {}),
  SidebarMenuItem("Rombel Saya", Icons.group_work, () {}),
  SidebarMenuItem("Profil", Icons.person, () {}),
  SidebarMenuItem("Keluar", Icons.logout, () {})
];

final List<SidebarMenuItem> guruMapelMenu = [
  SidebarMenuItem("Beranda", Icons.home, () {}),
  SidebarMenuItem("Cari Siswa", Icons.search, () {}),
  SidebarMenuItem("Profil", Icons.person, () {}),
  SidebarMenuItem("Keluar", Icons.logout, () {})
];

final List<SidebarMenuItem> adminMenu = [
  SidebarMenuItem("Beranda", Icons.home, () {}),
  SidebarMenuItem("Tahun Ajaran", Icons.list, () {}),
  SidebarMenuItem("Rombel Sekolah", Icons.group_work, () {}),
  SidebarMenuItem("Keluar", Icons.logout, () {})
];