import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/auth/auth_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class RegisterDetailBloc extends Bloc<Events, RonggaState> {
  RegisterDetailBloc() : super(EmptyState()) {
    on<AuthRegisterDetail>(_registerDetail);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _registerDetail(AuthRegisterDetail event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      if (event.isStudent) {
        await service.registerStudent(event.user).then((status) {
          emit(CrudState(status.datastore));
        });
      } else {
        await service.registerTeacher(event.user).then((status) {
          emit(CrudState(status.datastore));
        });
      }
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _resetPage(Events event, Emitter<RonggaState> emit) async {
    emit(EmptyState());
  }
}