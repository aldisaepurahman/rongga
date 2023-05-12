import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/tahun_ajaran_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
import 'package:non_cognitive/data/model/tahun_ajaran.dart';
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

class AdminFormTahunAjaran extends StatefulWidget {
  final int id_sekolah;
  TahunAjaran? thnAjaran;

  AdminFormTahunAjaran({super.key, this.thnAjaran, required this.id_sekolah});

  @override
  State<StatefulWidget> createState() => _AdminFormTahunAjaran();
}

class _AdminFormTahunAjaran extends State<AdminFormTahunAjaran> {
  final tahunController = TextEditingController();
  String _semesterChoice = "Ganjil";
  bool isSubmitted = false;
  bool isEdited = false;

  final List<String> semesterOptList = ["Ganjil", "Genap"];

  final Map<String, int> _tingkatOpt = {
    "VII (Tujuh)": 7,
    "VIII (Delapan)": 8,
    "IX (Sembilan)": 9
  };

  final Map<int, String> _semesterFilled = {
    0: "Ganjil",
    1: "Genap",
  };

  void showSubmitDialog(int dialogType) {
    String imgPath = (dialogType > 1)
        ? (dialogType == 2)
            ? "assets/images/success.json"
            : "assets/images/incorrect.json"
        : "assets/images/loading_icon.json";
    String content = (dialogType > 1)
        ? (dialogType == 2)
            ? (isEdited) ? "Hore, tahun ajaran sudah diperbarui." : "Hore, tahun ajaran sudah ditambahkan."
            : "Duh, pastikan semua data terisi ya."
        : "";

    showDialog(
      context: context,
      builder: (context) {
        if (dialogType == 2) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<TahunAjaranBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 3) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<TahunAjaranBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 4) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<TahunAjaranBloc>(context).add(ResetEvent());
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

    if (widget.thnAjaran != null) {
      isEdited = true;
      _semesterChoice = widget.thnAjaran?.semester ?? "Ganjil";
      tahunController.text = widget.thnAjaran?.thnAjaran ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: UserType.ADMIN,
        menu_name: "Tahun Ajaran",
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
                      text: "Tahun Ajaran", type: TextType.HEADER),
                )
              ],
            ),
            CardContainer(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 130,
                              child: TextTypography(
                                type: TextType.DESCRIPTION,
                                text: "Semester",
                              )),
                          Expanded(
                              child: DropdownFilter(
                                  onChanged: (String? value) {
                                    setState(() {
                                      if (value != null) {
                                        _semesterChoice = value;
                                      }
                                    });
                                  },
                                  content: _semesterChoice,
                                  items: semesterOptList))
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 130,
                              child: TextTypography(
                                type: TextType.DESCRIPTION,
                                text: "Tahun Ajaran",
                              )),
                          Expanded(
                              child: TextInputCustom(
                                  controller: tahunController,
                                  hint: "Misal: 2022/2023",
                                  type: TextInputCustomType.NORMAL))
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonWidget(
                            background: green,
                            tint: white,
                            type: ButtonType.MEDIUM,
                            content: "Submit",
                            onPressed: () {
                              if (tahunController.text.isNotEmpty) {
                                isSubmitted = true;
                                if (isEdited) {
                                  BlocProvider.of<TahunAjaranBloc>(context)
                                      .add(TahunAjaranUpdate(tahun_ajaran: {
                                    "id_tahun_ajaran": widget.thnAjaran?.id_thn_ajaran!,
                                    "id_sekolah": widget.id_sekolah,
                                    "tahun_ajaran": tahunController.text,
                                    "semester": _semesterChoice
                                  }));
                                } else {
                                  BlocProvider.of<TahunAjaranBloc>(context)
                                      .add(TahunAjaranAdd(tahun_ajaran: {
                                    "id_sekolah": widget.id_sekolah,
                                    "tahun_ajaran": tahunController.text,
                                    "semester": _semesterChoice
                                  }));
                                }
                              } else {
                                showSubmitDialog(4);
                              }
                            },
                          )
                        ],
                      )),
                ],
              ),
            ),
            BlocConsumer<TahunAjaranBloc, RonggaState>(
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
