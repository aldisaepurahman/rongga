import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/student_style.dart';

class RombelSiswa {
  int? id_siswa;
  String? name;
  StudentStyle style;
  String? level;
  Student? student;

  RombelSiswa(
      {this.id_siswa = 0,
      this.name = "",
      required this.style,
      this.level = "",
      this.student});

}
