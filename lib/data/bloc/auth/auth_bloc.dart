import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/auth/auth_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class AuthBloc extends Bloc<Events, RonggaState> {
  AuthBloc() : super(EmptyState()) {
    on<AuthLogin>(_login);
    on<AuthChangePassword>(_changePassword);
    on<AuthRegister>(_register);
    on<AuthRegisterDetail>(_registerDetail);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _login(AuthLogin event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.login({"no_induk": event.no_induk, "password": event.password}).then((users) {
        var user_data = users.datastore;
        emit(users.message.isEmpty
            ? SuccessState(user_data)
            : FailureState(users.message.isNotEmpty
            ? users.message : "tidak ada"));
      }).catchError((error) {
        emit(FailureState(error.toString()));
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _changePassword(AuthChangePassword event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.changePassword({"id": event.id_user, "password": event.password}).then((status) {
        emit(CrudState(status.datastore));
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _register(AuthRegister event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.register(event.user).then((status) {
        emit(CrudState(status.datastore));
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
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