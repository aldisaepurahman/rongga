import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/student/student_event.dart';
import 'package:non_cognitive/data/bloc/student/student_quest_bloc.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/ui/components/card/question_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_no_button.dart';
import 'package:non_cognitive/ui/components/dialog/loading_dialog.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/home_student.dart';
import 'package:non_cognitive/ui/screen/navigations.dart';
import 'package:non_cognitive/utils/questionnaire_list.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({super.key});

  @override
  State<StatefulWidget> createState() => _Questionnaire();
}

class _Questionnaire extends State<Questionnaire> {
  final _controller = PageController();
  static const _duration = Duration(milliseconds: 300);
  static const _curve = Curves.ease;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

  List<int> countAnswers = <int>[0, 0, 0];
  bool isSubmitted = false;

  void backWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content:
              "Jawaban yang anda pilih tidak akan tersimpan. Anda yakin akan membatalkan tes ini?",
          path_image: "assets/images/caution.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const StudentHome(type: UserType.SISWA, expandedContents: true),
                ));
          },
        );
      },
    );
  }

  void submitWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content: "Apakah anda yakin dengan jawaban yang anda pilih?",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            isSubmitted = true;
            submitQuest();
          },
        );
      },
    );
  }

  void showSubmitDialog(int dialogType) {
    String imgPath = (dialogType > 1)
        ? (dialogType == 2)
        ? "assets/images/success.json"
        : "assets/images/incorrect.json"
        : "assets/images/loading_icon.json";
    String content = (dialogType > 1)
        ? (dialogType == 2)
        ? "Hebat, kau berhasil menjawab semuanya, ayo cek hasil tesmu."
        : "Duh, terjadi masalah dengan server aplikasi, coba lagi."
        : "";

    showDialog(
      context: context,
      builder: (context) {
        if (dialogType == 2) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<StudentQuestBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const StudentHome(type: UserType.SISWA, expandedContents: true),
                ));
          });
        } else if (dialogType == 3) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<StudentQuestBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 4) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<StudentQuestBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
          });
        }
        if (dialogType > 1) {
          return DialogNoButton(path_image: imgPath, content: content);
        }
        return LoadingDialog(path_image: imgPath);
      },
    );
  }

  void submitQuest() {
    List<Map<String, dynamic>> quests = <Map<String, dynamic>>[];

    for (var i = 0; i < questionnaire_list.length; i++) {
      for (var questions in questionnaire_list[i].question_list) {
        var mapping = {
          "id_siswa": _student.id_siswa,
          "id_question": questions.id,
          "id_tahun_ajaran": _student.id_tahun_ajaran,
          "id_choice": (4 - questions.choices.indexWhere((element) => element.contains(questions.groupValue)))
        };

        quests.add(mapping);
      }
    }

    BlocProvider.of<StudentQuestBloc>(context).add(StudentQuestionnaire(quests: quests));
  }

  void resetForm() {
    for (var i = 0; i < questionnaire_list.length; i++) {
      for (var questions in questionnaire_list[i].question_list) {
        questions.groupValue = "";
        questions.alternativeValue = "";
      }

      countAnswers[i] = 0;
    }
  }

  void initProfile() async {
    final SharedPreferences prefs = await _prefs;
    final String user = prefs.getString("user") ?? "";

    setState(() {
      _student = Student.fromJson(jsonDecode(user));
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
        type: UserType.SISWA,
        menu_name: "Lembar Tes",
        child: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) {},
          children: [
            for (var i = 0; i < questionnaire_list.length; i++)
              ListView(shrinkWrap: true, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                              backWarningDialog();
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
                      child: TextTypography(
                          text: "Lembar Tes",
                          type: TextType.HEADER
                      ),
                    )
                  ],
                ),
                CardContainer(
                    child: Column(
                      children: [
                        TextTypography(
                          type: TextType.TITLE,
                          text: questionnaire_list[i].title,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextTypography(
                              type: TextType.DESCRIPTION,
                              text: questionnaire_list[i].description,
                            )),
                      ],
                    )),
                for (var questions in questionnaire_list[i].question_list)
                  QuestionCard(
                    question: questions,
                    onSelectedChoice: (value) {
                      if (questions.groupValue.isEmpty) {
                        countAnswers[i] += 1;
                      }
                      questions.groupValue = value!;
                    },
                    onAlternativeFilled: (value) {
                      questions.alternativeValue = value;
                    },
                  ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (i > 0)
                          ButtonWidget(
                            background: green,
                            tint: green,
                            type: ButtonType.OUTLINED_SMALL,
                            content: "Sebelumnya",
                            onPressed: () {
                              _controller.previousPage(
                                  duration: _duration, curve: _curve);
                            },
                          ),
                        const SizedBox(width: 10),
                        ButtonWidget(
                          background: green,
                          tint: white,
                          type: ButtonType.SMALL,
                          content: (i != questionnaire_list.length - 1)
                              ? "Selanjutnya"
                              : "Selesai",
                          onPressed: () {
                            if (countAnswers[i] == 10) {
                              (i != questionnaire_list.length - 1)
                                  ? _controller.nextPage(
                                  duration: _duration, curve: _curve)
                                  : submitWarningDialog();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Pastikan semua soal sudah terjawab ya.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 12.0);
                            }
                          },
                        )
                      ],
                    )),
                if (i == questionnaire_list.length-1) ...[
                  BlocConsumer<StudentQuestBloc, RonggaState>(
                    listener: (_, state) {},
                    builder: (_, state) {
                      if (state is LoadingState) {
                        if (isSubmitted) {
                          Future.delayed(const Duration(seconds: 1), () {
                            showSubmitDialog(1);
                          });
                        }
                      }
                      if (state is FailureState) {
                        isSubmitted = !isSubmitted;
                        Future.delayed(const Duration(seconds: 1), () {
                          showSubmitDialog(3);
                        });
                      }
                      if (state is CrudState) {
                        isSubmitted = !isSubmitted;
                        if (state.datastore) {
                          resetForm();
                          Future.delayed(const Duration(seconds: 1), () {
                            showSubmitDialog(2);
                          });
                        } else {
                          Future.delayed(const Duration(seconds: 1), () {
                            showSubmitDialog(3);
                          });
                        }
                      }
                      return const SizedBox(width: 0);
                    },
                  )
                ]
              ]),
          ],
        )
    );
  }
}
