import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/model/nilai_akhir_input.dart';

class StudentOnSearch extends Events {
  final int id_sekolah;
  final String nama;
  final String rombel;
  final String token;

  StudentOnSearch({required this.id_sekolah, required this.nama, required this.rombel, required this.token});
}

class TeacherUpdateProfile extends Events {
  final Map<String, dynamic> teacher;
  final String token;

  TeacherUpdateProfile({required this.teacher, required this.token});
}

class StudentScoreExists extends Events {
  final Map<String, dynamic> criterias;
  final String token;

  StudentScoreExists({required this.criterias, required this.token});
}

class StudentScoreInput extends Events {
  final List<NilaiAkhirInput> scores;
  final String token;

  StudentScoreInput({required this.scores, required this.token});
}

class TeacherExcelCheck extends Events {
  final int id_sekolah;
  final int id_tahun_ajaran;
  final String tahun_ajaran;
  final String token;

  TeacherExcelCheck({required this.id_sekolah, required this.id_tahun_ajaran, required this.tahun_ajaran, required this.token});
}

class StudentRombelSearch extends Events {
  final int wali_kelas;
  final int id_sekolah;
  final int id_tahun_ajaran;
  int? id_guru;
  int? tingkat;
  final String rombel;
  final String token;

  StudentRombelSearch({
    required this.wali_kelas,
    required this.id_sekolah,
    required this.id_tahun_ajaran,
    this.id_guru = 0,
    this.tingkat = 0,
    required this.rombel,
    required this.token
  });
}