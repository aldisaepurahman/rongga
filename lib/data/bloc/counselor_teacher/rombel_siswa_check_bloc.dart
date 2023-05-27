import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_create_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/average_nilai_akhir.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/data/model/rombel_siswa.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class RombelSiswaCheckBloc extends Bloc<Events, RonggaState> {
  RombelSiswaCheckBloc() : super(EmptyState()) {
    on<CheckRombelSiswa>(_checkRombel);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _checkRombel(CheckRombelSiswa event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await Future.wait([
        service.getStudentTingkat({"tingkat": event.tingkat, "id_sekolah": event.id_sekolah}),
        service.getAllTestResults({"id_tahun_ajaran": event.id_tahun_ajaran}),
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
          var quests = List<StudentStyle>.from(arr[1].datastore);


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