import 'package:non_cognitive/data/bloc/events.dart';

class TahunAjaranShow extends Events {
  final int id_sekolah;
  final String token;

  TahunAjaranShow({required this.id_sekolah, required this.token});
}

class TahunAjaranAdd extends Events {
  final Map<String, dynamic> tahun_ajaran;
  final String token;

  TahunAjaranAdd({required this.tahun_ajaran, required this.token});
}

class TahunAjaranUpdate extends Events {
  final Map<String, dynamic> tahun_ajaran;
  final String token;

  TahunAjaranUpdate({required this.tahun_ajaran, required this.token});
}

class TahunAjaranDelete extends Events {
  final int id_tahun_ajaran;
  final String token;

  TahunAjaranDelete({required this.id_tahun_ajaran, required this.token});
}

class TahunAjaranActive extends Events {
  final int id_tahun_ajaran;
  final int id_sekolah;
  final String token;

  TahunAjaranActive({required this.id_tahun_ajaran, required this.id_sekolah, required this.token});
}