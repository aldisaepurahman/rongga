import 'package:non_cognitive/data/bloc/events.dart';

class AuthLogin extends Events {
  final String no_induk;
  final String password;

  AuthLogin({required this.no_induk, required this.password});
}