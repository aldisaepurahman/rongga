import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/sidebar_menu_item.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/screen/auth/auth.dart';
import 'package:non_cognitive/ui/screen/main_menu/admin_sekolah/admin_rombel_list.dart';
import 'package:non_cognitive/ui/screen/main_menu/admin_sekolah/admin_tahun_ajaran.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/home_teacher.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/search_student.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/teacher_profile.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru_bk/create_rombel.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/home_student.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/search_teacher.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/student_profile.dart';
import 'package:non_cognitive/ui/screen/main_menu/wali_kelas/rombel_check.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SidebarMenuCustom extends StatefulWidget {
  final SidebarMenuItem item;
  final String menu_name;
  final bool isMobilePage;
  final UserType type;

  const SidebarMenuCustom({super.key, required this.item, required this.isMobilePage, required this.menu_name, required this.type});

  @override
  State<StatefulWidget> createState() => _SidebarMenuCustom();
}

class _SidebarMenuCustom extends State<SidebarMenuCustom> {
  var _iconColor = white;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _clearSession() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove("user");
  }

  void logoutWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content:
          "Kamu harus login ulang jika ingin masuk ke akunmu kembali. Kamu yakin?",
          path_image: "assets/images/caution.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            _clearSession();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AuthenticatePage(onboard: false))
            );
          },
        );
      },
    );
  }

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
        child: InkWell(
          onTap: widget.item.name != widget.menu_name ? changePage(widget.type, widget.item.name) : () {},
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
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold
                    ),
                  )
                ] else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ));
  }

  VoidCallback changePage(UserType type, String menu_name) {
    if (type == UserType.SISWA) {
      if (menu_name == "Beranda") {
        return () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>
                  StudentHome(type: type, expandedContents: false))
          );
        };
      }
      else if (menu_name == "Cari Guru") {
        return () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SearchTeacher())
          );
        };
      }
      else if (menu_name == "Profil") {
        return () {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => StudentProfile(userType: type))
          );
        };
      }
    } else if (type == UserType.GURU || type == UserType.GURU_BK || type == UserType.WALI_KELAS || type == UserType.GURU_BK_WALI_KELAS) {
      if (menu_name == "Beranda") {
        return () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>
                  TeacherHome(type: type))
          );
        };
      } else if (menu_name == "Cari Siswa") {
        return () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SearchStudent(type: type))
          );
        };
      }
      else if (menu_name == "Profil") {
        return () {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => TeacherProfile(type: type))
          );
        };
      }
      else if (menu_name == "Buat Rombel") {
        return () {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => CreateRombel(type: type, extendedContents: false))
          );
        };
      }
      /*else if (menu_name == "Rombel Saya") {
        return () {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => RombelCheck(type: type))
          );
        };
      }*/
    } else if (type == UserType.ADMIN) {
      if (menu_name == "Beranda") {
        return () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>
                  TeacherHome(type: type))
          );
        };
      } else if (menu_name == "Tahun Ajaran") {
        return () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AdminTahunAjaran())
          );
        };
      } else if (menu_name == "Rombel Sekolah") {
        return () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AdminRombelList())
          );
        };
      }
    }

    return () {
      logoutWarningDialog();
    };
  }

}