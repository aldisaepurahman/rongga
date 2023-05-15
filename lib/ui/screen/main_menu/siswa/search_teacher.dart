import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/student/student_bloc.dart';
import 'package:non_cognitive/data/bloc/student/student_event.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/ui/components/card/item_search_card.dart';
import 'package:non_cognitive/ui/components/card/teacher_search_card.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/teacher_profile.dart';
import 'package:non_cognitive/utils/teacher_list_dummy.dart';
import 'package:non_cognitive/utils/user_type.dart';

class SearchTeacher extends StatefulWidget {
  const SearchTeacher({super.key});

  @override
  _SearchTeacher createState() => _SearchTeacher();
}

class _SearchTeacher extends State<SearchTeacher> {
  final namaController = TextEditingController();

  List<Teacher> list_teacher = <Teacher>[];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      BlocProvider.of<StudentBloc>(context)
          .add(TeacherOnSearch(id_sekolah: 1, nama: ""));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: UserType.SISWA,
        menu_name: "Cari Guru",
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
              child: TextTypography(text: "Cari Guru", type: TextType.HEADER),
            ),
            TeacherSearchCard(
              namaController: namaController,
              onPressedSubmit: () {
                BlocProvider.of<StudentBloc>(context)
                    .add(TeacherOnSearch(id_sekolah: 1, nama: namaController.text));
              },
            ),
            BlocConsumer<StudentBloc, RonggaState>(
              listener: (_, state) {
                if (state is SuccessState) {
                  list_teacher.clear();
                  list_teacher = state.datastore;
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
                        child: Text(
                            state.error)),
                  );
                } else if (state is SuccessState) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: list_teacher.length,
                    itemBuilder: (context, index) {
                      return ItemSearchCard(
                        id_number: list_teacher[index].idNumber ?? "",
                        name: list_teacher[index].name ?? "",
                        image: list_teacher[index].photo ?? "",
                        type: list_teacher[index].type ?? UserType.GURU,
                        onCheckDetailed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                TeacherProfile(type: UserType.SISWA, teacher: list_teacher[index]),
                          ));
                        },
                      );
                    },
                  );
                }
                return const Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(child: Text("Tidak Ada Data")),
                );
              },
            )
          ],
        ));
  }
}
