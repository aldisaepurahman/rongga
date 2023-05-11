import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_event.dart';
import 'package:non_cognitive/data/bloc/auth/auth_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class TahunAjaranDelActBloc extends Bloc<Events, RonggaState> {
  TahunAjaranDelActBloc() : super(EmptyState()) {
    on<TahunAjaranDelete>(_deleteTahunAjaran);
    on<TahunAjaranActive>(_setActiveTahunAjaran);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _deleteTahunAjaran(TahunAjaranDelete event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.deleteTahunAjaran({"id_tahun_ajaran": event.id_tahun_ajaran}).then((status) {
        emit(CrudState(status.datastore));
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _setActiveTahunAjaran(TahunAjaranActive event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.setActiveTahunAjaran({"id_tahun_ajaran": event.id_tahun_ajaran, "id_sekolah": event.id_sekolah}).then((status) {
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