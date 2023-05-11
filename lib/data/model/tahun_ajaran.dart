class TahunAjaran {
  int? id_thn_ajaran;
  String? thnAjaran;
  String? semester;
  bool? active;

  TahunAjaran({this.id_thn_ajaran = 0, this.thnAjaran = "", this.semester = "", this.active = false});

  TahunAjaran.fromJson(Map<String, dynamic> json) {
    id_thn_ajaran = json['id'];
    thnAjaran = json['tahun_ajaran'];
    semester = json['semester'];
    active = json['aktif'] > 0 ? true : false;
  }
}