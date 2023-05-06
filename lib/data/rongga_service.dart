import 'package:dio/dio.dart';
import 'package:non_cognitive/data/bloc/bloc_status.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/data/model/users.dart';

class RonggaService {
  RonggaService();

  final Dio _dio = Dio();
  final _baseUrl = "http://127.0.0.1:3000";

  Future<ServiceStatus> login(Map<String, dynamic> request) async {
    try {
      final response = await _dio.post(
        "$_baseUrl/auth/api/v1/login",
        data: request,
      );

      // print("Info: ${response.data["user_data"].toString()}");

      if (response.data["user_data"].isEmpty) {
        return ServiceStatus(
            datastore: {"type": -1, "user_data": Users()}, message: response.toString());
      }

      if (response.data["user_data"]["tipe_pengguna"] == 1) {
        return ServiceStatus(datastore: {"type": 1, "user_data": Student.fromJson(response.data["user_data"])});
      } else if (response.data["user_data"]["tipe_pengguna"] == 2) {
        return ServiceStatus(datastore: {"type": 2, "user_data": Teacher.fromJson(response.data["user_data"])});
      }
      return ServiceStatus(datastore: {"type": 0, "user_data": Users.fromJson(response.data["user_data"])});
    } catch (error, stackTrace) {
      return ServiceStatus(
          datastore: {"type": -1, "user_data": Users()}, message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> searchTeacher(Map<String, dynamic> request) async {
    try {
      final response = await _dio.post(
        "$_baseUrl/searchTeacher",
        data: request,
      );

      print("Info: ${response.data["values"].toString()}");

      if (response == null) {
        return ServiceStatus(
            datastore: List<Teacher>.from([]), message: response.toString());
      }

      return ServiceStatus(datastore: List<Teacher>.from(response.data["values"].map((e) => Teacher.fromJson(e)).toList()));
    } catch (error, stackTrace) {
      return ServiceStatus(
          datastore: List<Teacher>.from([]), message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> searchStudent(Map<String, dynamic> request) async {
    try {
      final response = await _dio.post(
        "$_baseUrl/searchStudents",
        data: request,
      );

      print("Info: ${response.data["values"].toString()}");

      if (response == null) {
        return ServiceStatus(
            datastore: List<Teacher>.from([]), message: response.toString());
      }

      return ServiceStatus(datastore: List<Student>.from(response.data["values"].map((e) => Student.fromJson(e)).toList()));
    } catch (error, stackTrace) {
      return ServiceStatus(
          datastore: List<Student>.from([]), message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> editStudent(Map<String, dynamic> request) async {
    try {
      FormData data = FormData.fromMap(request);

      final response = await _dio.put(
        "$_baseUrl/editStudent",
        data: data
      );

      print("Info: ${response.toString()}");

      if (response == null) {
        return ServiceStatus(datastore: false, message: response.toString());
      }

      return ServiceStatus(datastore: true);
    } catch (error, stackTrace) {
      return ServiceStatus(datastore: false, message: Error.throwWithStackTrace(error, stackTrace));
    }
  }
}