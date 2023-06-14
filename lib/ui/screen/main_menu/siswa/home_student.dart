import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/student/student_event.dart';
import 'package:non_cognitive/data/bloc/student/student_quest_bloc.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/ui/components/card/biodata_card.dart';
import 'package:non_cognitive/ui/components/card/family_card.dart';
import 'package:non_cognitive/ui/components/card/psychology_card.dart';
import 'package:non_cognitive/ui/components/card/statistics_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/questionnaire/questionnaire.dart';
import 'package:non_cognitive/utils/learn_method_asset.dart';
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
  bool cardVisible = true;

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
      cardVisible = prefs.getBool("homeCard") ?? true;

      BlocProvider.of<StudentQuestBloc>(context).add(ResetEvent());
      BlocProvider.of<StudentQuestBloc>(context).add(StudentTestResults(id_siswa: _student.id_siswa!, tahun_ajaran: _student.tahun_ajaran!));
    });
  }

  @override
  void initState() {
    super.initState();
    initProfile();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: MainLayout(
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
                    }
                  },
                  builder: (_, state) {
                    if (state is LoadingState) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } if (state is FailureState) {
                      return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset("assets/images/incorrect.json",
                                  repeat: true, animate: true, reverse: false),
                              const SizedBox(height: 10),
                              TextTypography(
                                type: TextType.HEADER,
                                text: "Data gagal ditampilkan, terjadi error pada sistem!",
                                align: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ButtonWidget(
                                background: blue,
                                tint: white,
                                type: ButtonType.LARGE,
                                content: "Coba Lagi",
                                onPressed: () {
                                  BlocProvider.of<StudentQuestBloc>(context).add(ResetEvent());
                                  BlocProvider.of<StudentQuestBloc>(context).add(StudentTestResults(id_siswa: _student.id_siswa!, tahun_ajaran: _student.tahun_ajaran!));
                                },
                              )
                            ],
                          )
                      );
                      /*return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                        child: Text(
                            "Data gagal ditampilkan, terjadi error pada sistem!")),
                  );*/
                    } if (state is SuccessState) {
                      if (_studentStyle.nis!.isNotEmpty) {
                        return _renderExtendedPage(widget.type, _studentStyle);
                      } else if (widget.type != UserType.SISWA) {
                        return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset("assets/images/no-data.json",
                                    repeat: true, animate: true, reverse: false),
                                const SizedBox(height: 10),
                                TextTypography(
                                  type: TextType.HEADER,
                                  text: "Siswa ini belum melakukan tes gaya belajar di tahun ajaran saat ini",
                                  align: TextAlign.center,
                                )
                              ],
                            )
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset("assets/images/no-data.json",
                                  repeat: true, animate: true, reverse: false),
                              const SizedBox(height: 10),
                              TextTypography(
                                type: TextType.HEADER,
                                text: "Sepertinya tahun ini kamu belum mengambil tes terbaru\nSelesaikan tes terbarumu ya.",
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
                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset("assets/images/no-data.json",
                                repeat: true, animate: true, reverse: false),
                            const SizedBox(height: 10),
                            TextTypography(
                              type: TextType.HEADER,
                              text: "Wah, tidak ada data yang ditemukan",
                              align: TextAlign.center,
                            )
                          ],
                        )
                    );
                  },
                ),
              ],
            )
        ),
    );
  }

  ListView _renderExtendedPage(UserType type, StudentStyle student_style) {
    List<Map<String, String>> psychologyItem = <Map<String, String>>[];

    if (student_style.learningStyle! == "Gabungan (All)") {
      psychologyItem.addAll(visualMethod);
      psychologyItem.addAll(auditorialMethod);
      psychologyItem.addAll(kinesteticMethod);
    } else if (student_style.learningStyle! == "Gabungan (Kinestetik + Auditorial)") {
      psychologyItem.addAll(kinesteticMethod);
      psychologyItem.addAll(auditorialMethod);
    } else if (student_style.learningStyle! == "Gabungan (Visual + Kinestetik)") {
      psychologyItem.addAll(visualMethod);
      psychologyItem.addAll(kinesteticMethod);
    } else if (student_style.learningStyle! == "Gabungan (Visual + Auditorial)") {
      psychologyItem.addAll(visualMethod);
      psychologyItem.addAll(auditorialMethod);
    } else if (student_style.learningStyle! == "Kinestetik") {
      psychologyItem.addAll(kinesteticMethod);
    } else if (student_style.learningStyle! == "Auditorial") {
      psychologyItem.addAll(auditorialMethod);
    } else {
      psychologyItem.addAll(visualMethod);
    }

    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 15),
      children: [
        Visibility(
          visible: cardVisible,
            child: CardContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Lottie.asset("assets/images/waving.json",
                            repeat: true, animate: true, reverse: false, height: MediaQuery.of(context).size.height * 0.1)),
                    Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextTypography(
                                type: TextType.TITLE,
                                text: type == UserType.SISWA
                                    ? "Halo ${_student.name}. Selamat datang di Rongga. Disini kamu bisa lihat seperti apa hasil tes gaya belajar "
                                    "yang kamu miliki. Selain itu, kamu juga bisa tau seperti apa cara belajar yang sesuai dengan gaya belajar yang kamu miliki."
                                    : "Halo bapak/ibu guru, Selamat datang di Rongga. Disini saya infokan bagaimana hasil tes gaya belajar dari ${_student.name} ya.",
                              ),
                              if (!kIsWeb) ...[
                                const SizedBox(height: 20),
                                ButtonWidget(
                                  background: green,
                                  tint: white,
                                  type: ButtonType.MEDIUM,
                                  content: "Mengerti",
                                  onPressed: () async {
                                    setState(() {
                                      cardVisible = false;
                                    });
                                    final SharedPreferences prefs = await _prefs;
                                    prefs.setBool("homeCard", cardVisible);
                                  },
                                )
                              ]
                            ],
                          ),
                        )
                    )
                  ],
                )
            )
        ),
        BiodataCard(user_data: _student, fullBio: false),
        StatisticsCard(student_style: student_style),
        PsychologyCard(
          title: "Saran Metode Belajar",
          information: psychologyItem,
        )
      ],
    );
  }
}