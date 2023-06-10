import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_event.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_home_bloc.dart';
import 'package:non_cognitive/data/model/student_style.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/data/model/users.dart';
import 'package:non_cognitive/ui/components/chart/pie.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/components/table/rombel_style.dart';
import 'package:non_cognitive/ui/components/table/table_column.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/utils/table_assets.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherHome extends StatefulWidget {
  final UserType type;
  const TeacherHome({super.key, required this.type});

  @override
  _TeacherHome createState() => _TeacherHome();
}

class _TeacherHome extends State<TeacherHome> {
  final rombelController = TextEditingController();
  String _tingkatChoice = "VII (Tujuh)";

  final List<String> tingkatOptList = ["VII (Tujuh)", "VIII (Delapan)", "IX (Sembilan)"];

  final Map<String, int> _tingkatOpt = {
    "VII (Tujuh)": 7,
    "VIII (Delapan)": 8,
    "IX (Sembilan)": 9
  };

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Users _user = Users();
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

  List<StudentStyle> listStudent = <StudentStyle>[];
  String description = "";
  int visual_count = 0;
  int auditorial_count = 0;
  int kinestetik_count = 0;

  void initBloc() {
    BlocProvider.of<TeacherHomeBloc>(context).add(ResetEvent());

    BlocProvider.of<TeacherHomeBloc>(context)
        .add(
        StudentRombelSearch(
          wali_kelas: widget.type == UserType.ADMIN ? 0 : _teacher.wali_kelas!,
          id_sekolah: widget.type == UserType.ADMIN ? _user.id_sekolah! : _teacher.id_sekolah!,
          id_guru: widget.type == UserType.ADMIN ? 0 : _teacher.id_guru!,
          tingkat: widget.type == UserType.ADMIN ? 0 : _tingkatOpt[_tingkatChoice],
          rombel: "",
          id_tahun_ajaran: widget.type == UserType.ADMIN ? _user.id_tahun_ajaran! : _teacher.id_tahun_ajaran!,
        ));
  }

  void initProfile() async {
    final SharedPreferences prefs = await _prefs;
    final String user = prefs.getString("user") ?? "";

    setState(() {
      if (widget.type == UserType.ADMIN) {
        _user = Users.fromJson(jsonDecode(user));
      } else {
        _teacher = Teacher.fromJson(jsonDecode(user));
      }
      initBloc();
    });
  }

  @override
  void initState() {
    super.initState();
    initProfile();
  }

