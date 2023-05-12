import 'package:dio/dio.dart';
import 'package:non_cognitive/data/bloc/bloc_status.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';
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

  Future<ServiceStatus> register(Map<String, dynamic> request) async {
    try {
      final response = await _dio.post(
          "$_baseUrl/auth/api/v1/register",
          data: request
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

  Future<ServiceStatus> registerStudent(Map<String, dynamic> request) async {
    try {
      FormData data = FormData.fromMap(request);

      final response = await _dio.post(
          "$_baseUrl/auth/api/v1/registerStudent",
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

  Future<ServiceStatus> registerTeacher(Map<String, dynamic> request) async {
    try {
      FormData data = FormData.fromMap(request);

      final response = await _dio.post(
          "$_baseUrl/auth/api/v1/registerTeacher",
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

  Future<ServiceStatus> editTeacher(Map<String, dynamic> request) async {
    try {
      FormData data = FormData.fromMap(request);

      final response = await _dio.put(
          "$_baseUrl/editTeacher",
          data: data
      );

      if (response == null) {
        return ServiceStatus(datastore: false, message: response.toString());
      }

      return ServiceStatus(datastore: true);
    } catch (error, stackTrace) {
      return ServiceStatus(datastore: false, message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> changePassword(Map<String, dynamic> request) async {
    try {
      final response = await _dio.put(
          "$_baseUrl/changePassword",
          data: request
      );

      if (response == null) {
        return ServiceStatus(datastore: false, message: response.toString());
      }

      return ServiceStatus(datastore: true);
    } catch (error, stackTrace) {
      return ServiceStatus(datastore: false, message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> getAllMapel(Map<String, dynamic> request) async {
    try {
      final response = await _dio.post(
          "$_baseUrl/nilaiSiswa/mapel",
          data: request
      );

      if (response == null) {
        return ServiceStatus(datastore: [], message: response.toString());
      }

      return ServiceStatus(datastore: response.data["values"]);
    } catch (error, stackTrace) {
      return ServiceStatus(datastore: [], message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> getAllExistingMapel(Map<String, dynamic> request) async {
    try {
      final response = await _dio.post(
          "$_baseUrl/nilaiSiswa/exists",
          data: request
      );

      if (response == null) {
        return ServiceStatus(datastore: [], message: response.toString());
      }

      return ServiceStatus(datastore: response.data["values"]);
    } catch (error, stackTrace) {
      return ServiceStatus(datastore: [], message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> showTahunAjaran(Map<String, dynamic> request) async {
    try {
      final response = await _dio.post(
        "$_baseUrl/tahunAjaran",
        data: request,
      );

      print("Info: ${response.data["values"].toString()}");

      if (response == null) {
        return ServiceStatus(
            datastore: List<TahunAjaran>.from([]), message: response.toString());
      }

      return ServiceStatus(datastore: List<TahunAjaran>.from(response.data["values"].map((e) => TahunAjaran.fromJson(e)).toList()));
    } catch (error, stackTrace) {
      return ServiceStatus(
          datastore: List<TahunAjaran>.from([]), message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> addTahunAjaran(Map<String, dynamic> request) async {
    try {
      final response = await _dio.post(
          "$_baseUrl/tahunAjaran/add",
          data: request
      );

      if (response == null) {
        return ServiceStatus(datastore: false, message: response.toString());
      }

      return ServiceStatus(datastore: true);
    } catch (error, stackTrace) {
      return ServiceStatus(datastore: false, message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> editTahunAjaran(Map<String, dynamic> request) async {
    try {
      final response = await _dio.put(
          "$_baseUrl/tahunAjaran/edit",
          data: request
      );

      if (response == null) {
        return ServiceStatus(datastore: false, message: response.toString());
      }

      return ServiceStatus(datastore: true);
    } catch (error, stackTrace) {
      return ServiceStatus(datastore: false, message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> deleteTahunAjaran(Map<String, dynamic> request) async {
    try {
      final response = await _dio.delete(
          "$_baseUrl/tahunAjaran/delete",
          data: request
      );

      if (response == null) {
        return ServiceStatus(datastore: false, message: response.toString());
      }

      return ServiceStatus(datastore: true);
    } catch (error, stackTrace) {
      return ServiceStatus(datastore: false, message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> setActiveTahunAjaran(Map<String, dynamic> request) async {
    try {
      final response = await _dio.put(
          "$_baseUrl/tahunAjaran/active",
          data: request
      );

      if (response == null) {
        return ServiceStatus(datastore: false, message: response.toString());
      }

      return ServiceStatus(datastore: true);
    } catch (error, stackTrace) {
      return ServiceStatus(datastore: false, message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> showRombelSekolah(Map<String, dynamic> request) async {
    try {
      final response = await _dio.post(
        "$_baseUrl/rombelSekolah",
        data: request,
      );

      print("Info: ${response.data["values"].toString()}");

      if (response == null) {
        return ServiceStatus(
            datastore: List<RombelSekolah>.from([]), message: response.toString());
      }

      return ServiceStatus(datastore: List<RombelSekolah>.from(response.data["values"].map((e) => RombelSekolah.fromJson(e)).toList()));
    } catch (error, stackTrace) {
      return ServiceStatus(
          datastore: List<RombelSekolah>.from([]), message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> addRombelSekolah(Map<String, dynamic> request) async {
    try {
      final response = await _dio.post(
          "$_baseUrl/rombelSekolah/add",
          data: request
      );

      if (response == null) {
        return ServiceStatus(datastore: false, message: response.toString());
      }

      return ServiceStatus(datastore: true);
    } catch (error, stackTrace) {
      return ServiceStatus(datastore: false, message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> editRombelSekolah(Map<String, dynamic> request) async {
    try {
      final response = await _dio.put(
          "$_baseUrl/rombelSekolah/edit",
          data: request
      );

      if (response == null) {
        return ServiceStatus(datastore: false, message: response.toString());
      }

      return ServiceStatus(datastore: true);
    } catch (error, stackTrace) {
      return ServiceStatus(datastore: false, message: Error.throwWithStackTrace(error, stackTrace));
    }
  }

  Future<ServiceStatus> deleteRombelSekolah(Map<String, dynamic> request) async {
    try {
      final response = await _dio.delete(
          "$_baseUrl/rombelSekolah/delete",
          data: request
      );

      if (response == null) {
        return ServiceStatus(datastore: false, message: response.toString());
      }

      return ServiceStatus(datastore: true);
    } catch (error, stackTrace) {
      return ServiceStatus(datastore: false, message: Error.throwWithStackTrace(error, stackTrace));
    }
  }
}