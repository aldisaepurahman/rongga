import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_create_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/average_nilai_akhir.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/data/model/rombel_siswa.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class RombelSiswaCheckBloc extends Bloc<Events, RonggaState> {
  RombelSiswaCheckBloc() : super(EmptyState()) {
    on<CheckRombelSiswa>(_checkRombel);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _checkRombel(CheckRombelSiswa event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await Future.wait([
        service.getStudentTingkat({"tingkat": event.tingkat, "id_sekolah": event.id_sekolah}),
        service.getAllTestResults({"id_tahun_ajaran": event.id_tahun_ajaran}),
        service.showRombelSekolah({"id_sekolah": event.id_sekolah, "tingkat": event.tingkat})
      ]).then((arr) {
        bool foundError = false;

        int i = 0;
        while (i < arr.length && !foundError) {
          if (arr[i].message.isNotEmpty) foundError = true;
          i++;
        }

        if (foundError) {
          emit(const FailureState("Terjadi error saat mengambil data"));
        } else {
          var list_siswa = List<Student>.from(arr[0].datastore);
          var quests = List<StudentStyle>.from(arr[1].datastore);
          var rombel = List<RombelSekolah>.from(arr[2].datastore);

          Map counts = {};

          for (var i = 0; i < list_siswa.length; i++) {
            if (counts.containsKey(list_siswa[i].rombel)) {
              counts[list_siswa[i].rombel]++;
            } else {
              counts[list_siswa[i].rombel] = 1;
            }
          }

          List<Map<String, dynamic>> rombel_group = <Map<String, dynamic>>[];
          counts.keys.forEach((key) {
            if (key is String) {
              var maps = {
                'id_sekolah': event.id_sekolah,
                'rombel': key,
                'description': "",
                'list_siswa': <RombelSiswa>[],
                'visual_count': 0,
                'auditorial_count': 0,
                'kinestetik_count': 0
              };
              rombel_group.add(maps);
            }
          });

          int allStudents = 0;
          List<Student> tempStudents = <Student>[];
          for (var i = 0; i < list_siswa.length; i++) {
            int j = 0;
            bool found = false;

            while (j < rombel_group.length && !found) {
              if (rombel_group[j]["rombel"] == list_siswa[i].rombel && list_siswa[i].rombel != null) {
                int idxQuest = quests.indexWhere((row) => row.nis == list_siswa[i].idNumber);
                if (idxQuest >= 0){
                  rombel_group[j]['list_siswa'].add(
                      RombelSiswa(
                          id_siswa: list_siswa[i].id_siswa,
                          name: list_siswa[i].name,
                          style: quests[idxQuest]
                      )
                  );
                } else {
                  rombel_group[j]['list_siswa'].add(
                      RombelSiswa(
                          id_siswa: list_siswa[i].id_siswa,
                          name: list_siswa[i].name,
                          style: StudentStyle()
                      )
                  );
                }

                allStudents++;
                found = true;
              }
              j++;
            }

            if (!found) {
              tempStudents.add(list_siswa[i]);
            }
          }

          bool hasGroup = false;

          if (tempStudents.length != list_siswa.length) {
            hasGroup = true;
            for (var i = 0; i < rombel_group.length; i++) {
              for (var j = 0; j < rombel_group[i]['list_siswa'].length; j++) {
                if (!rombel_group[i]['list_siswa'][j].style.learningStyle
                    .contains("Tidak Diketahui")) {
                  if (rombel_group[i]['list_siswa'][j].style.learningStyle
                      .contains("Visual")) {
                    rombel_group[i]['visual_count'] += 1;
                  } else
                  if (rombel_group[i]['list_siswa'][j].style.learningStyle
                      .contains("Auditorial")) {
                    rombel_group[i]['auditorial_count'] += 1;
                  } else
                  if (rombel_group[i]['list_siswa'][j].style.learningStyle
                      .contains("Kinestetik")) {
                    rombel_group[i]['kinestetik_count'] += 1;
                  }
                }
              }

              int total_count = rombel_group[i]['visual_count'] +
                  rombel_group[i]['auditorial_count'] +
                  rombel_group[i]['kinestetik_count'];
              var visualRatio = (rombel_group[i]['visual_count'] * 100) /
                  total_count;
              var auditorialRatio = (rombel_group[i]['auditorial_count'] *
                  100) / total_count;
              var kinestetikRatio = (rombel_group[i]['kinestetik_count'] *
                  100) / total_count;

              if (kinestetikRatio >= 40) {
                rombel_group[i]['description'] =
                "Sebagian besar siswa di rombel ini cenderung belajar dengan mempraktikkan "
                    "apa yang sebenarnya dijelaskan oleh guru. Sebagian besar siswa di rombel ini akan cocok diberikan tugas "
                    "berupa tugas praktik yang membuat mereka mampu memahami cara penyelesaian dari tugas tersebut melalui "
                    "metode gerakan. Beberapa siswa lainnya baik dalam hal mendengarkan materi dan memperhatikan materi berupa gambar "
                    "yang dijelaskan oleh guru.";
              } else if (visualRatio >= 40) {
                rombel_group[i]['description'] =
                "Sebagian besar siswa di rombel ini cenderung belajar dengan memperhatikan "
                    "materi yang dijelaskan oleh guru dalam bentuk ilustrasi atau gambar. Sebagian besar siswa di rombel ini "
                    "akan cocok diberikan tugas yang mampu mengembangkan kreativitas dalam menggambar atau mengilustrasikan suatu "
                    "permasalahan. Beberapa siswa lainnya baik dalam hal mendengarkan materi dan mempraktikkan materi "
                    "yang dijelaskan oleh guru.";
              } else if (auditorialRatio >= 40) {
                rombel_group[i]['description'] =
                "Sebagian besar siswa di rombel ini cenderung belajar dengan mendengar "
                    "materi yang disampaikan oleh guru ketika kegiatan belajar mengajar berlangsung. Sebagian besar siswa di rombel ini "
                    "Bagi siswa tersebut, guru perlu memaksimalkan kemampuan mereka dalam menyimak materi yang mereka sampaikan. "
                    "Beberapa siswa lainnya baik dalam hal memperhatikan materi dan mempraktikkan materi "
                    "yang dijelaskan oleh guru.";
              } else {
                rombel_group[i]['description'] =
                "Siswa di rombel ini memiliki cara belajar yang hampir seimbang. Gaya belajar "
                    "yang ada berimbang tersebut perlu diakomodir oleh guru yang mampu mengaplikasikan setiap jenis cara mengajar "
                    "yang bisa dimengerti oleh setiap siswa dengan gaya belajar yang berbeda tersebut.";
              }
            }
          }

          emit(SuccessState({
            "list_student_temp": tempStudents,
            "rombel_siswa": rombel_group,
            "has_group": hasGroup,
            "allStudents": allStudents,
            "rombel": rombel
          }));
        }
      });
    } catch (error) {
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _resetPage(Events event, Emitter<RonggaState> emit) async {
    emit(EmptyState());
  }
}