  @override
  Widget build(BuildContext context) {
    final _showMobile = MediaQuery.of(context).size.width < screenMd;

    return MainLayout(
        type: widget.type,
        menu_name: "Beranda",
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 25, bottom: 15, left: 15),
                  child: TextTypography(
                      text: "Statistik",
                      type: TextType.HEADER
                  ),
                )
              ],
            ),
            if (widget.type != UserType.WALI_KELAS && widget.type != UserType.GURU_BK_WALI_KELAS)
              CardContainer(
                child: Column(
                  children: [
                    TextTypography(
                      type: TextType.TITLE,
                      text: "Diagram Persentase Setiap Kelompok Belajar",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextTypography(
                        type: TextType.DESCRIPTION,
                        text: "Berikut adalah persentase dari setiap kelompok gaya belajar dalam bentuk diagram. Jika ingin melihat berdasarkan tingkat kelas dan rombelnya, pilih dan masukkan rombel yang ingin dilihat.",
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 130,
                                child: TextTypography(
                                  type: TextType.DESCRIPTION,
                                  text: "Tingkat Kelas",
                                )
                            ),
                            Expanded(
                                child: DropdownFilter(
                                    onChanged: (String? value) {
                                      setState(() {
                                        if (value != null) {
                                          _tingkatChoice = value;
                                          rombelController.text = "";
                                        }
                                      });
                                    },
                                    content: _tingkatChoice,
                                    items: tingkatOptList
                                )
                            )
                          ],
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 130,
                                child: TextTypography(
                                  type: TextType.DESCRIPTION,
                                  text: "Nama Rombel",
                                )
                            ),
                            Expanded(
                                child: TextInputCustom(
                                    controller: rombelController,
                                    hint: "Misal: 8A",
                                    type: TextInputCustomType.NORMAL
                                )
                            )
                          ],
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonWidget(
                              background: orange,
                              tint: white,
                              type: ButtonType.MEDIUM,
                              content: "Cek",
                              onPressed: () {
                                BlocProvider.of<TeacherHomeBloc>(context).add(ResetEvent());

                                BlocProvider.of<TeacherHomeBloc>(context)
                                    .add(
                                    StudentRombelSearch(
                                      wali_kelas: widget.type == UserType.ADMIN ? 0 : _teacher.wali_kelas!,
                                      id_sekolah: widget.type == UserType.ADMIN ? _user.id_sekolah! : _teacher.id_sekolah!,
                                      id_guru: widget.type == UserType.ADMIN ? 0 : _teacher.id_guru!,
                                      tingkat: _tingkatOpt[_tingkatChoice],
                                      rombel: rombelController.text,
                                      id_tahun_ajaran: widget.type == UserType.ADMIN ? _user.id_tahun_ajaran! : _teacher.id_tahun_ajaran!,
                                    ));
                              },
                            )
                          ],
                        )
                    ),
                  ],
                ),
              ),
            BlocConsumer<TeacherHomeBloc, RonggaState>(
              listener: (_, state) {
                if (state is SuccessState) {
                  listStudent.clear();

                  listStudent = state.datastore["list_siswa"];
                  description = state.datastore["description"];
                  visual_count = state.datastore["visual_count"];
                  auditorial_count = state.datastore["auditorial_count"];
                  kinestetik_count = state.datastore["kinestetik_count"];
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
                  if (visual_count == 0 && auditorial_count == 0 && kinestetik_count == 0) {
                    return Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset("assets/images/no-data.json",
                                  repeat: true, animate: true, reverse: false),
                              const SizedBox(height: 10),
                              TextTypography(
                                type: TextType.HEADER,
                                text: "Rombel yang dicari tidak ditemukan.",
                                align: TextAlign.center,
                              )
                            ],
                          )
                      ),
                    );
                  }

                  return ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      CardContainer(
                          child: Column(
                            children: [
                              TextTypography(
                                type: TextType.TITLE,
                                text: widget.type != UserType.WALI_KELAS || widget.type != UserType.GURU_BK_WALI_KELAS ? "Rekap Diagram Persentase" : "Rekap Diagram Persentase Kelas Anda",
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Pie(visual_score: visual_count, auditorial_score: auditorial_count, kinestetik_score: kinestetik_count)
                              )
                            ],
                          )
                      ),
                      if (widget.type == UserType.WALI_KELAS || widget.type == UserType.GURU_BK_WALI_KELAS) ...[
                        CardContainer(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Column(
                                      children: [
                                        TextTypography(
                                          type: TextType.TITLE,
                                          text: "Informasi Detail",
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: TextTypography(
                                              type: TextType.DESCRIPTION,
                                              text: description,
                                              align: TextAlign.justify,
                                            )),
                                      ],
                                    )
                                ),
                                const SizedBox(width: 20),
                                Align(
                                  alignment: Alignment.center,
                                  child: Lottie.asset("assets/images/woman-teacher.json",
                                      repeat: true, animate: true, reverse: false, height: MediaQuery.of(context).size.height * 0.2),
                                )
                              ],
                            )),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 25),
                          child: PaginatedDataTable(
                            dataRowHeight: 70,
                            columns: createTableHeaders(["No", "Nama Siswa", "Gaya Belajar"]),
                            source: RombelStyleTableData(
                                context: context,
                                content: listStudent
                            ),
                            rowsPerPage: 5,
                            columnSpacing: 0,
                            horizontalMargin: 0,
                            showCheckboxColumn: false,
                          ),
                        )
                      ]
                    ],
                  );
                }
                return const SizedBox(width: 0);
              },
            ),
          ],
        )
    );
  }

}