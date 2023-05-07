import 'package:non_cognitive/data/bloc/events.dart';

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