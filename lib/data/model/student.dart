import 'package:non_cognitive/data/model/users.dart';
import 'package:non_cognitive/utils/user_type.dart';

class Student extends Users {
  String? studyStyle;
  int? id_siswa;
  int? id_users;
  String? tahun_masuk;
  int? status_siswa;
  int? id_tingkat_kelas;
  int? tingkat;
  String? deskripsi;
  String? rombel;

  Student(
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
      this.studyStyle = "",
      this.id_siswa = 0,
      this.id_users = 0,
      this.tahun_masuk = "",
      this.status_siswa = 0,
      this.id_tingkat_kelas = 0,
      this.tingkat = 0,
      this.deskripsi = "",
      this.rombel = ""});

  Student.fromJson(Map<String, dynamic> json) {
    id_users = json['id'];
    idNumber = json['no_induk'];
    name = json['nama'];
    email = json['email'];
    password = json['password'];
    gender = json['gender'];
    no_telp = json['no_telp'];
    photo = json['photo'].isNotEmpty ? "http://localhost:3000/public/images/${json['photo']}" : "";
    address = json['alamat'];
    type = UserType.SISWA;
    id_sekolah = json['id_sekolah'];
    id_siswa = json['id_siswa'];
    tahun_masuk = json['tahun_masuk'];
    status_siswa = json['status_awal_siswa'];
    tingkat = json['tingkat'];
    deskripsi = json['deskripsi'];
    rombel = json['rombel'];
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
      "id_siswa": this.id_siswa,
      "tahun_masuk": this.tahun_masuk,
      "status_awal_siswa": this.status_siswa,
      'tingkat': this.tingkat,
      'deskripsi': this.deskripsi,
      'rombel': this.rombel,
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
      "status_awal_siswa": this.status_siswa,
      "tahun_masuk": this.tahun_masuk,
      "id_tingkat_kelas": this.id_tingkat_kelas
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
      "status_siswa": this.status_siswa,
      "id_tingkat_siswa": this.id_tingkat_kelas,
      "tahun_masuk": this.tahun_masuk
    };
  }

  Map<String, dynamic> toChangePassJson() {
    return {
      "id": this.id_users,
      "password": this.password
    };
  }
}
