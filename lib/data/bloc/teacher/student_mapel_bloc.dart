import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_event.dart';
import 'package:non_cognitive/data/model/nilai_akhir_input.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class StudentMapelBloc extends Bloc<Events, RonggaState> {
  StudentMapelBloc() : super(EmptyState()) {
    on<StudentScoreExists>(_getAllExistingMapel);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _getAllExistingMapel(StudentScoreExists event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.getAllExistingMapel(event.criterias, event.token).then((students) {
        var list_nilai = List<NilaiAkhirInput>.from(students.datastore);
        emit(students.message.isEmpty
            ? SuccessState(list_nilai)
            : FailureState(students.message.isNotEmpty
            ? students.message : "tidak ada"));
      }).catchError((error) {
        emit(FailureState(error.toString()));
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _resetPage(Events event, Emitter<RonggaState> emit) async {
    emit(EmptyState());
  }
}