import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_create_event.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_siswa_add_bloc.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_siswa_check_bloc.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_siswa_delete_bloc.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_siswa_make_bloc.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/ui/components/card/rombel_card.dart';
import 'package:non_cognitive/ui/components/card/tingkat_only_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_no_button.dart';
import 'package:non_cognitive/ui/components/dialog/loading_dialog.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru_bk/rombel_check_page.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru_bk/rombel_page.dart';
import 'package:non_cognitive/utils/table_assets.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateRombel extends StatefulWidget {
  final UserType type;
  bool extendedContents;

  CreateRombel({super.key, required this.type, required this.extendedContents});

  @override
  State<StatefulWidget> createState() => _CreateRombel();

}

class _CreateRombel extends State<CreateRombel> {
  String tingkatChoice = "VII (Tujuh)";
  final rombelController = TextEditingController();
  final _controller = PageController();
  static const _duration = Duration(milliseconds: 300);
  static const _curve = Curves.ease;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int index = 0;
  int indexAdd = 0;

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

  List<String> listGuruOpt = <String>[];
  List<String> listGuruChoose = <String>[];
  List<Teacher> listTeacher = <Teacher>[];
  List<Student> listStudentTemp = <Student>[];
  List<Map<String, dynamic>> listPageRombel = <Map<String, dynamic>>[];
  bool hasGroup = false;
  bool isSubmitted = false;
  int allStudents = 0;

  final Map<String, int> tingkatKelasOpt = {
    "VII (Tujuh)": 7,
    "VIII (Delapan)": 8,
    "IX (Sembilan)": 9,
  };

