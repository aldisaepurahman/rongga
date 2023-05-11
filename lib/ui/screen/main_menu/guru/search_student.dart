import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_bloc.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_event.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/ui/components/badges/badges.dart';
import 'package:non_cognitive/ui/components/card/item_search_card.dart';
import 'package:non_cognitive/ui/components/card/student_search_card.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/student_profile.dart';
import 'package:non_cognitive/utils/student_list_dummy.dart';
import 'package:non_cognitive/utils/user_type.dart';

class SearchStudent extends StatefulWidget {
  final UserType type;
  const SearchStudent({super.key, required this.type});

  @override
  _SearchStudent createState() => _SearchStudent();
}

class _SearchStudent extends State<SearchStudent> {
  final namaController = TextEditingController();
  final rombelController = TextEditingController();

  List<Student> list_student = <Student>[];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      BlocProvider.of<TeacherBloc>(context)
          .add(StudentOnSearch(id_sekolah: 1, nama: "", rombel: ""));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: widget.type,
        menu_name: "Cari Siswa",
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
              child: TextTypography(
                  text: "Cari Siswa",
                  type: TextType.HEADER
              ),
            ),
            StudentSearchCard(
              namaController: namaController,
              rombelController: rombelController,
              onPressedSubmit: () {
                BlocProvider.of<TeacherBloc>(context).add(
                    StudentOnSearch(
                        id_sekolah: 1,
                        nama: namaController.text,
                        rombel: rombelController.text));
              },
            ),
            BlocConsumer<TeacherBloc, RonggaState>(
              listener: (_, state) {
                if (state is SuccessState) {
                  list_student.clear();
                  list_student = state.datastore;
                }
              },
              builder: (_, state) {
                if (state is LoadingState) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is FailureState) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                        child: Text(
                            "Data gagal ditampilkan, terjadi error pada sistem!")),
                  );
                } else if (state is SuccessState) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: list_student.length,
                    itemBuilder: (context, index) {
                      return ItemSearchCard(
                        id_number: list_student[index].idNumber ?? "",
                        name: list_student[index].name ?? "",
                        image: list_student[index].photo ?? "",
                        type: list_student[index].type ?? UserType.GURU,
                        badgesType: list_student[index].studyStyle == "Visual"
                            ? BadgesType.VISUAL
                            : list_student[index].studyStyle == "Auditori"
                            ? BadgesType.AUDITORI
                            : BadgesType.KINESTETIK,
                        onCheckDetailed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                StudentProfile(userType: widget.type, student: list_student[index]),
                          ));
                        },
                      );
                    },
                  );
                }
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text("Tidak Ada Data")),
                );
              },
            )
            /*for (var item in students)
              ItemSearchCard(
                id_number: item.idNumber ?? "",
                name: item.name ?? "",
                image: item.photo ?? "",
                type: item.type ?? UserType.SISWA,
                badgesType: item.studyStyle == "Visual"
                    ? BadgesType.VISUAL
                    : item.studyStyle == "Auditori"
                    ? BadgesType.AUDITORI
                    : BadgesType.KINESTETIK,
                onCheckDetailed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StudentProfile(userType: widget.type),
                      ));
                },
              )*/
          ],
        )
    );
  }
}
