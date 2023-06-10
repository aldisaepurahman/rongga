import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_excel/excel.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_event.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_create_event.dart';
import 'package:non_cognitive/data/bloc/counselor_teacher/rombel_siswa_add_bloc.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/teacher/student_mapel_score_bloc.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_event.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_excel_bloc.dart';
import 'package:non_cognitive/data/model/nilai_akhir_input.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/ui/components/card/insert_student_card.dart';
import 'package:non_cognitive/ui/components/card/nilai_akhir_excel_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_no_button.dart';
import 'package:non_cognitive/ui/components/dialog/loading_dialog.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/components/table/excel_score_table.dart';
import 'package:non_cognitive/ui/components/table/table_column.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/utils/user_type.dart';

class TeacherScoreExcelInput extends StatefulWidget {
  final UserType type;
  final Teacher teacher;

  const TeacherScoreExcelInput(
      {super.key, required this.type, required this.teacher});

  @override
  State<StatefulWidget> createState() => _TeacherScoreExcelInput();
}

class _TeacherScoreExcelInput extends State<TeacherScoreExcelInput> {
  TextEditingController fileController = TextEditingController();
  bool isSubmitted = false;
  bool checkFinished = false;
  int allRows = 0;
  int rowsFound = 0;

  List<Student> list_siswa = <Student>[];
  List<Student> list_final_siswa = <Student>[];
  List<NilaiAkhirInput> list_nilai = <NilaiAkhirInput>[];
  List<NilaiAkhirInput> list_final_score = <NilaiAkhirInput>[];
  TahunAjaran currTahunAjaran = TahunAjaran();
  TahunAjaran prevTahunAjaran = TahunAjaran();

  final Map<int, int> tingkatKelasOpt = {
    7: 1,
    8: 2,
    9: 3,
    1: 4,
    2: 5,
    3: 6,
    4: 7,
    5: 8,
    6: 9
  };

  final Map<String, int> mapelOpt = {
    "Pendidikan Agama dan Budi Pekerti": 10,
    "Pendidikan Pancasila dan Kewarganegaraan": 11,
    "Bahasa Indonesia": 12,
    "Matematika": 13,
    "Bahasa Inggris": 14,
    "Ilmu Pengetahuan Alam": 15,
    "Ilmu Pengetahuan Sosial": 16,
    "Seni Budaya dan Prakarya": 17,
    "Pendidikan Jasmani, Olahraga dan Kesehatan": 18,
    "Bahasa Daerah": 20,
    "Bimbingan dan Konseling": 21
  };

  final Map<String, int> mapelSDOpt = {
    "Pendidikan Agama dan Budi Pekerti": 1,
    "Pendidikan Pancasila dan Kewarganegaraan": 2,
    "Bahasa Indonesia": 3,
    "Matematika": 4,
    "Bahasa Inggris": 5,
    "Ilmu Pengetahuan Alam": 6,
    "Ilmu Pengetahuan Sosial": 7,
    "Seni Budaya dan Prakarya": 8,
    "Pendidikan Jasmani, Olahraga dan Kesehatan": 9,
    "Bahasa Daerah": 19
  };

