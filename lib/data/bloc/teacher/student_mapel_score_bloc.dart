import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_event.dart';
import 'package:non_cognitive/data/model/nilai_akhir_input.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class StudentMapelScoreBloc extends Bloc<Events, RonggaState> {
  StudentMapelScoreBloc() : super(EmptyState()) {
    on<StudentScoreInput>(_addNilaiAkhirSiswa);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _addNilaiAkhirSiswa(StudentScoreInput event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.addNilaiAkhirSiswa({"nilai_akhir": event.scores}).then((scores) {
        emit(CrudState(scores.datastore));
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