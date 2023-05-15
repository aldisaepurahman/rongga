import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/student/student_event.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class StudentQuestBloc extends Bloc<Events, RonggaState> {
  StudentQuestBloc() : super(EmptyState()) {
    on<StudentQuestionnaire>(_sendQuestionnaire);
    on<StudentTestResults>(_getTestResults);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _sendQuestionnaire(StudentQuestionnaire event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.testQuestionnaire({"kuesioner": event.quests}).then((status) {
        emit(CrudState(status.datastore));
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _getTestResults(StudentTestResults event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.getTestResults({"id_siswa": event.id_siswa, "id_tahun_ajaran": event.id_tahun_ajaran}).then((tests) {
        var list_tests = tests.datastore as StudentStyle;
        emit(tests.message.isEmpty
            ? SuccessState(list_tests)
            : FailureState(tests.message.isNotEmpty
            ? tests.message : "tidak ada"));
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