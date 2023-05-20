class NilaiAkhirInput {
  int? id;
  int? id_mapel;
  String? nama_mapel;
  int? id_siswa;
  int? id_tingkat_kelas;
  int? id_sekolah;
  int? id_tahun_ajaran;
  int? nilai;

  NilaiAkhirInput({
    this.id = 0,
    this.id_mapel = 0,
    this.nama_mapel = "",
    this.id_siswa = 0,
    this.id_tingkat_kelas = 0,
    this.id_sekolah = 0,
    this.id_tahun_ajaran = 0,
    this.nilai = 0
  });

  NilaiAkhirInput.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    id_mapel = json['id_mapel'];
    nama_mapel = json['nama_mapel'];
    id_siswa = json['id_siswa'];
    id_tingkat_kelas = json['id_tingkat_kelas'];
    id_sekolah = json['id_sekolah'];
    id_tahun_ajaran = json['id_tahun_ajaran'];
    nilai = json['nilai'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_mapel': id_mapel,
      'id_siswa': id_siswa,
      'id_tingkat_kelas': id_tingkat_kelas,
      'id_sekolah': id_sekolah,
      'id_tahun_ajaran': id_tahun_ajaran,
      'nilai': nilai
    };
  }
}