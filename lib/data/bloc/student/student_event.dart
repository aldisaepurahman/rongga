import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/model/student.dart';

class TeacherOnSearch extends Events {
  final int id_sekolah;
  final String nama;
  final String token;

  TeacherOnSearch({required this.id_sekolah, required this.nama, required this.token});
}

class StudentUpdateProfile extends Events {
  final Map<String, dynamic> student;
  final String token;

  StudentUpdateProfile({required this.student, required this.token});
}

class StudentQuestionnaire extends Events {
  final List<Map<String, dynamic>> quests;
  final String token;

  StudentQuestionnaire({required this.quests, required this.token});
}

class StudentTestResults extends Events {
  final int id_siswa;
  final String tahun_ajaran;

  StudentTestResults({required this.id_siswa, required this.tahun_ajaran});
}