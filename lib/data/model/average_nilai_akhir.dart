class AverageNilaiAkhir {
  int? id_siswa;
  int? id_tingkat_kelas;
  int? id_sekolah;
  int? id_tahun_ajaran;
  double? nilai;
  String? level_avg;

  AverageNilaiAkhir({
    this.id_siswa = 0,
    this.id_tingkat_kelas = 0,
    this.id_sekolah = 0,
    this.id_tahun_ajaran = 0,
    this.nilai = 0.0,
    this.level_avg = ""
  });

  AverageNilaiAkhir.fromJson(Map<String, dynamic> json) {
    id_siswa = json['id_siswa'];
    id_tingkat_kelas = json['id_tingkat_kelas'];
    id_sekolah = json['id_sekolah'];
    id_tahun_ajaran = json['id_tahun_ajaran'];
    nilai = json['rata_rata'];
    level_avg = nilai! >= 85.0
        ? "Tinggi" : nilai! < 85.0 && nilai! >= 75.0
        ? "Sedang" : "Rendah";
  }
}