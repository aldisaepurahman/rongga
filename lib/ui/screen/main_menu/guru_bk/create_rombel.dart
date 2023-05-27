import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_create_event.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_siswa_make_bloc.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/ui/components/card/rombel_card.dart';
import 'package:non_cognitive/ui/components/card/tingkat_only_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
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
  List<Map<String, dynamic>> listPageRombel = <Map<String, dynamic>>[];

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
            /*Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const StudentHome(type: UserType.SISWA, expandedContents: true),
                ));*/
            Navigator.of(context).pop();
          },
        );
      },
    );
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
              onPressedSubmit: () {
                BlocProvider.of<RombelSiswaMakeBloc>(context).add(
                    MakeRombelSiswa(
                        id_tahun_ajaran: _teacher.id_tahun_ajaran!,
                      id_sekolah: _teacher.id_sekolah!,
                      tingkat: tingkatKelasOpt[tingkatChoice]!
                    ));
              },
            ),
            BlocConsumer<RombelSiswaMakeBloc, RonggaState>(
              listener: (_, state) {
                if (state is SuccessState) {
                  listGuruOpt.clear();
                  listTeacher.clear();
                  listPageRombel.clear();

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
                                    description: "Siswa di rombel ini cenderung kuat dalam hal berhitung dan membaca, "
                                        "serta kuat dalam materi yang berkaitan dengan matematika, "
                                        "namun kurang baik dalam materi tentang Bahasa Inggris",
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
                  );
                }
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text("Tidak Ada Data")),
                );
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