import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/sidebar_menu_item.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/screen/auth/auth.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/home_teacher.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/search_student.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/teacher_profile.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/home_student.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/search_teacher.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/student_profile.dart';
import 'package:non_cognitive/utils/user_type.dart';

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
    } else if (widget.type == UserType.GURU || widget.type == UserType.GURU_BK || widget.type == UserType.WALI_KELAS) {
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
    }

    return () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthenticatePage())
      );
    };
  }

}