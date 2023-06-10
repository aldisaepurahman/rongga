import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/rombel_sekolah_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/rombel_sekolah_delact_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/rombel_sekolah_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/data/model/users.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_no_button.dart';
import 'package:non_cognitive/ui/components/dialog/loading_dialog.dart';
import 'package:non_cognitive/ui/components/table/rombel_admin.dart';
import 'package:non_cognitive/ui/components/table/table_column.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/admin_sekolah/admin_form_rombel.dart';
import 'package:non_cognitive/utils/admin_assets.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRombelList extends StatefulWidget {
  const AdminRombelList({super.key});

  @override
  State<StatefulWidget> createState() => _AdminRombelList();

}

class _AdminRombelList extends State<AdminRombelList> {
  Users _user = Users();
  RombelSekolah _rombel = RombelSekolah();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<RombelSekolah> rombel_sekolah = <RombelSekolah>[];
  bool isSubmitted = false;

  FutureOr onBackPage(dynamic value) {
    initBloc();
  }

  void initBloc() {
    BlocProvider.of<RombelSekolahDelActBloc>(context).add(ResetEvent());
    BlocProvider.of<RombelSekolahBloc>(context).add(ResetEvent());

    BlocProvider.of<RombelSekolahBloc>(context)
        .add(RombelSekolahShow(id_sekolah: _user.id_sekolah!, token: _user.token!));
  }

  void initProfile() async {
    final SharedPreferences prefs = await _prefs;
    final String user = prefs.getString("user") ?? "";

    setState(() {
      _user = Users.fromJson(jsonDecode(user));
      initBloc();
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
        ? "Rombel yang dipilih sudah terhapus."
        : "Duh, terjadi masalah dengan server aplikasi, coba lagi."
        : "";

    showDialog(
      context: context,
      builder: (context) {
        if (dialogType == 2) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<RombelSekolahDelActBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 3) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<RombelSekolahDelActBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 4) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<RombelSekolahDelActBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
          });
        }
        if (dialogType > 1) {
          return DialogNoButton(path_image: imgPath, content: content);
        }
        return LoadingDialog(path_image: imgPath);
      },
    ).then(onBackPage);
  }

  void submitWarningDialog(RombelSekolah rombel) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content: "Apakah anda yakin ingin menghapus data ini?",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            isSubmitted = true;
            _rombel = rombel;
            BlocProvider.of<RombelSekolahDelActBloc>(context).add(
                  RombelSekolahDelete(id_rombel: rombel.id_rombel!, token: _user.token!));
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initProfile();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: UserType.ADMIN,
        menu_name: "Rombel Sekolah",
        floatingButton: ButtonWidget(
          background: green,
          tint: white,
          type: ButtonType.FLOAT,
          icon: Icons.add,
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminFormRombel(id_sekolah: _user.id_sekolah!, token: _user.token!))
            ).then(onBackPage);
          },
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
                  child: TextTypography(
                      text: "Rombel Sekolah",
                      type: TextType.HEADER
                  ),
                )
              ],
            ),
            CardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTypography(
                      type: TextType.TITLE,
                      text: "Informasi Detail",
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextTypography(
                          type: TextType.DESCRIPTION,
                          text: "Pada menu ini, anda dapat menambahkan rombel baru untuk setiap tingkat kelas di sekolah, "
                              "bahkan bisa untuk menghapus rombel tersebut",
                        )),
                  ],
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25),
              child: BlocConsumer<RombelSekolahBloc, RonggaState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is FailureState) {
                    return Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text(state.error)),
                    );
                  }
                  if (state is SuccessState) {
                    return PaginatedDataTable(
                      dataRowHeight: 50,
                      columns: createTableHeaders(["No", "Tahun Ajaran", "Aksi"]),
                      source: RombelAdminTableData(
                          context: context,
                          content: rombel_sekolah,
                          onEdited: (RombelSekolah rombel) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminFormRombel(
                                        id_sekolah: _user.id_sekolah!,
                                        token: _user.token!,
                                        rombel: rombel))).then(onBackPage);
                          },
                          onDeleted: (RombelSekolah rombel) {
                            submitWarningDialog(rombel);
                          }),
                      rowsPerPage: 5,
                      columnSpacing: 0,
                      horizontalMargin: 0,
                      showCheckboxColumn: false,
                    );
                  }
                  return PaginatedDataTable(
                    dataRowHeight: 50,
                    columns: createTableHeaders(["No", "Nama Rombel", "Aksi"]),
                    source: RombelAdminTableData(
                        context: context,
                        content: [],
                        onEdited: (RombelSekolah rombel) {},
                        onDeleted: (RombelSekolah rombel) {}
                    ),
                    rowsPerPage: 5,
                    columnSpacing: 0,
                    horizontalMargin: 0,
                    showCheckboxColumn: false,
                  );
                },
                listener: (context, state) {
                  if (state is SuccessState) {
                    rombel_sekolah.clear();
                    rombel_sekolah = state.datastore;
                  }
                },
              ),
            ),
            BlocConsumer<RombelSekolahDelActBloc, RonggaState>(
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