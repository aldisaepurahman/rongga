import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/auth/auth_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class LoginBloc extends Bloc<Events, RonggaState> {
  LoginBloc() : super(EmptyState()) {
    on<AuthLogin>(_login);
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

  Future<void> _resetPage(Events event, Emitter<RonggaState> emit) async {
    emit(EmptyState());
  }
}