import 'package:non_cognitive/utils/user_type.dart';

class Users {
  String idNumber;
  String name;
  String email;
  String password;
  String gender;
  String no_telp;
  String photo;
  UserType type;

  Users({
    required this.idNumber,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    required this.no_telp,
    required this.photo,
    required this.type,
  });
}