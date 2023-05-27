import 'package:non_cognitive/data/bloc/events.dart';

class MakeRombelSiswa extends Events {
  final int id_sekolah;
  final int id_tahun_ajaran;
  final int tingkat;

  MakeRombelSiswa({required this.id_sekolah, required this.id_tahun_ajaran, required this.tingkat});
}

class CheckRombelSiswa extends Events {
  final int id_sekolah;
  final int id_tahun_ajaran;
  final int tingkat;

  CheckRombelSiswa({required this.id_sekolah, required this.id_tahun_ajaran, required this.tingkat});
}