import 'package:non_cognitive/data/bloc/events.dart';

class RombelSekolahShow extends Events {
  final int id_sekolah;

  RombelSekolahShow({required this.id_sekolah});
}

class RombelSekolahAdd extends Events {
  final Map<String, dynamic> rombel_sekolah;

  RombelSekolahAdd({required this.rombel_sekolah});
}

class RombelSekolahUpdate extends Events {
  final Map<String, dynamic> rombel_sekolah;

  RombelSekolahUpdate({required this.rombel_sekolah});
}

class RombelSekolahDelete extends Events {
  final int id_rombel;

  RombelSekolahDelete({required this.id_rombel});
}