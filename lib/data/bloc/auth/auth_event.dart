import 'package:non_cognitive/data/bloc/events.dart';

class AuthLogin extends Events {
  final String no_induk;
  final String password;

  AuthLogin({required this.no_induk, required this.password});
}

class AuthChangePassword extends Events {
  final int id_user;
  final String password;

  AuthChangePassword({required this.id_user, required this.password});
}

class AuthRegister extends Events {
  final Map<String, dynamic> user;

  AuthRegister({required this.user});
}

class AuthRegisterDetail extends Events {
  final bool isStudent;
  final Map<String, dynamic> user;

  AuthRegisterDetail({required this.isStudent, required this.user});
}