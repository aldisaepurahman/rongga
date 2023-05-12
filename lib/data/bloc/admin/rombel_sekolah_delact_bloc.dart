import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/rombel_sekolah_event.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_event.dart';
import 'package:non_cognitive/data/bloc/auth/auth_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class RombelSekolahDelActBloc extends Bloc<Events, RonggaState> {
  RombelSekolahDelActBloc() : super(EmptyState()) {
    on<RombelSekolahDelete>(_deleteRombelSekolah);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _deleteRombelSekolah(RombelSekolahDelete event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await service.deleteRombelSekolah({"id_rombel": event.id_rombel}).then((status) {
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