  void initProfile() async {
    final SharedPreferences prefs = await _prefs;
    final String user = prefs.getString("user") ?? "";
    print("infokan $user");

    setState(() {
      _teacher = Teacher.fromJson(jsonDecode(user));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    rombelController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initProfile();
  }

  void submitWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content: "Apakah anda yakin dengan hasil yang ditampilkan?",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            isSubmitted = true;
            validateAndSend();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void resetWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content: "Apakah anda yakin akan mengatur ulang seluruh rombel siswa yang dipilih?",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            BlocProvider.of<RombelSiswaDeleteBloc>(context).add(
                DeleteRombelSiswa(
                    id_tahun_ajaran: _teacher.id_tahun_ajaran!,
                    id_sekolah: _teacher.id_sekolah!,
                    tingkat: tingkatKelasOpt[tingkatChoice]!
                ));
            BlocProvider.of<RombelSiswaDeleteBloc>(context).add(ResetEvent());
            BlocProvider.of<RombelSiswaMakeBloc>(context).add(
                MakeRombelSiswa(
                    id_tahun_ajaran: _teacher.id_tahun_ajaran!,
                    id_sekolah: _teacher.id_sekolah!,
                    tingkat: tingkatKelasOpt[tingkatChoice]!
                ));
            BlocProvider.of<RombelSiswaCheckBloc>(context).add(ResetEvent());
            setState(() {
              widget.extendedContents = true;
              allStudents = 0;
              listStudentTemp.clear();
            });
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
        ? "Hore, rombel di tingkat ini sudah dibuat."
        : "Duh, terjadi masalah dengan server aplikasi, coba lagi."
        : "";

    showDialog(
      context: context,
      builder: (context) {
        if (dialogType == 2) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<RombelSiswaAddBloc>(context).add(ResetEvent());
            BlocProvider.of<RombelSiswaMakeBloc>(context).add(ResetEvent());
            setState(() {
              widget.extendedContents = false;
              index = 0;
              indexAdd = 0;
              listGuruOpt.clear();
              listStudentTemp.clear();
              listGuruChoose.clear();
              listTeacher.clear();
            });
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 3) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<RombelSiswaAddBloc>(context).add(ResetEvent());
            BlocProvider.of<RombelSiswaMakeBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 4) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<RombelSiswaAddBloc>(context).add(ResetEvent());
            BlocProvider.of<RombelSiswaMakeBloc>(context).add(ResetEvent());
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

  void validateAndSend() {
    List<Map<String, dynamic>> list_siswa = <Map<String, dynamic>>[];
    List<Map<String, dynamic>> list_wali = <Map<String, dynamic>>[];

    for (var i = 0; i < listPageRombel.length; i++) {
      for (var j = 0; j < listPageRombel[i]['list_siswa'].length; j++) {
        var mapping = {
          "id_siswa": listPageRombel[i]['list_siswa'][j].id_siswa,
          "id_tahun_ajaran": _teacher.id_tahun_ajaran,
          "id_rombel_sekolah": listPageRombel[i]['id_rombel']
        };

        list_siswa.add(mapping);
      }
      int idxGuru = listTeacher.indexWhere((row) => row.name == listGuruChoose[i]);

      var wali_mapping = {
        "id_guru": listTeacher[idxGuru].id_guru,
        "id_tahun_ajaran": _teacher.id_tahun_ajaran,
        "id_rombel_sekolah": listPageRombel[i]['id_rombel']
      };

      list_wali.add(wali_mapping);
    }
    BlocProvider.of<RombelSiswaAddBloc>(context).add(AddRombelSiswa(list_siswa: list_siswa, list_wali: list_wali));
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: widget.type,
        menu_name: "Buat Rombel",
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 25, bottom: 15),
                  child: TextTypography(
                      text: "Rombel Siswa",
                      type: TextType.HEADER
                  ),
                )
              ],
            ),
            TingkatOnlyCard(
                type: widget.type,
                tingkatSiswa: tingkatChoice,
                onSelectedChoice: (String value) {
                  tingkatChoice = value;
                },
                isEmpty: widget.extendedContents,
              listStudent: listStudentTemp,
              allStudent: allStudents,
              onPressedSubmit: () {
                BlocProvider.of<RombelSiswaCheckBloc>(context).add(
                    CheckRombelSiswa(
                        id_tahun_ajaran: _teacher.id_tahun_ajaran!,
                      id_sekolah: _teacher.id_sekolah!,
                      tingkat: tingkatKelasOpt[tingkatChoice]!
                    ));
              },
              onManualInput: () {

              },
              onReset: () {
                resetWarningDialog();
              },
            ),
            BlocConsumer<RombelSiswaCheckBloc, RonggaState>(
              listener: (_, state) {
                if (state is SuccessState) {
                  listStudentTemp.clear();
                  listPageRombel.clear();
                  setState(() {
                    listStudentTemp = state.datastore["list_student_temp"];
                    hasGroup = state.datastore["has_group"];
                    allStudents = state.datastore["allStudents"];
                  });

                  listPageRombel = state.datastore["rombel_siswa"];
                }
              },
              builder: (_, state) {
                if (state is LoadingState) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is FailureState) {
                  return Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                        child: TextTypography(
                          type: TextType.DESCRIPTION,
                          text: state.error,
                        )
                    ),
                  );
                } else if (state is SuccessState) {
                  if (hasGroup) {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 600,
                          child: PageView(
                              controller: _controller,
                              physics: const NeverScrollableScrollPhysics(),
                              onPageChanged: (value) {},
                              children: [
                                for (var i = 0; i < listPageRombel.length; i++)
                                  RombelCheckPage(
                                      rombel_name: listPageRombel[i]['rombel'],
                                      description: listPageRombel[i]['description'],
                                      tableHeader: ["No", "Nama Siswa", "Gaya Belajar - Level Akademik"],
                                      tableContent: listPageRombel[i]['list_siswa']
                                  ),
                              ]
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (index > 0)
                                  ButtonWidget(
                                    background: green,
                                    tint: green,
                                    type: ButtonType.OUTLINED,
                                    content: "Sebelumnya",
                                    onPressed: () {
                                      setState(() {
                                        index--;
                                      });
                                      _controller.previousPage(
                                          duration: _duration, curve: _curve);
                                    },
                                  ),
                                if (index != listPageRombel.length-1)...[
                                  const SizedBox(width: 10),
                                  ButtonWidget(
                                    background: green,
                                    tint: white,
                                    type: ButtonType.MEDIUM,
                                    content: "Selanjutnya",
                                    onPressed: () {
                                      _controller.nextPage(
                                          duration: _duration, curve: _curve);
                                      setState(() {
                                        index++;
                                      });
                                    },
                                  )
                                ]
                              ],
                            )),
                      ],
                    );
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextTypography(
                          type: TextType.DESCRIPTION,
                          text: "Rombel di tingkat kelas pada tahun ajaran ini belum dibuat",
                          align: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ButtonWidget(
                          background: green,
                          tint: white,
                          type: ButtonType.LARGE,
                          content: "Buat Rombel",
                          onPressed: () {
                            setState(() {
                              BlocProvider.of<RombelSiswaMakeBloc>(context).add(
                                  MakeRombelSiswa(
                                      id_tahun_ajaran: _teacher.id_tahun_ajaran!,
                                      id_sekolah: _teacher.id_sekolah!,
                                      tingkat: tingkatKelasOpt[tingkatChoice]!
                                  ));
                              BlocProvider.of<RombelSiswaCheckBloc>(context).add(ResetEvent());
                              widget.extendedContents = true;
                              index = 0;
                            });
                          },
                        )
                      ],
                    ),
                  );
                }
                return const SizedBox(width: 0);
              },
            ),
            if (widget.extendedContents)
              BlocConsumer<RombelSiswaMakeBloc, RonggaState>(
                listener: (_, state) {
                  if (state is SuccessState) {
                    listGuruOpt.clear();
                    listTeacher.clear();
                    listPageRombel.clear();
                    setState(() {
                      listStudentTemp.clear();
                    });

                    listTeacher = state.datastore["list_teacher"];
                    for (var teacher in listTeacher) {
                      listGuruOpt.add(teacher.name!);
                    }
                    listPageRombel = state.datastore["rombel_siswa"];

                    for (var i = 0; i < listPageRombel.length; i++) {
                      listGuruChoose.add(listGuruOpt[0]);
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
                    return Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                          child: TextTypography(
                            type: TextType.DESCRIPTION,
                            text: state.error,
                          )
                      ),
                    );
                  } else if (state is SuccessState) {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 600,
                          child: PageView(
                              controller: _controller,
                              physics: const NeverScrollableScrollPhysics(),
                              onPageChanged: (value) {},
                              children: [
                                for (var i = 0; i < listPageRombel.length; i++)
                                  RombelPage(
                                      rombel_name: listPageRombel[i]['rombel'],
                                      description: listPageRombel[i]['description'],
                                      teacherOpt: listGuruOpt,
                                      teacherChoose: listGuruChoose[i],
                                      onSelectedWaliKelas: (value) {
                                        listGuruChoose[i] = value!;
                                      },
                                      tableHeader: ["No", "Nama Siswa", "Gaya Belajar - Level Akademik"],
                                      tableContent: listPageRombel[i]['list_siswa']
                                  ),
                              ]
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (indexAdd > 0)
                                  ButtonWidget(
                                    background: green,
                                    tint: green,
                                    type: ButtonType.OUTLINED,
                                    content: "Sebelumnya",
                                    onPressed: () {
                                      setState(() {
                                        indexAdd--;
                                      });
                                      _controller.previousPage(
                                          duration: _duration, curve: _curve);
                                    },
                                  ),
                                const SizedBox(width: 10),
                                ButtonWidget(
                                  background: green,
                                  tint: white,
                                  type: ButtonType.MEDIUM,
                                  content: (indexAdd < listPageRombel.length-1)
                                      ? "Selanjutnya"
                                      : "Simpan Data Rombel",
                                  onPressed: () {
                                    if (indexAdd < listPageRombel.length-1) {
                                      _controller.nextPage(
                                          duration: _duration, curve: _curve);
                                      setState(() {
                                        indexAdd++;
                                      });
                                    } else {
                                      submitWarningDialog();
                                    }
                                  },
                                )
                              ],
                            )),
                      ],
                    );
                  }
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text("Tidak Ada Data")),
                  );
                },
              ),
            BlocConsumer<RombelSiswaAddBloc, RonggaState>(
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
            /*if (widget.extendedContents)
              ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 600,
                    child: PageView(
                        controller: _controller,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (value) {},
                        children: [
                          RombelPage(
                              rombel_name: "7A",
                              description: "Siswa di rombel ini cenderung kuat dalam hal berhitung dan membaca, "
                                  "serta kuat dalam materi yang berkaitan dengan matematika, "
                                  "namun kurang baik dalam materi tentang Bahasa Inggris",
                              onSelectedWaliKelas: (value) {},
                              tableHeader: ["No", "Nama Siswa", "Gaya Belajar"],
                              tableContent: student_style_list
                          ),
                          RombelPage(
                              rombel_name: "7B",
                              description: "Siswa di rombel ini cenderung kuat dalam hal berhitung dan membaca, "
                                  "serta kuat dalam materi yang berkaitan dengan matematika, "
                                  "namun kurang baik dalam materi tentang Bahasa Inggris",
                              onSelectedWaliKelas: (value) {},
                              tableHeader: ["No", "Nama Siswa", "Gaya Belajar"],
                              tableContent: student_style_list_2
                          )
                        ]
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (index > 0)
                            ButtonWidget(
                              background: green,
                              tint: green,
                              type: ButtonType.OUTLINED,
                              content: "Sebelumnya",
                              onPressed: () {
                                setState(() {
                                  index--;
                                });
                                _controller.previousPage(
                                    duration: _duration, curve: _curve);
                              },
                            ),
                          const SizedBox(width: 10),
                          ButtonWidget(
                            background: green,
                            tint: white,
                            type: ButtonType.MEDIUM,
                            content: (index != 1)
                                ? "Selanjutnya"
                                : "Simpan Data Rombel",
                            onPressed: () {
                              (index != 1)
                                  ? _controller.nextPage(
                                  duration: _duration, curve: _curve)
                                  : submitWarningDialog();
                              setState(() {
                                index++;
                              });
                            },
                          )
                        ],
                      )),
                ],
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextTypography(
                      type: TextType.DESCRIPTION,
                      text: "Rombel di tahun ajaran saat ini belum dibuat",
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ButtonWidget(
                      background: green,
                      tint: white,
                      type: ButtonType.LARGE,
                      content: "Buat Rombel",
                      onPressed: () {
                        setState(() {
                          widget.extendedContents = true;
                        });
                      },
                    )
                  ],
                ),
              )*/
          ],
        )
    );
  }
}