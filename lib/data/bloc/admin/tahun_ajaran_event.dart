import 'package:non_cognitive/data/bloc/events.dart';

class TahunAjaranShow extends Events {
  final int id_sekolah;

  TahunAjaranShow({required this.id_sekolah});
}

class TahunAjaranAdd extends Events {
  final Map<String, dynamic> tahun_ajaran;

  TahunAjaranAdd({required this.tahun_ajaran});
}

class TahunAjaranUpdate extends Events {
  final Map<String, dynamic> tahun_ajaran;

  TahunAjaranUpdate({required this.tahun_ajaran});
}

class TahunAjaranDelete extends Events {
  final int id_tahun_ajaran;

  TahunAjaranDelete({required this.id_tahun_ajaran});
}

class TahunAjaranActive extends Events {
  final int id_tahun_ajaran;
  final int id_sekolah;

  TahunAjaranActive({required this.id_tahun_ajaran, required this.id_sekolah});
}