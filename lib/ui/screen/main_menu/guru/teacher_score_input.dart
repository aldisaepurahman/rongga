import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/teacher/student_mapel_bloc.dart';
import 'package:non_cognitive/data/bloc/teacher/student_mapel_score_bloc.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_event.dart';
import 'package:non_cognitive/data/model/nilai_akhir_input.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/ui/components/card/biodata_card.dart';
import 'package:non_cognitive/ui/components/card/final_score_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_no_button.dart';
import 'package:non_cognitive/ui/components/dialog/loading_dialog.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/utils/mapel_nilai_list.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherScoreInput extends StatefulWidget {
  final UserType type;
  final Student student;

  const TeacherScoreInput({super.key, required this.type, required this.student});

  @override
  State<StatefulWidget> createState() => _TeacherScoreInput();

}

class _TeacherScoreInput extends State<TeacherScoreInput> {
  List<NilaiAkhirInput> list_nilai = <NilaiAkhirInput>[];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Teacher _teacher = Teacher(
      idNumber: "",
      name: "",
      email: "",
      password: "",
      gender: "",
      no_telp: "",
      photo: "",
      address: "",
      type: UserType.GURU,
      id_sekolah: 0,
      id_tahun_ajaran: 0,
      tahun_ajaran: '',
      token: ''
  );

  bool isSubmitted = false;

  void initProfile() async {
    final SharedPreferences prefs = await _prefs;
    final String user = prefs.getString("user") ?? "";

    setState(() {
      _teacher = Teacher.fromJson(jsonDecode(user));
    });
  }

  @override
  void initState() {
    super.initState();
    initProfile();

    var mapp = {
      "tingkat": widget.student.tingkat,
      "id_siswa": widget.student.id_siswa,
      "id_tahun_ajaran": widget.student.id_tahun_ajaran,
      "id_sekolah": widget.student.id_sekolah,
      "rombel": widget.student.rombel
    };
    Future.delayed(Duration.zero, () {
      BlocProvider.of<StudentMapelBloc>(context).add(StudentScoreExists(criterias: mapp, token: _teacher.token!));
    });
  }

  void showSubmitDialog(int dialogType) {
    String imgPath = (dialogType > 1)
        ? (dialogType == 2)
        ? "assets/images/success.json"
        : "assets/images/incorrect.json"
        : "assets/images/loading_icon.json";
    String content = (dialogType > 1)
        ? (dialogType == 2)
        ? "Nilai akhir siswa berhasil ditambahkan."
        : "Duh, terjadi masalah dengan server aplikasi, coba lagi."
        : "";

    showDialog(
      context: context,
      builder: (context) {
        if (dialogType == 2) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<StudentMapelScoreBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 3) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<StudentMapelScoreBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 4) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<StudentMapelScoreBloc>(context).add(ResetEvent());
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

  void submitWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content: "Apakah anda yakin dengan perubahan ini?",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            isSubmitted = true;
            BlocProvider.of<StudentMapelScoreBloc>(context).add(StudentScoreInput(scores: list_nilai, token: _teacher.token!));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: widget.type,
        menu_name: "Cari Siswa",
        floatingButton: ButtonWidget(
          background: orange,
          tint: black,
          type: ButtonType.FLOAT,
          icon: Icons.save,
          onPressed: () {
            submitWarningDialog();
          },
        ),
        child: ListView(
          children: [
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
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
                  child: TextTypography(
                      text: "Nilai Akhir",
                      type: TextType.HEADER
                  ),
                )
              ],
            ),
            BiodataCard(user_data: widget.student),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: TextTypography(
                type: TextType.TITLE,
                text: "Kolom Nilai Akhir",
                align: TextAlign.center,
              ),
            ),
            BlocConsumer<StudentMapelBloc, RonggaState>(
              listener: (_, state) {
                if (state is SuccessState) {
                  list_nilai.clear();

                  if (widget.type == UserType.GURU) {
                    List<NilaiAkhirInput> lists = state.datastore;
                    for (var lst in lists) {
                      if (lst.nama_mapel!.contains(_teacher.spesialisasi!)) {
                        list_nilai.add(lst);
                      }
                    }
                  } else {
                    list_nilai = state.datastore;
                  }
                }
              },
              builder: (_, state) {
                if (state is LoadingState) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is FailureState) {
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
                              var mapp = {
                                "tingkat": widget.student.tingkat,
                                "id_siswa": widget.student.id_siswa,
                                "id_tahun_ajaran": widget.student.id_tahun_ajaran,
                                "id_sekolah": widget.student.id_sekolah,
                                "rombel": widget.student.rombel
                              };

                              BlocProvider.of<StudentMapelBloc>(context).add(StudentScoreExists(criterias: mapp, token: _teacher.token!));
                            },
                          )
                        ],
                      )
                  );
                } else if (state is SuccessState) {
                  return CardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var nilai_akhir in list_nilai)
                            FinalScoreCard(nama_mapel: nilai_akhir.nama_mapel!, nilai: nilai_akhir.nilai!, onScoreChanged: (value) {nilai_akhir.nilai = value;})
                        ],
                      )
                  );
                }
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text("Tidak Ada Nilai yang perlu diinput")),
                );
              },
            ),
            /*CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.type == UserType.GURU)
                    for (var nilai_akhir in nilai_akhir_list_guru_mapel)
                      FinalScoreCard(nama_mapel: nilai_akhir.nama_mapel, nilai: nilai_akhir.nilai, onScoreChanged: (value) {})
                  else
                    for (var nilai_akhir in nilai_akhir_list_all)
                      FinalScoreCard(nama_mapel: nilai_akhir.nama_mapel, nilai: nilai_akhir.nilai, onScoreChanged: (value) {})
                ],
              )
            )*/
            BlocConsumer<StudentMapelScoreBloc, RonggaState>(
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
          ],
        )
    );
  }

}