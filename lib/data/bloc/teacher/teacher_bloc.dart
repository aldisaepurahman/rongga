import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_event.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class TeacherBloc extends Bloc<Events, RonggaState> {
  TeacherBloc() : super(EmptyState()) {
    on<StudentOnSearch>(_searchStudent);
    on<TeacherUpdateProfile>(_editTeacher);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _searchStudent(StudentOnSearch event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.searchStudent({"id_sekolah": event.id_sekolah, "nama": event.nama, "rombel": event.rombel}).then((students) {
        var list_student = List<Student>.from(students.datastore);
        emit(students.message.isEmpty
            ? SuccessState(list_student)
            : FailureState(students.message.isNotEmpty
            ? students.message : "tidak ada"));
      }).catchError((error) {
        emit(FailureState(error.toString()));
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _editTeacher(TeacherUpdateProfile event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.editTeacher(event.teacher).then((status) {
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