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

class AddRombelSiswa extends Events {
  final List<Map<String, dynamic>> list_siswa;
  final List<Map<String, dynamic>> list_wali;

  AddRombelSiswa({required this.list_siswa, required this.list_wali});
}

class AddManualRombelSiswa extends Events {
  final List<Map<String, dynamic>> list_siswa;

  AddManualRombelSiswa({required this.list_siswa});
}

class DeleteRombelSiswa extends Events {
  final int id_sekolah;
  final int id_tahun_ajaran;
  final int tingkat;

  DeleteRombelSiswa({required this.id_sekolah, required this.id_tahun_ajaran, required this.tingkat});
}