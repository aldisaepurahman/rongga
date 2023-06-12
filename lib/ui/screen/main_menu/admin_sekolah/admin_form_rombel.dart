import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/rombel_sekolah_bloc.dart';
import 'package:non_cognitive/data/bloc/admin/rombel_sekolah_event.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/rombel_sekolah.dart';
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

class AdminFormRombel extends StatefulWidget {
  RombelSekolah? rombel;
  final int id_sekolah;
  final String token;

  AdminFormRombel({super.key, this.rombel, required this.id_sekolah, required this.token});

  @override
  State<StatefulWidget> createState() => _AdminFormRombel();
}

class _AdminFormRombel extends State<AdminFormRombel> {
  final rombelController = TextEditingController();
  String _tingkatChoice = "VII (Tujuh)";
  bool isSubmitted = false;
  bool isEdited = false;

  final List<String> tingkatOptList = [
    "VII (Tujuh)",
    "VIII (Delapan)",
    "IX (Sembilan)"
  ];

  final Map<String, int> _tingkatOpt = {
    "VII (Tujuh)": 1,
    "VIII (Delapan)": 2,
    "IX (Sembilan)": 3
  };

  final Map<int, String> _tingkatFilled = {
    1: "VII (Tujuh)",
    2: "VIII (Delapan)",
    3: "IX (Sembilan)"
  };

  void showSubmitDialog(int dialogType) {
    String imgPath = (dialogType > 1)
        ? (dialogType == 2)
            ? "assets/images/success.json"
            : "assets/images/incorrect.json"
        : "assets/images/loading_icon.json";
    String content = (dialogType > 1)
        ? (dialogType == 2)
            ? (isEdited)
                ? "Hore, rombel sekolah sudah diperbarui."
                : "Hore, rombel sekolah sudah ditambahkan."
            : "Duh, pastikan semua data terisi ya."
        : "";

    showDialog(
      context: context,
      builder: (context) {
        if (dialogType == 2) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<RombelSekolahBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 3) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<RombelSekolahBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 4) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<RombelSekolahBloc>(context).add(ResetEvent());
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

    if (widget.rombel != null) {
      isEdited = true;
      _tingkatChoice = _tingkatFilled[widget.rombel?.id_tingkat_kelas]!;
      rombelController.text = widget.rombel?.rombel ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: UserType.ADMIN,
        menu_name: "Rombel Sekolah",
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
                      text: "Rombel Sekolah", type: TextType.HEADER),
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
                          Expanded(
                              child: TextTypography(
                                type: TextType.DESCRIPTION,
                                text: "Tingkat Kelas",
                              )),
                          Expanded(
                              child: DropdownFilter(
                                  onChanged: (String? value) {
                                    setState(() {
                                      if (value != null) {
                                        _tingkatChoice = value;
                                      }
                                    });
                                  },
                                  content: _tingkatChoice,
                                  items: tingkatOptList))
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: TextTypography(
                                type: TextType.DESCRIPTION,
                                text: "Nama Rombel",
                              )),
                          Expanded(
                              child: TextInputCustom(
                                  controller: rombelController,
                                  hint: "Misal: 8A",
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
                              if (rombelController.text.isNotEmpty) {
                                isSubmitted = true;
                                if (isEdited) {
                                  BlocProvider.of<RombelSekolahBloc>(context)
                                      .add(RombelSekolahUpdate(rombel_sekolah: {
                                    "id_rombel": widget.rombel?.id_rombel!,
                                    "id_sekolah": widget.id_sekolah,
                                    "id_tingkat_kelas": _tingkatOpt[_tingkatChoice],
                                    "rombel": rombelController.text,
                                  }, token: widget.token));
                                } else {
                                  BlocProvider.of<RombelSekolahBloc>(context)
                                      .add(RombelSekolahAdd(rombel_sekolah: {
                                    "id_sekolah": widget.id_sekolah,
                                    "id_tingkat_kelas": _tingkatOpt[_tingkatChoice],
                                    "rombel": rombelController.text,
                                  }, token: widget.token));
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
            BlocConsumer<RombelSekolahBloc, RonggaState>(
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
