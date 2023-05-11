import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/auth/auth_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class RegisterBloc extends Bloc<Events, RonggaState> {
  RegisterBloc() : super(EmptyState()) {
    on<AuthRegister>(_register);
    on<ResetEvent>(_resetPage);
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

  Future<void> _resetPage(Events event, Emitter<RonggaState> emit) async {
    emit(EmptyState());
  }
}