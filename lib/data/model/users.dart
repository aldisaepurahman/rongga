import 'package:non_cognitive/utils/user_type.dart';

class Users {
  String? idNumber;
  String? name;
  String? email;
  String? password;
  String? gender;
  String? no_telp;
  String? photo;
  String? address;
  UserType? type;
  int? id_sekolah;
  int? id_tahun_ajaran;
  String? tahun_ajaran;
  String? token;

  Users({
    this.idNumber = "",
    this.name = "",
    this.email = "",
    this.password = "",
    this.gender = "",
    this.no_telp = "",
    this.photo = "",
    this.address = "",
    this.type = UserType.ADMIN,
    this.id_sekolah = 0,
    this.id_tahun_ajaran = 0,
    this.tahun_ajaran = "",
    this.token = ""
  });

  Users.fromJson(Map<String, dynamic> json) {
    idNumber = json['no_induk'];
    name = json['nama'];
    email = json['email'];
    password = json['password'];
    gender = json['gender'];
    no_telp = json['no_telp'];
    photo = json['photo'];
    address = json['alamat'];
    type = UserType.ADMIN;
    id_sekolah = json['id_sekolah'];
    id_tahun_ajaran = json['id_tahun_ajaran'];
    tahun_ajaran = json['tahun_ajaran'];
    token = json['token'];
  }

  Map<String, dynamic> toLocalJson() {
    return {
      "no_induk": this.idNumber,
      "nama": this.name,
      "email": this.email,
      "password": this.password,
      "gender": this.gender,
      "no_telp": this.no_telp,
      "photo": this.photo,
      "alamat": this.address,
      "id_sekolah": this.id_sekolah,
      'id_tahun_ajaran': this.id_tahun_ajaran,
      'tahun_ajaran': this.tahun_ajaran,
      'token': this.token
    };
  }
}