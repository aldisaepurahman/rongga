import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_create_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_event.dart';
import 'package:non_cognitive/data/model/average_nilai_akhir.dart';
import 'package:non_cognitive/data/model/nilai_akhir_input.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/data/model/rombel_siswa.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class TeacherExcelBloc extends Bloc<Events, RonggaState> {
  TeacherExcelBloc() : super(EmptyState()) {
    on<TeacherExcelCheck>(_checkExcel);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _checkExcel(TeacherExcelCheck event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await Future.wait([
        service.searchStudent({"id_sekolah": event.id_sekolah}),
        service.getCurrentTahunAjaran({"id_tahun_ajaran": event.id_tahun_ajaran}),
        service.getPreviousTahunAjaran({"tahun_ajaran": event.tahun_ajaran}),
        service.getAllScore({"id_sekolah": event.id_sekolah}),
      ]).then((arr) {
        bool foundError = false;

        int i = 0;
        while (i < arr.length && !foundError) {
          if (arr[i].message.isNotEmpty) foundError = true;
          i++;
        }

        if (foundError) {
          emit(const FailureState("Terjadi error saat mengambil data"));
        } else {
          var list_siswa = List<Student>.from(arr[0].datastore);
          var currTahunAjaran = arr[1].datastore as TahunAjaran;
          var prevTahunAjaran = arr[2].datastore as TahunAjaran;
          var list_nilai = List<NilaiAkhirInput>.from(arr[3].datastore);

          emit(SuccessState({
            "list_student": list_siswa,
            "current_tahun_ajaran": currTahunAjaran,
            "previous_tahun_ajaran": prevTahunAjaran,
            "list_nilai": list_nilai
          }));
        }
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _resetPage(Events event, Emitter<RonggaState> emit) async {
    emit(EmptyState());
  }
}