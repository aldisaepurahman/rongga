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