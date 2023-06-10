import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/model/nilai_akhir_input.dart';

class StudentOnSearch extends Events {
  final int id_sekolah;
  final String nama;
  final String rombel;

  StudentOnSearch({required this.id_sekolah, required this.nama, required this.rombel});
}

class TeacherUpdateProfile extends Events {
  final Map<String, dynamic> teacher;

  TeacherUpdateProfile({required this.teacher});
}

class StudentScoreExists extends Events {
  final Map<String, dynamic> criterias;

  StudentScoreExists({required this.criterias});
}

class StudentScoreInput extends Events {
  final List<NilaiAkhirInput> scores;

  StudentScoreInput({required this.scores});
}

class TeacherExcelCheck extends Events {
  final int id_sekolah;
  final int id_tahun_ajaran;
  final String tahun_ajaran;

  TeacherExcelCheck({required this.id_sekolah, required this.id_tahun_ajaran, required this.tahun_ajaran});
}

class StudentRombelSearch extends Events {
  final int wali_kelas;
  final int id_sekolah;
  final int id_tahun_ajaran;
  int? id_guru;
  int? tingkat;
  final String rombel;

  StudentRombelSearch({
    required this.wali_kelas,
    required this.id_sekolah,
    required this.id_tahun_ajaran,
    this.id_guru = 0,
    this.tingkat = 0,
    required this.rombel,
  });
}