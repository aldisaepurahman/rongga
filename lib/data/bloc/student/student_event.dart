import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/model/student.dart';

class TeacherOnSearch extends Events {
  final int id_sekolah;
  final String nama;

  TeacherOnSearch({required this.id_sekolah, required this.nama});
}

class StudentUpdateProfile extends Events {
  final Map<String, dynamic> student;

  StudentUpdateProfile({required this.student});
}

class StudentQuestionnaire extends Events {
  final List<Map<String, dynamic>> quests;

  StudentQuestionnaire({required this.quests});
}

class StudentTestResults extends Events {
  final int id_siswa;
  final String tahun_ajaran;

  StudentTestResults({required this.id_siswa, required this.tahun_ajaran});
}