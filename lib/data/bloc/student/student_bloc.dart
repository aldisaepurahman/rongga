import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/student/student_event.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class StudentBloc extends Bloc<Events, RonggaState> {
  StudentBloc() : super(EmptyState()) {
    on<TeacherOnSearch>(_searchTeacher);
    on<StudentUpdateProfile>(_editStudent);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _searchTeacher(TeacherOnSearch event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.searchTeacher({"id_sekolah": event.id_sekolah, "nama": event.nama}).then((teachers) {
        var list_teacher = List<Teacher>.from(teachers.datastore);
        emit(teachers.message.isEmpty
          ? SuccessState(list_teacher)
          : FailureState(teachers.message.isNotEmpty
            ? teachers.message : "tidak ada"));
      }).catchError((error) {
        emit(FailureState(error.toString()));
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _editStudent(StudentUpdateProfile event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.editStudent(event.student).then((status) {
        emit(CrudState(status.datastore));
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _resetPage(Events event, Emitter<RonggaState> emit) async {
    emit(EmptyState());
  }
}