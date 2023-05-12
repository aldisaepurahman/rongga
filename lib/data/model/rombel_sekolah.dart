class RombelSekolah {
  int? id_rombel;
  int? id_sekolah;
  int? id_tingkat_kelas;
  String? rombel;

  RombelSekolah({this.id_rombel = 0, this.id_sekolah = 0, this.id_tingkat_kelas = 0, this.rombel = ""});

  RombelSekolah.fromJson(Map<String, dynamic> json) {
    id_rombel = json['id'];
    id_sekolah = json['id_sekolah'];
    id_tingkat_kelas = json['id_tingkat_kelas'];
    rombel = json['rombel'];
  }
}