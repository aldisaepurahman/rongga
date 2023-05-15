import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/student/student_event.dart';
import 'package:non_cognitive/data/bloc/student/student_quest_bloc.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/ui/components/card/family_card.dart';
import 'package:non_cognitive/ui/components/card/psychology_card.dart';
import 'package:non_cognitive/ui/components/card/statistics_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/questionnaire/questionnaire.dart';
import 'package:non_cognitive/utils/question_list.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentHome extends StatefulWidget {
  final UserType type;
  final Student? student;
  final bool expandedContents;

  const StudentHome({super.key, required this.type, required this.expandedContents, this.student});

  @override
  _StudentHome createState() => _StudentHome();

}

class _StudentHome extends State<StudentHome> {
  bool needConfirmation = true;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  StudentStyle _studentStyle = StudentStyle();

  Student _student = Student(
      idNumber: "",
      name: "",
      email: "",
      password: "",
      gender: "",
      no_telp: "",
      photo: "",
      address: "",
      type: UserType.SISWA,
      id_sekolah: 0,
      id_tahun_ajaran: 0,
      tahun_ajaran: '',
      token: ''
  );

  void initProfile() async {
    final SharedPreferences prefs = await _prefs;
    final String user = prefs.getString("user") ?? "";

    setState(() {
      if (widget.student != null) {
        _student = widget.student!;
      } else {
        _student = Student.fromJson(jsonDecode(user));
      }

      BlocProvider.of<StudentQuestBloc>(context).add(ResetEvent());
      BlocProvider.of<StudentQuestBloc>(context).add(StudentTestResults(id_siswa: _student.id_siswa!, id_tahun_ajaran: _student.id_tahun_ajaran!));
    });
  }

  @override
  void initState() {
    super.initState();
    initProfile();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: widget.type,
        menu_name: "Beranda",
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.type != UserType.SISWA)
                  Container(
                    margin: const EdgeInsets.only(top: 25, bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ButtonWidget(
                          background: gray,
                          tint: lightGray,
                          type: ButtonType.BACK,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
                  child: TextTypography(
                      text: "Statistik",
                      type: TextType.HEADER
                  ),
                )
              ],
            ),
            BlocConsumer<StudentQuestBloc, RonggaState>(
              listener: (_, state) {
                if (state is SuccessState) {
                  _studentStyle = state.datastore;
                  print("adat: ${_studentStyle.nis!}, coba : ${_studentStyle.learningStyle!}");
                }
              },
              builder: (_, state) {
                if (state is LoadingState) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } if (state is FailureState) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                        child: Text(
                            "Data gagal ditampilkan, terjadi error pada sistem!")),
                  );
                } if (state is SuccessState) {
                  if (_studentStyle.nis!.isNotEmpty) {
                    return _renderExtendedPage(widget.type, _studentStyle);
                  } else if (widget.type != UserType.SISWA) {
                    return Center(
                        child: TextTypography(
                          type: TextType.DESCRIPTION,
                          text: "Siswa ini belum melakukan tes gaya belajar di tahun ajaran saat ini",
                          align: TextAlign.center,
                        )
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextTypography(
                            type: TextType.DESCRIPTION,
                            text: "Anda belum pernah melakukan tes di tahun ajaran saat ini\nSilahkan ikuti tes terlebih dahulu",
                            align: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ButtonWidget(
                            background: green,
                            tint: white,
                            type: ButtonType.LARGE,
                            content: "Mulai Tes",
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const Questionnaire(),
                                  ));
                            },
                          )
                        ],
                      ),
                    );
                  }
                }
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text("Tidak Ada Data")),
                );
              },
            ),
          ],
        )
    );
  }

  ListView _renderExtendedPage(UserType type, StudentStyle student_style) {
    String _descriptionStyle = "";

    if (student_style.learningStyle! == "Gabungan (All)") {
      _descriptionStyle = type == UserType.SISWA
          ? "Anda akan cocok dengan cara belajar apapun" : "Siswa ini cocok dengan cara belajar apapun";
    } else if (student_style.learningStyle! == "Gabungan (Kinestetik + Auditorial)") {
      _descriptionStyle = type == UserType.SISWA
          ? "Anda akan cocok dengan cara berbasis studi kasus atau sambil fokus mendengarkan materi yang diberikan"
          : "Siswa ini cocok dengan cara berbasis studi kasus atau sambil fokus mendengarkan materi yang diberikan";
    } else if (student_style.learningStyle! == "Gabungan (Visual + Kinestetik)") {
      _descriptionStyle = type == UserType.SISWA
          ? "Anda akan cocok dengan cara berbasis studi kasus atau diberikan suatu gambar atau visualisasi dari materi yang dipaparkan"
          : "Siswa ini cocok dengan cara berbasis studi kasus atau diberikan suatu gambar atau visualisasi dari materi yang dipaparkan";
    } else if (student_style.learningStyle! == "Gabungan (Visual + Auditorial)") {
      _descriptionStyle = type == UserType.SISWA
          ? "Anda akan cocok dengan cara sambil fokus mendengarkan materi yang diberikan atau diberikan suatu gambar atau visualisasi dari materi yang dipaparkan"
          : "Siswa ini cocok dengan cara sambil fokus mendengarkan materi yang diberikan atau diberikan suatu gambar atau visualisasi dari materi yang dipaparkan";
    } else if (student_style.learningStyle! == "Kinestetik") {
      _descriptionStyle = type == UserType.SISWA
          ? "Anda akan cocok dengan cara berbasis studi kasus"
          : "Siswa ini cocok dengan cara berbasis studi kasus";
    } else if (student_style.learningStyle! == "Auditorial") {
      _descriptionStyle = type == UserType.SISWA
          ? "Anda akan cocok dengan cara fokus mendengarkan materi yang diberikan"
          : "Siswa ini cocok dengan cara fokus mendengarkan materi yang diberikan";
    } else {
      _descriptionStyle = type == UserType.SISWA
          ? "Anda akan cocok dengan cara diberikan suatu gambar atau visualisasi dari materi yang dipaparkan"
          : "Siswa ini cocok dengan cara diberikan suatu gambar atau visualisasi dari materi yang dipaparkan";
    }

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 25),
      children: [
        /*if (type == UserType.SISWA)
          Visibility(
            visible: needConfirmation,
            child: Container(
                margin: const EdgeInsets.only(left: 12, right: 12, bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextTypography(
                              type: TextType.TITLE,
                              text: "Perhatian!",
                            ),
                            TextTypography(
                              type: TextType.DESCRIPTION,
                              text: "Anda dinyatakan naik kelas menuju tingkat berikutnya.",
                            ),
                          ],
                        )
                    ),
                    const SizedBox(width: 10),
                    ButtonWidget(
                      background: orange,
                      tint: white,
                      type: ButtonType.MEDIUM,
                      content: "Baik",
                      onPressed: () {
                        setState(() {
                          needConfirmation = false;
                        });
                      },
                    )
                  ],
                )
            )
        ),*/
        StatisticsCard(student_style: student_style),
        PsychologyCard(
            title: "Saran Metode Belajar",
            chartTitle: "Diagram Kesejahteraan Psikologi",
          description: _descriptionStyle,
        ),
        /*const PsychologyCard(
            title: "Aktivitas Belajar",
            chartTitle: "Diagram Aktivitas Belajar"
        ),
        FamilyCard(items: family_questions_dummy)*/
      ],
    );
  }
}