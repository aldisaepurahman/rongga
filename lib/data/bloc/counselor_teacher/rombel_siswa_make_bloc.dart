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

class RombelSiswaMakeBloc extends Bloc<Events, RonggaState> {
  RombelSiswaMakeBloc() : super(EmptyState()) {
    on<MakeRombelSiswa>(_createRombel);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _createRombel(MakeRombelSiswa event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await Future.wait([
        service.getStudentTingkat({"tingkat": event.tingkat, "id_sekolah": event.id_sekolah}, event.token),
        service.getAverageNilaiAkhir({"tingkat": event.tingkat, "id_tahun_ajaran": event.id_tahun_ajaran, "id_sekolah": event.id_sekolah}, event.token),
        service.getAllTestResults({"tahun_ajaran": event.tahun_ajaran}, event.token),
        service.searchTeacher({"id_sekolah": event.id_sekolah}, event.token),
        service.showRombelSekolah({"id_sekolah": event.id_sekolah, "tingkat": event.tingkat}, event.token)
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
          var nilai_akhir = List<AverageNilaiAkhir>.from(arr[1].datastore);
          var quests = List<StudentStyle>.from(arr[2].datastore);
          var list_teacher = List<Teacher>.from(arr[3].datastore);
          var rombel_sekolah = List<RombelSekolah>.from(arr[4].datastore);

          if (list_siswa.length != nilai_akhir.length || list_siswa.length != quests.length || nilai_akhir.length != quests.length) {
            emit(const FailureState("Coba untuk lengkapi data nilai akhir serta kuesioner siswa"));
          } else {
            List<Map<String, dynamic>> rombel_group = <Map<String, dynamic>>[];
            for (var i = 0; i < rombel_sekolah.length; i++) {
              var maps = {
                'id_rombel': rombel_sekolah[i].id_rombel,
                'id_sekolah': rombel_sekolah[i].id_sekolah,
                'id_tingkat_kelas': rombel_sekolah[i].id_tingkat_kelas,
                'rombel': rombel_sekolah[i].rombel,
                'description': "",
                'list_siswa': <RombelSiswa>[],
                'visual_count': 0,
                'auditorial_count': 0,
                'kinestetik_count': 0
              };
              rombel_group.add(maps);
            }

            i = 0;
            foundError = false;
            for (var j = 0; j < nilai_akhir.length; j++) {
              int idxSiswa = list_siswa.indexWhere((row) => row.id_siswa == nilai_akhir[j].id_siswa);
              int idxQuest = quests.indexWhere((row) => row.nis == list_siswa[idxSiswa].idNumber);

              if (idxSiswa >= 0 && idxQuest >= 0){
                rombel_group[i]['list_siswa'].add(
                    RombelSiswa(
                      id_siswa: list_siswa[idxSiswa].id_siswa,
                      name: list_siswa[idxSiswa].name,
                      style: quests[idxQuest],
                      level: nilai_akhir[j].level_avg,
                      student: list_siswa[idxSiswa]
                    )
                );

                if (i == rombel_sekolah.length-1) {
                  i = 0;
                } else {
                  i++;
                }
              } else {
                foundError = true;
                break;
              }
            }

            if (foundError) {
              emit(const FailureState("Coba untuk lengkapi data nilai akhir serta kuesioner siswa"));
            } else {
              for (var i = 0; i < rombel_group.length; i++) {
                for (var j = 0; j < rombel_group[i]['list_siswa'].length; j++) {
                  if (rombel_group[i]['list_siswa'][j].style.learningStyle.contains("Visual")) {
                    rombel_group[i]['visual_count'] += 1;
                  } else if (rombel_group[i]['list_siswa'][j].style.learningStyle.contains("Auditorial")) {
                    rombel_group[i]['auditorial_count'] += 1;
                  } else if (rombel_group[i]['list_siswa'][j].style.learningStyle.contains("Kinestetik")) {
                    rombel_group[i]['kinestetik_count'] += 1;
                  }
                }

                int total_count = rombel_group[i]['visual_count'] + rombel_group[i]['auditorial_count'] + rombel_group[i]['kinestetik_count'];
                var visualRatio = (rombel_group[i]['visual_count'] * 100)/total_count;
                var auditorialRatio = (rombel_group[i]['auditorial_count'] * 100)/total_count;
                var kinestetikRatio = (rombel_group[i]['kinestetik_count'] * 100)/total_count;

                if (kinestetikRatio == visualRatio && kinestetikRatio == auditorialRatio) {
                  rombel_group[i]['description'] =
                  "Siswa di rombel ini memiliki cara belajar yang hampir seimbang. Gaya belajar "
                      "yang ada berimbang tersebut perlu diakomodir oleh guru yang mampu mengaplikasikan setiap jenis cara mengajar "
                      "yang bisa dimengerti oleh setiap siswa dengan gaya belajar yang berbeda tersebut.";
                }
                else if (kinestetikRatio == auditorialRatio && kinestetikRatio > visualRatio) {
                  rombel_group[i]['description'] =
                  "Siswa di rombel ini dominan memiliki cara belajar dengan mempraktikkan apa yang sebenarnya dijelaskan oleh guru, ataupun"
                      " dengan mendengar materi yang dijelaskan menggunakan metode ceramah atau diskusi langsung. Beberapa siswa lainnya cenderung "
                      "suka dengan memperhatikan materi dalam bentuk gambar karena mereka mudah memahami penjelasan dengan gambar atau ilustrasi.";
                }
                else if (kinestetikRatio < auditorialRatio && auditorialRatio == visualRatio) {
                  rombel_group[i]['description'] =
                  "Siswa di rombel ini dominan memiliki cara belajar dengan mendengar materi yang dijelaskan menggunakan metode ceramah atau "
                      "diskusi langsung, ataupun dengan "
                      "memperhatikan materi dalam bentuk gambar karena mereka mudah memahami penjelasan dengan gambar atau ilustrasi. "
                      "Beberapa siswa lainnya cenderung mudah belajar dengan cara mempraktikkannya secara langsung apa yang dijelaskan oleh guru.";
                }
                else if (kinestetikRatio > auditorialRatio && kinestetikRatio == visualRatio) {
                  rombel_group[i]['description'] =
                  "Siswa di rombel ini dominan mudah belajar dengan cara mempraktikkannya secara langsung apa yang dijelaskan oleh guru, "
                      "ataupun dengan memperhatikan materi dalam bentuk gambar karena mereka mudah memahami penjelasan dengan gambar atau ilustrasi. "
                      "Beberapa siswa lainnya cenderung mudah belajar dengan mendengar materi yang dijelaskan menggunakan metode ceramah atau "
                      "diskusi langsung";
                }
                else if (kinestetikRatio > auditorialRatio && kinestetikRatio > visualRatio) {
                  rombel_group[i]['description'] =
                  "Sebagian besar siswa di rombel ini cenderung belajar dengan mempraktikkan "
                      "apa yang sebenarnya dijelaskan oleh guru. Sebagian besar siswa di rombel ini akan cocok diberikan tugas "
                      "berupa tugas praktik yang membuat mereka mampu memahami cara penyelesaian dari tugas tersebut melalui "
                      "metode gerakan. Beberapa siswa lainnya baik dalam hal mendengarkan materi dan memperhatikan materi berupa gambar "
                      "yang dijelaskan oleh guru.";
                } else if (visualRatio > auditorialRatio && visualRatio > kinestetikRatio) {
                  rombel_group[i]['description'] =
                  "Sebagian besar siswa di rombel ini cenderung belajar dengan memperhatikan "
                      "materi yang dijelaskan oleh guru dalam bentuk ilustrasi atau gambar. Sebagian besar siswa di rombel ini "
                      "akan cocok diberikan tugas yang mampu mengembangkan kreativitas dalam menggambar atau mengilustrasikan suatu "
                      "permasalahan. Beberapa siswa lainnya baik dalam hal mendengarkan materi dan mempraktikkan materi "
                      "yang dijelaskan oleh guru.";
                } else {
                  rombel_group[i]['description'] =
                  "Sebagian besar siswa di rombel ini cenderung belajar dengan mendengar "
                      "materi yang disampaikan oleh guru ketika kegiatan belajar mengajar berlangsung. Sebagian besar siswa di rombel ini "
                      "Bagi siswa tersebut, guru perlu memaksimalkan kemampuan mereka dalam menyimak materi yang mereka sampaikan. "
                      "Beberapa siswa lainnya baik dalam hal memperhatikan materi dan mempraktikkan materi "
                      "yang dijelaskan oleh guru.";
                }
              }

              emit(SuccessState({
                  "list_teacher": list_teacher,
                  "rombel_siswa": rombel_group
                }));
            }
          }
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