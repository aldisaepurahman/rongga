class StudentStyle {
  String? nis;
  String? name;
  String? learningStyle;
  int? visual_score;
  int? auditorial_score;
  int? kinestetik_score;

  StudentStyle(
      {this.nis = "",
      this.name = "",
      this.learningStyle = "",
      this.visual_score = 0,
      this.auditorial_score = 0,
      this.kinestetik_score = 0});

  StudentStyle.fromJson(Map<String, dynamic> json) {
    nis = json['no_induk'];
    name = json['nama'];
    learningStyle = (int.parse(json['skor_visual']) > 0 && int.parse(json['skor_auditorial']) > 0 && int.parse(json['skor_kinestetik']) > 0) ?
    (int.parse(json['skor_visual']) == int.parse(json['skor_auditorial'])) && (int.parse(json['skor_kinestetik']) == int.parse(json['skor_auditorial']))
      ? "Gabungan (All)" : (int.parse(json['skor_visual']) < int.parse(json['skor_auditorial'])) && (int.parse(json['skor_kinestetik']) == int.parse(json['skor_auditorial']))
      ? "Gabungan (Kinestetik + Auditorial)" : (int.parse(json['skor_visual']) > int.parse(json['skor_auditorial'])) && (int.parse(json['skor_kinestetik']) == int.parse(json['skor_visual']))
      ? "Gabungan (Visual + Kinestetik)" : (int.parse(json['skor_visual']) == int.parse(json['skor_auditorial'])) && (int.parse(json['skor_kinestetik']) < int.parse(json['skor_auditorial']))
      ? "Gabungan (Visual + Auditorial)" : (int.parse(json['skor_visual']) < int.parse(json['skor_kinestetik'])) && (int.parse(json['skor_kinestetik']) > int.parse(json['skor_auditorial']))
      ? "Kinestetik" : (int.parse(json['skor_visual']) < int.parse(json['skor_auditorial'])) && (int.parse(json['skor_kinestetik']) < int.parse(json['skor_auditorial']))
      ? "Auditorial" : "Visual" : "Tidak Diketahui";
    visual_score = int.parse(json['skor_visual']);
    auditorial_score = int.parse(json['skor_auditorial']);
    kinestetik_score = int.parse(json['skor_kinestetik']);
  }
}
