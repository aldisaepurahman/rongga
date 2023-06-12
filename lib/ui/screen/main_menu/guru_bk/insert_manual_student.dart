import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_event.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_create_event.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_siswa_add_bloc.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';
import 'package:non_cognitive/ui/components/card/insert_student_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_no_button.dart';
import 'package:non_cognitive/ui/components/dialog/loading_dialog.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/utils/user_type.dart';

class InsertManualStudent extends StatefulWidget {
  final UserType type;
  final String token;
  final int id_tahun_ajaran;
  final int tingkat;
  final List<Student> listStudent;
  final List<RombelSekolah> listRombel;

  const InsertManualStudent(
      {super.key,
      required this.type,
      required this.token,
      required this.id_tahun_ajaran,
      required this.tingkat,
      required this.listStudent,
      required this.listRombel});

  @override
  State<StatefulWidget> createState() => _InsertManualStudent();
}

class _InsertManualStudent extends State<InsertManualStudent> {
  String _studentName = "";
  String _rombel = "";
  bool isSubmitted = false;

  List<String> studentNameList = <String>[];
  List<String> rombelList = <String>[];

  void showSubmitDialog(int dialogType) {
    String imgPath = (dialogType > 1)
        ? (dialogType == 2)
            ? "assets/images/success.json"
            : "assets/images/incorrect.json"
        : "assets/images/loading_icon.json";
    String content = (dialogType > 1)
        ? (dialogType == 2)
            ? "Hore, siswa berhasil ditambahkan ke rombel yang ditentukan."
            : "Duh, pastikan semua data terisi ya."
        : "";

    showDialog(
      context: context,
      builder: (context) {
        if (dialogType == 2) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<RombelSiswaAddBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 3) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<RombelSiswaAddBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 4) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<RombelSiswaAddBloc>(context).add(ResetEvent());
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

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.listStudent.length; i++) {
      studentNameList.add(widget.listStudent[i].name!);
    }
    _studentName = studentNameList[0];

    for (var i = 0; i < widget.listRombel.length; i++) {
      rombelList.add(widget.listRombel[i].rombel!);
    }
    _rombel = rombelList[0];
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
                Expanded(
                    child: Container(
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
                    )
                ),
                const SizedBox(width: 25),
                Expanded(
                  flex: 3,
                    child: Container(
                      margin: const EdgeInsets.only(top: 25, bottom: 15),
                      child: TextTypography(
                          text: "Input Siswa Manual di Tingkat ${widget.tingkat}",
                          type: TextType.HEADER),
                    )
                )
              ],
            ),
            InsertStudentCard(
              student_name: _studentName,
              onSelectedChoice: (value) {
                _studentName = value;
              },
              listStudent: studentNameList,
              rombel: _rombel,
              onRombelChoice: (value) {
                _rombel = value;
              },
              listRombel: rombelList,
              onPressedSubmit: () {
                isSubmitted = true;
                int idxSiswa = widget.listStudent
                    .indexWhere((row) => row.name == _studentName);
                int idxRombel = widget.listRombel
                    .indexWhere((row) => row.rombel == _rombel);

                if (idxSiswa >= 0 && idxRombel >= 0) {
                  List<Map<String, dynamic>> list_siswa =
                      <Map<String, dynamic>>[];
                  var mapping = {
                    "id_siswa": widget.listStudent[idxSiswa].id_siswa,
                    "id_tahun_ajaran": widget.id_tahun_ajaran,
                    "id_rombel_sekolah": widget.listRombel[idxRombel].id_rombel
                  };

                  list_siswa.add(mapping);

                  BlocProvider.of<RombelSiswaAddBloc>(context)
                      .add(AddManualRombelSiswa(list_siswa: list_siswa, token: widget.token));
                } else {
                  showSubmitDialog(4);
                }
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
          ],
        ));
  }
}
