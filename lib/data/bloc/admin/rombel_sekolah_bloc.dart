import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/rombel_sekolah_event.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_event.dart';
import 'package:non_cognitive/data/bloc/auth/auth_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class RombelSekolahBloc extends Bloc<Events, RonggaState> {
  RombelSekolahBloc() : super(EmptyState()) {
    on<RombelSekolahShow>(_showRombelSekolah);
    on<RombelSekolahAdd>(_addRombelSekolah);
    on<RombelSekolahUpdate>(_editRombelSekolah);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _showRombelSekolah(RombelSekolahShow event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.showRombelSekolah({"id_sekolah": event.id_sekolah}, event.token).then((status) {
        var rombel_sekolah = List<RombelSekolah>.from(status.datastore);
        emit(status.message.isEmpty
            ? SuccessState(rombel_sekolah)
            : FailureState(status.message.isNotEmpty
            ? status.message : "tidak ada"));
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _addRombelSekolah(RombelSekolahAdd event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.addRombelSekolah(event.rombel_sekolah, event.token).then((status) {
        emit(CrudState(status.datastore));
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _editRombelSekolah(RombelSekolahUpdate event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.editRombelSekolah(event.rombel_sekolah, event.token).then((status) {
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