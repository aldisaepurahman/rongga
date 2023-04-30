import 'package:non_cognitive/data/model/users.dart';
import 'package:non_cognitive/utils/user_type.dart';

class Teacher extends Users {
  int? id_guru;
  int? id_users;
  int? status_kerja;
  int? id_mapel;
  String? spesialisasi;
  String? kelompok_mapel;
  bool? wali_kelas;

  Teacher(
      {required super.idNumber,
      required super.name,
      required super.email,
      required super.password,
      required super.gender,
      required super.no_telp,
      required super.photo,
      required super.address,
      required super.type,
      required super.id_sekolah,
      required super.id_tahun_ajaran,
      required super.tahun_ajaran,
      required super.token,
      this.id_guru = 0,
      this.id_users = 0,
      this.status_kerja = 0,
      this.id_mapel = 0,
      this.spesialisasi = "",
      this.kelompok_mapel = "",
      this.wali_kelas = false});

  Teacher.fromJson(Map<String, dynamic> json) {
    id_users = json['id'];
    idNumber = json['no_induk'];
    name = json['nama'];
    email = json['email'];
    password = json['password'];
    gender = json['gender'];
    no_telp = json['no_telp'];
    photo = json['photo'];
    address = json['alamat'];
    type = json["wali_kelas"] && json['spesialisasi'].contains("Konseling")
        ? UserType.GURU_BK_WALI_KELAS
        : json["wali_kelas"]
            ? UserType.WALI_KELAS
            : json['spesialisasi'].contains("Konseling")
                ? UserType.GURU_BK
                : UserType.GURU;
    id_sekolah = json['id_sekolah'];
    id_guru = json['id_guru'];
    status_kerja = json['status_ikatan_kerja'];
    spesialisasi = json['spesialisasi'];
    kelompok_mapel = json['kelompok_mapel'];
    wali_kelas = json['wali_kelas'];
    id_tahun_ajaran = json['id_tahun_ajaran'];
    tahun_ajaran = json['tahun_ajaran'];
    token = json['token'];
  }

  Map<String, dynamic> toLocalJson() {
    return {
      "id": this.id_users,
      "no_induk": this.idNumber,
      "nama": this.name,
      "email": this.email,
      "password": this.password,
      "gender": this.gender,
      "no_telp": this.no_telp,
      "photo": this.photo,
      "alamat": this.address,
      "id_sekolah": this.id_sekolah,
      "id_guru": this.id_guru,
      "status_ikatan_kerja": this.status_kerja,
      'spesialisasi': this.spesialisasi,
      'kelompok_mapel': this.kelompok_mapel,
      'wali_kelas': this.wali_kelas,
      'id_tahun_ajaran': this.id_tahun_ajaran,
      'tahun_ajaran': this.tahun_ajaran,
      'token': this.token
    };
  }

  Map<String, dynamic> toRegisterJson() {
    return {
      "no_induk": this.idNumber,
      "id_sekolah": this.id_sekolah,
      "no_telp": this.no_telp,
      "photo": this.photo,
      "alamat": this.address,
      "status_kerja": this.status_kerja,
      "id_mapel": this.id_mapel
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      "id": this.id_users,
      "no_induk": this.idNumber,
      "nama": this.name,
      "email": this.email,
      "gender": this.gender,
      "no_telp": this.no_telp,
      "photo": this.photo,
      "alamat": this.address,
      "status_kerja": this.status_kerja,
      "id_mapel": this.id_mapel
    };
  }

  Map<String, dynamic> toChangePassJson() {
    return {"id": this.id_users, "password": this.password};
  }
}
