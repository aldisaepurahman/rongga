import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_event.dart';
import 'package:non_cognitive/data/bloc/auth/auth_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class TahunAjaranBloc extends Bloc<Events, RonggaState> {
  TahunAjaranBloc() : super(EmptyState()) {
    on<TahunAjaranShow>(_showTahunAjaran);
    on<TahunAjaranAdd>(_addTahunAjaran);
    on<TahunAjaranUpdate>(_editTahunAjaran);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _showTahunAjaran(TahunAjaranShow event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.showTahunAjaran({"id_sekolah": event.id_sekolah}, event.token).then((status) {
        var tahun_ajaran = List<TahunAjaran>.from(status.datastore);
        emit(status.message.isEmpty
            ? SuccessState(tahun_ajaran)
            : FailureState(status.message.isNotEmpty
            ? status.message : "tidak ada"));
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _addTahunAjaran(TahunAjaranAdd event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.addTahunAjaran(event.tahun_ajaran, event.token).then((status) {
        emit(CrudState(status.datastore));
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _editTahunAjaran(TahunAjaranUpdate event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.editTahunAjaran(event.tahun_ajaran, event.token).then((status) {
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