  void showSubmitDialog(int dialogType) {
    String imgPath = (dialogType > 1)
        ? (dialogType == 2)
            ? "assets/images/success.json"
            : "assets/images/incorrect.json"
        : "assets/images/loading_icon.json";
    String content = (dialogType > 1)
        ? (dialogType == 2)
            ? "Hore, $rowsFound dari $allRows data nilai akhir berhasil diimport dari Excel."
            : "Duh, sepertinya ada kesalahan pada sistem, silahkan coba lagi ya."
        : "";

    showDialog(
      context: context,
      builder: (context) {
        if (dialogType == 2) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<TeacherExcelBloc>(context).add(ResetEvent());
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

  void _importExcel() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: false);

    if (pickedFile != null) {
      var bytes = pickedFile.files.single.bytes;
      fileController.text = pickedFile.files.single.name;

      bool stopCheck = false;
      var excel = Excel.decodeBytes(bytes as List<int>);
      for (var table in excel.tables.keys) {
        int colMapel = -1;
        int colName = -1;
        int rowNameAndNilai = -1;
        int colNilaiAkhir = -1;

        String mapel = "";
        int row = 0;

        while (row < excel.tables[table]!.maxRows && !stopCheck) {
          int col = 0;
          while (col < excel.tables[table]!.maxCols && !stopCheck) {
            var data = excel.tables[table]!.cell(
                CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row));
            if (data.value != null) {
              if (data.value.toString().contains("Mata Pelajaran") && data.value.toString().contains("Guru") == false) {
                colMapel = col+2;
                mapel = excel.tables[table]!.cell(
                    CellIndex.indexByColumnRow(columnIndex: col+2, rowIndex: row)).value.toString().split(": ").last;
                col++;
              } else if (data.value.toString().toUpperCase().contains("NAMA") && data.value.toString().length == 4) {
                colName = col;
                rowNameAndNilai = row;
                col++;
              } else if (data.value.toString().toUpperCase().contains("NILAI AKHIR") && data.value.toString().length == 11) {
                colNilaiAkhir = col;
                col++;
              } else if (colName == col && rowNameAndNilai < row) {
                var student_name = data.value.toString();
                var nilai = int.parse(excel.tables[table]!.cell(
                    CellIndex.indexByColumnRow(columnIndex: colNilaiAkhir, rowIndex: row)).value.toString());

                allRows++;

                int idxStudent = list_siswa.indexWhere((student) => student.name!.contains(student_name));

                if (idxStudent >= 0) {
                  var student = list_siswa[idxStudent];

                  if (student.rombel!.isNotEmpty) {
                    int idxNilaiAkhir = list_nilai.indexWhere(
                            (score) => student.id_siswa == score.id_siswa &&
                                score.id_mapel == mapelOpt[mapel] &&
                                score.id_tingkat_kelas == tingkatKelasOpt[student.tingkat] &&
                                score.id_tahun_ajaran == student.id_tahun_ajaran
                    );

                    if (idxNilaiAkhir >= 0) {
                      list_nilai[idxNilaiAkhir].nilai = nilai;
                      list_final_score.add(list_nilai[idxNilaiAkhir]);
                    } else {
                      list_final_score.add(
                          NilaiAkhirInput(
                            id_tahun_ajaran: currTahunAjaran.id_thn_ajaran,
                            id_sekolah: student.id_sekolah,
                            id_siswa: student.id_siswa,
                            id_mapel: mapelOpt[mapel],
                            id_tingkat_kelas: tingkatKelasOpt[student.tingkat],
                            nama_mapel: mapel,
                            nilai: nilai
                          )
                      );
                    }
                  } else {
                    int idxNilaiAkhir = list_nilai.indexWhere(
                            (score) => student.id_siswa == score.id_siswa &&
                            score.id_mapel == mapelSDOpt[mapel] &&
                            score.id_tingkat_kelas == tingkatKelasOpt[student.tingkat!-1] &&
                            score.id_tahun_ajaran == prevTahunAjaran.id_thn_ajaran
                    );

                    if (idxNilaiAkhir >= 0) {
                      list_nilai[idxNilaiAkhir].nilai = nilai;
                      list_final_score.add(list_nilai[idxNilaiAkhir]);
                    } else {
                      list_final_score.add(
                          NilaiAkhirInput(
                              id_tahun_ajaran: prevTahunAjaran.id_thn_ajaran,
                              id_sekolah: student.id_sekolah,
                              id_siswa: student.id_siswa,
                              id_mapel: mapelSDOpt[mapel],
                              id_tingkat_kelas: tingkatKelasOpt[student.tingkat!-1],
                              nama_mapel: mapel,
                              nilai: nilai
                          )
                      );
                    }
                  }

                  list_final_siswa.add(student);
                  rowsFound++;
                }

                row++;
                col = 0;
              } else {
                col++;
              }
            } else {
              if (col == colName && rowNameAndNilai+2 < row && colName >= 0 && rowNameAndNilai >= 0) {
                stopCheck = true;
              }
              col++;
            }
          }
          row++;
        }

        if (stopCheck) {
          setState(() {
            checkFinished = true;
          });
          break;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    BlocProvider.of<TeacherExcelBloc>(context).add(TeacherExcelCheck(
        id_sekolah: widget.teacher.id_sekolah!,
        id_tahun_ajaran: widget.teacher.id_tahun_ajaran!,
        tahun_ajaran: widget.teacher.tahun_ajaran!));
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: widget.type,
        menu_name: "Profil",
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
                const SizedBox(width: 25),
                Container(
                  margin: const EdgeInsets.only(top: 25, bottom: 15),
                  child: TextTypography(
                      text: "Import Nilai Akhir Siswa", type: TextType.HEADER),
                )
              ],
            ),
            CardContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Lottie.asset("assets/images/information-icon.json",
                            repeat: true, animate: true, reverse: false, height: MediaQuery.of(context).size.height * 0.1)),
                    Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: TextTypography(
                            type: TextType.TITLE,
                            text: "Di halaman ini, bapak/ibu bisa melakukan import nilai menggunakan file Excel. Nilai yang diimport hanya dapat dari "
                                "satu mata pelajaran saja, maka pastikan bapak/ibu telah mengelompokkan data nilai akhir per filenya berdasarkan mata pelajaran ya.",
                          ),
                        )
                    )
                  ],
                )
            ),
            NilaiAkhirExcelCard(
              rombelController: fileController,
              onBrowse: () {
                _importExcel();
              },
              onPressedSubmit: () {
                BlocProvider.of<StudentMapelScoreBloc>(context).add(StudentScoreInput(scores: list_final_score));
              },
            ),
            BlocConsumer<TeacherExcelBloc, RonggaState>(
                listener: (_, state) {
                  if (state is SuccessState) {
                    list_siswa.clear();
                    list_nilai.clear();

                    currTahunAjaran = state.datastore["current_tahun_ajaran"];
                    prevTahunAjaran = state.datastore["previous_tahun_ajaran"];
                    list_siswa = state.datastore["list_student"];
                    list_nilai = state.datastore["list_nilai"];
                  }
                },
              builder: (_, state) {
                return const SizedBox(width: 0);
              },
            ),
            if (checkFinished)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                child: PaginatedDataTable(
                  dataRowHeight: 70,
                  columns: createTableHeaders(["No", "Nama Siswa", "Nilai Akhir"]),
                  source: ExcelScoreTableData(
                      context: context,
                      students: list_final_siswa,
                    final_scores: list_final_score
                  ),
                  rowsPerPage: 5,
                  columnSpacing: 0,
                  horizontalMargin: 0,
                  showCheckboxColumn: false,
                ),
              ),
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
        ));
  }
}
