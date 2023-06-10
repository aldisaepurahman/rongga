import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_delact_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';
import 'package:non_cognitive/data/model/users.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_no_button.dart';
import 'package:non_cognitive/ui/components/dialog/loading_dialog.dart';
import 'package:non_cognitive/ui/components/table/table_column.dart';
import 'package:non_cognitive/ui/components/table/tahun_ajaran.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/admin_sekolah/admin_form_tahun_ajaran.dart';
import 'package:non_cognitive/utils/admin_assets.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminTahunAjaran extends StatefulWidget {
  const AdminTahunAjaran({super.key});

  @override
  State<StatefulWidget> createState() => _AdminTahunAjaran();
}

class _AdminTahunAjaran extends State<AdminTahunAjaran> {
  Users _user = Users();
  TahunAjaran _thnAjaran = TahunAjaran();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<TahunAjaran> tahun_ajaran = <TahunAjaran>[];
  bool isSubmitted = false;
  int method = 0;

  FutureOr onBackPage(dynamic value) {
    initBloc();
  }

  void initBloc() {
    BlocProvider.of<TahunAjaranDelActBloc>(context).add(ResetEvent());
    BlocProvider.of<TahunAjaranBloc>(context).add(ResetEvent());
    print("user: ${_user.id_sekolah}");
    BlocProvider.of<TahunAjaranBloc>(context)
        .add(TahunAjaranShow(id_sekolah: _user.id_sekolah!, token: _user.token!));
  }

  void recreateProfile() async {
    _user.id_tahun_ajaran = _thnAjaran.id_thn_ajaran;
    _user.tahun_ajaran = _thnAjaran.thnAjaran;

    final SharedPreferences prefs = await _prefs;

    prefs.remove("user");
    prefs.setString("user", jsonEncode(_user.toLocalJson()));
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
            ? (method == 2)
                ? "Tahun ajaran sudah dihapus."
                : "Tahun ajaran sudah berubah."
            : "Duh, terjadi masalah dengan server aplikasi, coba lagi."
        : "";

    showDialog(
      context: context,
      builder: (context) {
        if (dialogType == 2) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<TahunAjaranDelActBloc>(context).add(ResetEvent());
            if (method == 1) {
              recreateProfile();
            }
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 3) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<TahunAjaranDelActBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 4) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<TahunAjaranDelActBloc>(context).add(ResetEvent());
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

  void submitWarningDialog(TahunAjaran thn_ajaran, int type) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content: (type == 2)
              ? "Apakah anda yakin ingin menghapus data ini?"
              : "Apakah anda yakin dengan perubahan ini?",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            isSubmitted = true;
            method = type;
            _thnAjaran = thn_ajaran;
            if (type == 1) {
              BlocProvider.of<TahunAjaranDelActBloc>(context).add(
                  TahunAjaranActive(
                      id_tahun_ajaran: thn_ajaran.id_thn_ajaran!,
                      id_sekolah: _user.id_sekolah!,
                    token: _user.token!
                  ));
            } else {
              BlocProvider.of<TahunAjaranDelActBloc>(context).add(
                  TahunAjaranDelete(id_tahun_ajaran: thn_ajaran.id_thn_ajaran!, token: _user.token!));
            }
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
        menu_name: "Tahun Ajaran",
        floatingButton: ButtonWidget(
          background: green,
          tint: white,
          type: ButtonType.FLOAT,
          icon: Icons.add,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminFormTahunAjaran(
                        id_sekolah: _user.id_sekolah!, token: _user.token!))).then(onBackPage);
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
                      text: "Tahun Ajaran", type: TextType.HEADER),
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
                      text:
                          "Pada menu ini, anda dapat menambahkan tahun ajaran baru dan mengatur tahun "
                          "ajaran mana yang aktif dalam sistem aplikasi ini.",
                    )),
              ],
            )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25),
              child: BlocConsumer<TahunAjaranBloc, RonggaState>(
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
                      columns:
                          createTableHeaders(["No", "Tahun Ajaran", "Aksi"]),
                      source: TahunAjaranTableData(
                          context: context,
                          content: tahun_ajaran,
                          onTahunAjaranActive: (TahunAjaran thn_ajaran) {
                            submitWarningDialog(thn_ajaran, 1);
                          },
                          onEdited: (TahunAjaran thn_ajaran) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminFormTahunAjaran(
                                        id_sekolah: _user.id_sekolah!,
                                        thnAjaran: thn_ajaran,
                                      token: _user.token!,
                                    ))).then(onBackPage);
                          },
                          onDeleted: (TahunAjaran thn_ajaran) {
                            submitWarningDialog(thn_ajaran, 2);
                          }),
                      rowsPerPage: 5,
                      columnSpacing: 0,
                      horizontalMargin: 0,
                      showCheckboxColumn: false,
                    );
                  }
                  return PaginatedDataTable(
                    dataRowHeight: 50,
                    columns: createTableHeaders(["No", "Tahun Ajaran", "Aksi"]),
                    source: TahunAjaranTableData(
                        context: context,
                        content: [],
                        onTahunAjaranActive: (TahunAjaran thn_ajaran) {},
                        onEdited: (TahunAjaran thn_ajaran) {},
                        onDeleted: (TahunAjaran thn_ajaran) {}),
                    rowsPerPage: 5,
                    columnSpacing: 0,
                    horizontalMargin: 0,
                    showCheckboxColumn: false,
                  );
                },
                listener: (context, state) {
                  if (state is SuccessState) {
                    tahun_ajaran.clear();
                    tahun_ajaran = state.datastore;
                  }
                },
              ),
            ),
            BlocConsumer<TahunAjaranDelActBloc, RonggaState>(
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
