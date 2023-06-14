import 'package:non_cognitive/data/bloc/events.dart';

class MakeRombelSiswa extends Events {
  final int id_sekolah;
  final int id_tahun_ajaran;
  final String tahun_ajaran;
  final int tingkat;
  final String token;

  MakeRombelSiswa({required this.id_sekolah, required this.id_tahun_ajaran, required this.tahun_ajaran, required this.tingkat, required this.token});
}

class CheckRombelSiswa extends Events {
  final int id_sekolah;
  final int id_tahun_ajaran;
  final String tahun_ajaran;
  final int tingkat;
  final String token;

  CheckRombelSiswa({required this.id_sekolah, required this.id_tahun_ajaran, required this.tahun_ajaran, required this.tingkat, required this.token});
}

class AddRombelSiswa extends Events {
  final List<Map<String, dynamic>> list_siswa;
  final List<Map<String, dynamic>> list_wali;
  final String token;

  AddRombelSiswa({required this.list_siswa, required this.list_wali, required this.token});
}

class AddManualRombelSiswa extends Events {
  final List<Map<String, dynamic>> list_siswa;
  final String token;

  AddManualRombelSiswa({required this.list_siswa, required this.token});
}

class DeleteRombelSiswa extends Events {
  final int id_sekolah;
  final int id_tahun_ajaran;
  final int tingkat;
  final String token;

  DeleteRombelSiswa({required this.id_sekolah, required this.id_tahun_ajaran, required this.tingkat, required this.token});
}