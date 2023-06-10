import 'package:non_cognitive/data/bloc/events.dart';

class RombelSekolahShow extends Events {
  final int id_sekolah;
  final String token;

  RombelSekolahShow({required this.id_sekolah, required this.token});
}

class RombelSekolahAdd extends Events {
  final Map<String, dynamic> rombel_sekolah;
  final String token;

  RombelSekolahAdd({required this.rombel_sekolah, required this.token});
}

class RombelSekolahUpdate extends Events {
  final Map<String, dynamic> rombel_sekolah;
  final String token;

  RombelSekolahUpdate({required this.rombel_sekolah, required this.token});
}

class RombelSekolahDelete extends Events {
  final int id_rombel;
  final String token;

  RombelSekolahDelete({required this.id_rombel, required this.token});
}