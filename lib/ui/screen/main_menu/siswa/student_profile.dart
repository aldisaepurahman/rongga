import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/data/model/bottom_sheet_item.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/ui/components/card/biodata_card.dart';
import 'package:non_cognitive/ui/components/card/status_profile_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/circle_avatar.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/bottom_sheet.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/teacher_score_input.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/home_student.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/student_profile_update.dart';
import 'package:non_cognitive/ui/screen/questionnaire/questionnaire.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentProfile extends StatefulWidget {
  final UserType userType;
  final Student? student;
  const StudentProfile({super.key, required this.userType, this.student});

  @override
  State<StudentProfile> createState() => _StudentProfile();
}

class _StudentProfile extends State<StudentProfile> {
  late List<BottomSheetCustomItem> bottom_sheet_profile_list = <BottomSheetCustomItem>[];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool cardVisible = true;

  Student _student = Student(
      idNumber: "",
      name: "",
      email: "",
      password: "",
      gender: "",
      no_telp: "",
      photo: "",
      address: "",
      type: UserType.SISWA,
      id_sekolah: 0,
      id_tahun_ajaran: 0,
      tahun_ajaran: '',
      token: ''
  );

  void showChoiceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Tunggu Dulu!",
          content: "Apa anda yakin dengan pilihan anda?Setelah yakin, pilihan ini tidak dapat diubah kembali.",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            // Navigator.of(context).pop();
          },
        );
      },
    );
  }

  FutureOr onBackPage(dynamic value) {
    initProfile();
  }

  void initProfile() async {
    final SharedPreferences prefs = await _prefs;
    final String user = prefs.getString("user") ?? "";

    setState(() {
      if (widget.student != null) {
        _student = widget.student!;
      } else {
        _student = Student.fromJson(jsonDecode(user));
      }
      cardVisible = prefs.getBool("profileCard") ?? true;
    });
  }

  @override
  void initState() {
    super.initState();
    initProfile();

    bottom_sheet_profile_list = [
      BottomSheetCustomItem(
        icon: Icons.upgrade,
        title: "Naikkan Tingkat Siswa ke Tingkat Berikutnya",
        onTap: () {
          Navigator.of(context).pop();
          showChoiceDialog();
        },
      ),
      BottomSheetCustomItem(
        icon: Icons.front_hand,
        title: "Putuskan Siswa untuk Tinggal Kelas",
        onTap: () {
          Navigator.of(context).pop();
          showChoiceDialog();
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final _showMobile = MediaQuery.of(context).size.width < screenMd;

    return MainLayout(
        type: widget.userType,
        menu_name: "Profil",
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.userType != UserType.SISWA)
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
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
                  child: TextTypography(
                      text: "Profil Siswa",
                      type: TextType.HEADER
                  ),
                )
              ],
            ),
            _renderPage(widget.userType, _showMobile, _student)
          ],
        )
    );
  }

  ListView _renderPage(UserType type, bool isMobile, Student student) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 15),
      children: [
        if (isMobile) ...[
          Visibility(
            visible: cardVisible,
              child: CardContainer(
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextTypography(
                                  type: TextType.TITLE,
                                  text: type == UserType.SISWA ? "Di halaman ini, kamu bisa melihat data diri yang kamu miliki seperti tingkat kelas hingga rombel kelasmu. Kamu juga "
                                      "bisa mengubah data diri tersebut dengan menekan tombol Ubah Profil dibawah ini ya."
                                      : "Di halaman ini, bapak/ibu bisa melihat informasi detail mengenai siswa yang bapak ibu lihat. Jika ingin melihat hasil tes siswa ini, pilih tombol Hasil Tes, "
                                      "dan jika ingin memasukkan nilai akhir dari siswa, tekan tombol Input Nilai Akhir",
                                ),
                                if (!kIsWeb || isMobile) ...[
                                  const SizedBox(height: 20),
                                  ButtonWidget(
                                    background: green,
                                    tint: white,
                                    type: ButtonType.MEDIUM,
                                    content: "Mengerti",
                                    onPressed: () async {
                                      setState(() {
                                        cardVisible = !cardVisible;
                                      });
                                      if (!kIsWeb) {
                                        final SharedPreferences prefs = await _prefs;
                                        prefs.setBool("profileCard", cardVisible);
                                      }
                                    },
                                  )
                                ]
                              ],
                            ),
                          )
                      )
                    ],
                  )
              )
          ),
          const SizedBox(height: 20),
          Center(
            child: CircleAvatarCustom(
                fromNetwork: student.photo,
                path: "assets/images/no_image.png",
                isWeb: kIsWeb,
                radius: isMobile ? 50: 80),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if ((type == UserType.SISWA && student.kuesioner == 0) || type != UserType.SISWA)...[
                Expanded(
                    child: ButtonWidget(
                      background: green,
                      tint: white,
                      type: ButtonType.MEDIUM,
                      content: type == UserType.SISWA ? "Mulai Tes" : "Hasil Tes",
                      onPressed: () {
                        if (type == UserType.SISWA) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const Questionnaire(),
                              ));
                        } else {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => StudentHome(type: type, student: student, expandedContents: true),
                              ));
                        }
                      },
                    )
                ),
                const SizedBox(width: 20)
              ],
              Expanded(
                  child: ButtonWidget(
                    background: green,
                    tint: green,
                    type: ButtonType.OUTLINED,
                    content: type == UserType.SISWA ? "Ubah Profil" : "Input Nilai Akhir",
                    onPressed: () {
                      if (type == UserType.SISWA) {
                        Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => StudentProfileUpdate(student: student),
                            )).then(onBackPage);
                      } else {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TeacherScoreInput(type: type, student: student, isFieldReadOnly: false),
                            ));
                      }
                    },
                  )
              ),
            ],
          ),
          const SizedBox(height: 20),
          BiodataCard(user_data: student),
          StatusProfileCard(type: UserType.SISWA, student_data: student)
        ] else ...[
          Visibility(
              visible: cardVisible,
              child: CardContainer(
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextTypography(
                                  type: TextType.TITLE,
                                  text: type == UserType.SISWA ? "Di halaman ini, kamu bisa melihat data diri yang kamu miliki seperti tingkat kelas hingga rombel kelasmu. Kamu juga "
                                      "bisa mengubah data diri tersebut dengan menekan tombol Ubah Profil dibawah ini ya."
                                      : "Di halaman ini, bapak/ibu bisa melihat informasi detail mengenai siswa yang bapak ibu lihat. Jika ingin melihat hasil tes siswa ini, pilih tombol Hasil Tes, "
                                      "dan jika ingin memasukkan nilai akhir dari siswa, tekan tombol Input Nilai Akhir",
                                ),
                                if (!kIsWeb || isMobile) ...[
                                  const SizedBox(height: 20),
                                  ButtonWidget(
                                    background: green,
                                    tint: white,
                                    type: ButtonType.MEDIUM,
                                    content: "Mengerti",
                                    onPressed: () async {
                                      setState(() {
                                        cardVisible = !cardVisible;
                                      });
                                      final SharedPreferences prefs = await _prefs;
                                      prefs.setBool("profileCard", cardVisible);
                                    },
                                  )
                                ]
                              ],
                            ),
                          )
                      )
                    ],
                  )
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: CircleAvatarCustom(
                            fromNetwork: student.photo,
                            path: "assets/images/no_image.png",
                            isWeb: kIsWeb,
                            radius: isMobile ? 50: 80),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if ((type == UserType.SISWA && student.kuesioner == 0) || type != UserType.SISWA)...[
                            ButtonWidget(
                              background: green,
                              tint: white,
                              type: ButtonType.MEDIUM,
                              content: type == UserType.SISWA ? "Mulai Tes" : "Hasil Tes",
                              onPressed: () {
                                if (type == UserType.SISWA) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const Questionnaire(),
                                      ));
                                } else {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => StudentHome(type: type, student: student, expandedContents: true),
                                      ));
                                }
                              },
                            ),
                            const SizedBox(height: 20)
                          ],
                          ButtonWidget(
                            background: green,
                            tint: green,
                            type: ButtonType.OUTLINED,
                            content: type == UserType.SISWA ? "Ubah Profil" : "Input Nilai Akhir",
                            onPressed: () {
                              if (type == UserType.SISWA) {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentProfileUpdate(student: student),
                                    )).then(onBackPage);
                              } else {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => TeacherScoreInput(type: type, student: student, isFieldReadOnly: false),
                                    ));
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  )
              ),
              Expanded(flex: 6, child: BiodataCard(user_data: student)),
            ],
          ),
          StatusProfileCard(type: UserType.SISWA, student_data: student)
        ]
      ],
    );
  }

}