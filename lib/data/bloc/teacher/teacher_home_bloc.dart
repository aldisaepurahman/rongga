import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_event.dart';
import 'package:non_cognitive/data/model/nilai_akhir_input.dart';
import 'package:non_cognitive/data/model/rombel_siswa.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/data/rongga_service.dart';

class TeacherHomeBloc extends Bloc<Events, RonggaState> {
  TeacherHomeBloc() : super(EmptyState()) {
    on<StudentRombelSearch>(_searchRombel);
    on<ResetEvent>(_resetPage);
  }

  Future<void> _searchRombel(StudentRombelSearch event, Emitter<RonggaState> emit) async {
    try {
      emit(LoadingState());
      final RonggaService service = RonggaService();
      await Future.wait([
        service.getRombelSearch({
          "wali_kelas": event.wali_kelas,
          "id_sekolah": event.id_sekolah,
          "id_guru": event.id_guru,
          "tingkat": event.tingkat,
          "rombel": event.rombel
        }, event.token),
        service.getAllTestResults({"id_tahun_ajaran": event.id_tahun_ajaran}, event.token),
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

          Map<String, dynamic> maps = {
            'id_sekolah': event.id_sekolah,
            'description': "",
            'list_siswa': <StudentStyle>[],
            'visual_count': 0,
            'auditorial_count': 0,
            'kinestetik_count': 0
          };

          for (var i = 0; i < list_siswa.length; i++) {
            int idxQuest = quests.indexWhere((row) => row.nis == list_siswa[i].idNumber);
            if (idxQuest >= 0) {
              maps['list_siswa'].add(quests[i]);
            }
          }

          for (var i = 0; i < maps['list_siswa'].length; i++) {
            if (!maps['list_siswa'][i].learningStyle!.contains("Tidak Diketahui")) {
              if (maps['list_siswa'][i].learningStyle!.contains("Visual")) {
                maps['visual_count'] += 1;
              } else
              if (maps['list_siswa'][i].learningStyle!.contains("Auditorial")) {
                maps['auditorial_count'] += 1;
              } else
              if (maps['list_siswa'][i].learningStyle!.contains("Kinestetik")) {
                maps['kinestetik_count'] += 1;
              }
            }
          }

          int total_count = maps['visual_count'] + maps['auditorial_count'] + maps['kinestetik_count'];
          var visualRatio = (maps['visual_count'] * 100) / total_count;
          var auditorialRatio = (maps['auditorial_count'] *
              100) / total_count;
          var kinestetikRatio = (maps['kinestetik_count'] *
              100) / total_count;

          if (kinestetikRatio == visualRatio && kinestetikRatio == auditorialRatio) {
            maps['description'] =
            "Siswa di rombel ini memiliki cara belajar yang hampir seimbang. Gaya belajar "
                "yang ada berimbang tersebut perlu diakomodir oleh guru yang mampu mengaplikasikan setiap jenis cara mengajar "
                "yang bisa dimengerti oleh setiap siswa dengan gaya belajar yang berbeda tersebut.";
          }
          else if (kinestetikRatio == auditorialRatio && kinestetikRatio > visualRatio) {
            maps['description'] =
            "Siswa di rombel ini dominan memiliki cara belajar dengan mempraktikkan apa yang sebenarnya dijelaskan oleh guru, ataupun"
                " dengan mendengar materi yang dijelaskan menggunakan metode ceramah atau diskusi langsung. Beberapa siswa lainnya cenderung "
                "suka dengan memperhatikan materi dalam bentuk gambar karena mereka mudah memahami penjelasan dengan gambar atau ilustrasi.";
          }
          else if (kinestetikRatio < auditorialRatio && auditorialRatio == visualRatio) {
            maps['description'] =
            "Siswa di rombel ini dominan memiliki cara belajar dengan mendengar materi yang dijelaskan menggunakan metode ceramah atau "
                "diskusi langsung, ataupun dengan "
                "memperhatikan materi dalam bentuk gambar karena mereka mudah memahami penjelasan dengan gambar atau ilustrasi. "
                "Beberapa siswa lainnya cenderung mudah belajar dengan cara mempraktikkannya secara langsung apa yang dijelaskan oleh guru.";
          }
          else if (kinestetikRatio > auditorialRatio && kinestetikRatio == visualRatio) {
            maps['description'] =
            "Siswa di rombel ini dominan mudah belajar dengan cara mempraktikkannya secara langsung apa yang dijelaskan oleh guru, "
                "ataupun dengan memperhatikan materi dalam bentuk gambar karena mereka mudah memahami penjelasan dengan gambar atau ilustrasi. "
                "Beberapa siswa lainnya cenderung mudah belajar dengan mendengar materi yang dijelaskan menggunakan metode ceramah atau "
                "diskusi langsung";
          }
          else if (kinestetikRatio > auditorialRatio && kinestetikRatio > visualRatio) {
            maps['description'] =
            "Sebagian besar siswa di rombel ini cenderung belajar dengan mempraktikkan "
                "apa yang sebenarnya dijelaskan oleh guru. Sebagian besar siswa di rombel ini akan cocok diberikan tugas "
                "berupa tugas praktik yang membuat mereka mampu memahami cara penyelesaian dari tugas tersebut melalui "
                "metode gerakan. Beberapa siswa lainnya baik dalam hal mendengarkan materi dan memperhatikan materi berupa gambar "
                "yang dijelaskan oleh guru.";
          } else if (visualRatio > auditorialRatio && visualRatio > kinestetikRatio) {
            maps['description'] =
            "Sebagian besar siswa di rombel ini cenderung belajar dengan memperhatikan "
                "materi yang dijelaskan oleh guru dalam bentuk ilustrasi atau gambar. Sebagian besar siswa di rombel ini "
                "akan cocok diberikan tugas yang mampu mengembangkan kreativitas dalam menggambar atau mengilustrasikan suatu "
                "permasalahan. Beberapa siswa lainnya baik dalam hal mendengarkan materi dan mempraktikkan materi "
                "yang dijelaskan oleh guru.";
          } else {
            maps['description'] =
            "Sebagian besar siswa di rombel ini cenderung belajar dengan mendengar "
                "materi yang disampaikan oleh guru ketika kegiatan belajar mengajar berlangsung. Sebagian besar siswa di rombel ini "
                "Bagi siswa tersebut, guru perlu memaksimalkan kemampuan mereka dalam menyimak materi yang mereka sampaikan. "
                "Beberapa siswa lainnya baik dalam hal memperhatikan materi dan mempraktikkan materi "
                "yang dijelaskan oleh guru.";
          }

          emit(SuccessState(maps));
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