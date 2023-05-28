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

class RombelSiswaDeleteBloc extends Bloc<Events, RonggaState> {
  RombelSiswaDeleteBloc() : super(EmptyState()) {
    on<DeleteRombelSiswa>(_deleteRombel);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _deleteRombel(DeleteRombelSiswa event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await Future.wait([
        service.deleteRombelSiswa({"id_sekolah": event.id_sekolah, "id_tahun_ajaran": event.id_tahun_ajaran, "tingkat": event.tingkat}),
        service.deleteWaliKelas({"id_sekolah": event.id_sekolah, "id_tahun_ajaran": event.id_tahun_ajaran, "tingkat": event.tingkat}),
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
          if (arr[0].datastore && arr[1].datastore) {
            emit(const CrudState(true));
          } else {
            emit(const CrudState(false));
          }
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