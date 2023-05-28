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
    learningStyle = (json['skor_visual'] > 0 && json['skor_auditorial'] > 0 && json['skor_kinestetik'] > 0) ?
    (json['skor_visual'] == json['skor_auditorial']) && (json['skor_kinestetik'] == json['skor_auditorial'])
      ? "Gabungan (All)" : (json['skor_visual'] < json['skor_auditorial']) && (json['skor_kinestetik'] == json['skor_auditorial'])
      ? "Gabungan (Kinestetik + Auditorial)" : (json['skor_visual'] > json['skor_auditorial']) && (json['skor_kinestetik'] == json['skor_visual'])
      ? "Gabungan (Visual + Kinestetik)" : (json['skor_visual'] == json['skor_auditorial']) && (json['skor_kinestetik'] < json['skor_auditorial'])
      ? "Gabungan (Visual + Auditorial)" : (json['skor_visual'] < json['skor_kinestetik']) && (json['skor_kinestetik'] > json['skor_auditorial'])
      ? "Kinestetik" : (json['skor_visual'] < json['skor_auditorial']) && (json['skor_kinestetik'] < json['skor_auditorial'])
      ? "Auditorial" : "Visual" : "Tidak Diketahui";
    visual_score = json['skor_visual'];
    auditorial_score = json['skor_auditorial'];
    kinestetik_score = json['skor_kinestetik'];
  }
}
