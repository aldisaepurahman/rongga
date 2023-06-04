import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/data/bloc/auth/auth_event.dart';
import 'package:non_cognitive/data/bloc/auth/login_bloc.dart';
import 'package:non_cognitive/data/bloc/auth/register_detail_bloc.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/model/bottom_sheet_item.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/data/model/users.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/circle_avatar.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/bottom_sheet.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_no_button.dart';
import 'package:non_cognitive/ui/components/dialog/loading_dialog.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/screen/main_menu/guru/home_teacher.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/home_student.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteUserAccount extends StatefulWidget {
  final UserType type;
  final String no_induk;
  final String password;

  const CompleteUserAccount(
      {super.key,
      required this.type,
      required this.no_induk,
      required this.password});

  @override
  State<CompleteUserAccount> createState() => _CompleteUserAccount();
}

class _CompleteUserAccount extends State<CompleteUserAccount> {
  final telpController = TextEditingController();

  // final schoolController = TextEditingController();
  final addressController = TextEditingController();

  late List<BottomSheetCustomItem> bottom_sheet_profile_list =
      <BottomSheetCustomItem>[];

  final Map<String, int> tingkatKelasOpt = {
    "VII (Tujuh)": 1,
    "VIII (Delapan)": 2,
    "IX (Sembilan)": 3,
  };

  final Map<String, int> tingkatKelasNumOpt = {
    "VII (Tujuh)": 7,
    "VIII (Delapan)": 8,
    "IX (Sembilan)": 9,
  };

  final List<String> tingkatKelasList = [
    "VII (Tujuh)",
    "VIII (Delapan)",
    "IX (Sembilan)"
  ];

  final Map<String, int> statusSiswaOpt = {
    "Peserta didik baru": 1,
    "Peserta didik pindahan dari sekolah lain": 2,
    // "Peserta didik tidak naik kelas 1x": 2,
    // "Lulus": 3,
    // "Keluar": 4,
  };

  final List<String> statusSiswaList = [
    "Peserta didik baru",
    "Peserta didik pindahan dari sekolah lain",
    // "Peserta didik tidak naik kelas 1x",
    // "Lulus",
    // "Keluar",
  ];

  final Map<String, int> sekolahOpt = {"SMPN 36 Bandung": 1};

  final List<String> sekolahList = ["SMPN 36 Bandung"];

  final tahunController = TextEditingController(text: "2022");
  final rombelController = TextEditingController(text: "7C");
  String _sekolah = "SMPN 36 Bandung";
  String _statusSiswa = "Peserta didik baru";
  String _tingkatSiswa = "VII (Tujuh)";

  final Map<String, int> statusGuruOpt = {"Guru Tetap": 1, "Guru Honorer": 2};

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

  final Map<String, String> kelompokMapelOpt = {
    "Pendidikan Agama dan Budi Pekerti": "A (Umum)",
    "Pendidikan Pancasila dan Kewarganegaraan": "A (Umum)",
    "Bahasa Indonesia": "A (Umum)",
    "Matematika": "A (Umum)",
    "Bahasa Inggris": "A (Umum)",
    "Ilmu Pengetahuan Alam": "A (Umum)",
    "Ilmu Pengetahuan Sosial": "A (Umum)",
    "Seni Budaya dan Prakarya": "B (Umum)",
    "Pendidikan Jasmani, Olahraga dan Kesehatan": "B (Umum)",
    "Bahasa Daerah": "B (Umum)",
    "Bimbingan dan Konseling": "C (Khusus)"
  };

  final List<String> statusGuruList = ["Guru Tetap", "Guru Honorer"];

  final List<String> mapelList = [
    "Pendidikan Agama dan Budi Pekerti",
    "Pendidikan Pancasila dan Kewarganegaraan",
    "Bahasa Indonesia",
    "Matematika",
    "Ilmu Pengetahuan Alam",
    "Ilmu Pengetahuan Sosial",
    "Bahasa Inggris",
    "Seni Budaya dan Prakarya",
    "Bahasa Daerah",
    "Pendidikan Jasmani, Olahraga dan Kesehatan",
    "Bimbingan dan Konseling"
  ];

  String _ahliMapel = "Pendidikan Agama dan Budi Pekerti";
  String _statusKerja = "Guru Tetap";

  String _imagePath = "";
  File? imageFile;
  Uint8List? webImage;
  bool isSubmitted = false;
  Map<String, dynamic> users_data = {};
  String filenames = "";
  int method = 0;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _saveSession(Map<String, Object> user) async {
    final SharedPreferences prefs = await _prefs;
    var users;

    if (user["type"] == 0) {
      users = user["user_data"] as Users;
    } else if (user["type"] == 1) {
      users = user["user_data"] as Student;
    } else {
      users = user["user_data"] as Teacher;
    }

    prefs.setString("user", jsonEncode(users.toLocalJson()));

    Future.delayed(const Duration(milliseconds: 2000), () {
      BlocProvider.of<LoginBloc>(context).add(ResetEvent());
      if (widget.type == UserType.SISWA) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const StudentHome(
                type: UserType.SISWA, expandedContents: false)));
      } else if (_ahliMapel == "Bimbingan dan Konseling"){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const TeacherHome(type: UserType.GURU_BK)));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const TeacherHome(type: UserType.GURU)));
      }
    });
  }

  void backWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content:
              "Informasi yang anda masukkan tidak akan tersimpan. Anda yakin akan membatalkan proses melengkapi profil anda?",
          path_image: "assets/images/caution.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            isSubmitted = true;
            method = 0;
            validateAndSend();
            /*if (widget.type == UserType.SISWA) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => StudentHome(type: widget.type, expandedContents: false),
                ));
            }*/
          },
        );
      },
    );
  }

  void submitWarningDialog(int type) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Tunggu Dulu!",
          content: type == 1
              ? "Apakah anda yakin dengan informasi yang anda masukkan?"
              : "Jika tidak melengkapi data akun, anda bisa melengkapinya pada halaman profil anda, yakin untuk lewati?",
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
            validateAndSend();
            /*if (widget.type == UserType.SISWA) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => StudentHome(type: widget.type, expandedContents: false),
                  ));
            }*/
          },
        );
      },
    );
  }

  void showSubmitDialog(int dialogType) {
    String imgPath = (dialogType > 1)
        ? (dialogType == 2)
            ? "assets/images/happy-student-success.json"
            : "assets/images/learn-incorrect.json"
        : "assets/images/loading_icon.json";
    String content = (dialogType > 1)
        ? (dialogType == 2)
            ? "Bagus, Ayo lanjut ke halaman aplikasi kalian."
            : "Duh, ada masalah dengan server aplikasi. Coba beberapa saat lagi."
        : "";

    showDialog(
      context: context,
      builder: (context) {
        if (dialogType == 2) {
          Future.delayed(const Duration(milliseconds: 700), () {
            BlocProvider.of<RegisterDetailBloc>(context).add(ResetEvent());
          });
          Future.delayed(const Duration(milliseconds: 1400), () {
            BlocProvider.of<LoginBloc>(context).add(AuthLogin(
                no_induk: widget.no_induk, password: widget.password));
          });
        } else if (dialogType == 3) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<RegisterDetailBloc>(context).add(ResetEvent());
          });
        }
        if (dialogType > 1) {
          return DialogNoButton(path_image: imgPath, content: content);
        }
        return LoadingDialog(path_image: imgPath);
      },
    );
  }

  void validateAndSend() async {
    filenames = (webImage != null || imageFile != null)
        ? "${DateFormat('ddMMyyyy_hhmmss').format(DateTime.now())}.jpg"
        : "";

    if (widget.type == UserType.SISWA) {
      users_data = {
        "no_induk": widget.no_induk,
        "id_sekolah": sekolahOpt[_sekolah],
        "no_telp": telpController.text,
        "alamat": addressController.text,
        "status_awal_siswa": statusSiswaOpt[_statusSiswa],
        "tahun_masuk": tahunController.text,
        "id_tingkat_kelas": tingkatKelasOpt[_tingkatSiswa],
      };
    } else {
      users_data = {
        "no_induk": widget.no_induk,
        "id_sekolah": sekolahOpt[_sekolah],
        "no_telp": telpController.text,
        "alamat": addressController.text,
        "status_kerja": statusGuruOpt[_statusKerja],
        "id_mapel": mapelOpt[_ahliMapel],
      };
    }

    if (webImage != null || imageFile != null) {
      users_data["photo"] = (kIsWeb)
          ? await MultipartFile.fromBytes(webImage!, filename: filenames)
          : await MultipartFile.fromFile(imageFile!.path, filename: filenames);
    }
    print(users_data.toString());

    BlocProvider.of<RegisterDetailBloc>(context).add(AuthRegisterDetail(
        isStudent: widget.type == UserType.SISWA ? true : false,
        user: users_data));
  }

  void _getProfilePhoto(ImageSource source) async {
    if (!kIsWeb) {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
      );

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    } else if (kIsWeb) {
      final pickedFile = await ImagePickerWeb.getImageAsBytes();

      if (pickedFile != null) {
        setState(() {
          webImage = pickedFile;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    bottom_sheet_profile_list = [
      BottomSheetCustomItem(
        icon: Icons.photo,
        title: "Ambil Gambar dari Galeri",
        onTap: () {
          Navigator.of(context).pop();
          _getProfilePhoto(ImageSource.gallery);
        },
      )
    ];

    /*if (!kIsWeb) {
      bottom_sheet_profile_list.insert(
          1,
          BottomSheetCustomItem(
            icon: Icons.camera_alt,
            title: "Ambil Gambar dari Camera",
            onTap: () {
              Navigator.of(context).pop();
            },
          ));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    final _showMobile = MediaQuery.of(context).size.width < screenMd;

    return WillPopScope(
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          children: [
            Container(
              margin: const EdgeInsets.only(top: 23),
              child: Center(
                child: TextTypography(
                    type: TextType.HEADER, text: "Lengkapi Data Akun Anda"),
              ),
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
                            text: widget.type == UserType.SISWA ? "Di halaman ini, kamu perlu melengkapi data diri yang diperlukan oleh sistem. Jika masih belum "
                                "yakin dengan data diri yang ada, kamu bisa melewatinya dan melengkapi di halaman profil. Namun, pastikan pilihan tingkat kelas terpilih dengan benar."
                                : "Di halaman ini, bapak/ibu perlu melengkapi data diri yang diperlukan oleh sistem. Jika masih belum "
                                "yakin dengan data diri yang ada, kamu bisa melewatinya dan melengkapi di halaman profil. Namun, pastikan pilihan spesialisasi dan status guru terpilih dengan benar.",
                          ),
                        )
                    )
                  ],
                )
            ),
            if (!_showMobile)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Center(
                              child: TextTypography(
                                  type: TextType.LABEL_TITLE,
                                  text: "Foto Profil Anda"),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Center(
                              child: Stack(
                                children: [
                                  CircleAvatarCustom(
                                      image: imageFile,
                                      fromNetwork: _imagePath,
                                      path: "assets/images/no_image.png",
                                      webPreview: webImage,
                                      isWeb: kIsWeb,
                                      radius: 80),
                                  Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: ButtonWidget(
                                        background: green,
                                        tint: white,
                                        type: ButtonType.FLOAT,
                                        icon: Icons.camera_alt,
                                        miniButton: true,
                                        onPressed: () {
                                          _getProfilePhoto(ImageSource.gallery);
                                          /*showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              // <-- SEE HERE
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(25.0),
                                              ),
                                            ),
                                            builder: (context) =>
                                                BottomSheetCustom(
                                                    items:
                                                        bottom_sheet_profile_list),
                                          );*/
                                        },
                                      ))
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: TextTypography(
                                type: TextType.LABEL_TITLE,
                                text: widget.type == UserType.SISWA
                                    ? "Asal Sekolah"
                                    : "Sekolah Tempat Mengajar"),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: DropdownFilter(
                                  onChanged: (String? value) {
                                    setState(() {
                                      if (value != null) {
                                        _sekolah = value;
                                      }
                                    });
                                  },
                                  content: _sekolah,
                                  items: sekolahList)),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: TextTypography(
                                type: TextType.MINI_DESCRIPTION,
                                text: "Misal : SMP Negeri 1 Bandung"),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: TextTypography(
                                type: TextType.LABEL_TITLE,
                                text: "No. Telepon Aktif"),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: TextInputCustom(
                                controller: telpController,
                                hint: "No. Telepon",
                                type: TextInputCustomType.WITH_ICON,
                                icon: Icons.phone,
                              )),
                          if (widget.type == UserType.SISWA)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: TextTypography(
                                      type: TextType.LABEL_TITLE,
                                      text: "Status Awal"),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: DropdownFilter(
                                        onChanged: (String? value) {
                                          setState(() {
                                            if (value != null) {
                                              _statusSiswa = value;
                                            }
                                          });
                                        },
                                        content: _statusSiswa,
                                        items: statusSiswaList)),
                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: TextTypography(
                                      type: TextType.LABEL_TITLE,
                                      text: "Tahun Masuk"),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: TextInputCustom(
                                      controller: tahunController,
                                      hint: "Tahun",
                                      type: TextInputCustomType.WITH_ICON,
                                      icon: Icons.date_range,
                                    )),
                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: TextTypography(
                                      type: TextType.LABEL_TITLE,
                                      text: "Tingkat Kelas"),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: DropdownFilter(
                                        onChanged: (String? value) {
                                          setState(() {
                                            if (value != null) {
                                              _tingkatSiswa = value;
                                            }
                                          });
                                        },
                                        content: _tingkatSiswa,
                                        items: tingkatKelasList)),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: TextTypography(
                                      type: TextType.LABEL_TITLE,
                                      text: "Status Ikatan Kerja"),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: DropdownFilter(
                                        onChanged: (String? value) {
                                          setState(() {
                                            if (value != null) {
                                              _statusKerja = value;
                                            }
                                          });
                                        },
                                        content: _statusKerja,
                                        items: statusGuruList)),
                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: TextTypography(
                                      type: TextType.LABEL_TITLE,
                                      text: "Spesialisasi Mapel"),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: DropdownFilter(
                                        onChanged: (String? value) {
                                          setState(() {
                                            if (value != null) {
                                              _ahliMapel = value;
                                            }
                                          });
                                        },
                                        content: _ahliMapel,
                                        items: mapelList))
                              ],
                            ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: TextTypography(
                                type: TextType.LABEL_TITLE,
                                text: "Alamat Rumah"),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: TextInputCustom(
                                controller: addressController,
                                hint: "Alamat",
                                type: TextInputCustomType.WITH_ICON,
                                icon: Icons.location_on,
                              )),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      submitWarningDialog(2);
                                      /*if (widget.type == UserType.SISWA) {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => const CompleteStudentInfo(),
                                            ));
                                      } else {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => const CompleteTeacherInfo(),
                                            ));
                                      }*/
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        padding: const EdgeInsets.all(20)),
                                    child: TextTypography(
                                      type: TextType.DESCRIPTION,
                                      text: "Lewati",
                                      color: green,
                                    )),
                                ButtonWidget(
                                  background: green,
                                  tint: white,
                                  type: ButtonType.LARGE,
                                  content: "Simpan",
                                  onPressed: () {
                                    if ((webImage != null || imageFile != null) && _sekolah.isNotEmpty && telpController.text.isNotEmpty) {
                                      submitWarningDialog(1);
                                    } else {
                                      submitWarningDialog(2);
                                    }
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Center(
                      child: TextTypography(
                          type: TextType.LABEL_TITLE, text: "Foto Profil Anda"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Center(
                      child: Stack(
                        children: [
                          CircleAvatarCustom(
                              image: imageFile,
                              fromNetwork: _imagePath,
                              path: "assets/images/no_image.png",
                              webPreview: webImage,
                              isWeb: kIsWeb,
                              radius: 50),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: ButtonWidget(
                                background: green,
                                tint: white,
                                type: ButtonType.FLOAT,
                                icon: Icons.camera_alt,
                                miniButton: true,
                                onPressed: () {
                                  _getProfilePhoto(ImageSource.gallery);
                                  /*showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      // <-- SEE HERE
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0),
                                      ),
                                    ),
                                    builder: (context) => BottomSheetCustom(
                                        items: bottom_sheet_profile_list),
                                  );*/
                                },
                              ))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: TextTypography(
                        type: TextType.LABEL_TITLE,
                        text: widget.type == UserType.SISWA
                            ? "Asal Sekolah"
                            : "Sekolah Tempat Mengajar"),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: DropdownFilter(
                          onChanged: (String? value) {
                            setState(() {
                              if (value != null) {
                                _sekolah = value;
                              }
                            });
                          },
                          content: _sekolah,
                          items: sekolahList)),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: TextTypography(
                        type: TextType.MINI_DESCRIPTION,
                        text: "Misal : SMP Negeri 1 Bandung"),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: TextTypography(
                        type: TextType.LABEL_TITLE, text: "No. Telepon Aktif"),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: TextInputCustom(
                        controller: telpController,
                        hint: "No. Telepon",
                        type: TextInputCustomType.WITH_ICON,
                        icon: Icons.phone,
                      )),
                  if (widget.type == UserType.SISWA)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: TextTypography(
                              type: TextType.LABEL_TITLE, text: "Status Awal"),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: DropdownFilter(
                                onChanged: (String? value) {
                                  setState(() {
                                    if (value != null) {
                                      _statusSiswa = value;
                                    }
                                  });
                                },
                                content: _statusSiswa,
                                items: statusSiswaList)),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: TextTypography(
                              type: TextType.LABEL_TITLE, text: "Tahun Masuk"),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: TextInputCustom(
                              controller: tahunController,
                              hint: "Tahun",
                              type: TextInputCustomType.WITH_ICON,
                              icon: Icons.date_range,
                            )),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: TextTypography(
                              type: TextType.LABEL_TITLE,
                              text: "Tingkat Kelas"),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: DropdownFilter(
                                onChanged: (String? value) {
                                  setState(() {
                                    if (value != null) {
                                      _tingkatSiswa = value;
                                    }
                                  });
                                },
                                content: _tingkatSiswa,
                                items: tingkatKelasList)),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: TextTypography(
                              type: TextType.LABEL_TITLE,
                              text: "Status Ikatan Kerja"),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: DropdownFilter(
                                onChanged: (String? value) {
                                  setState(() {
                                    if (value != null) {
                                      _statusKerja = value;
                                    }
                                  });
                                },
                                content: _statusKerja,
                                items: statusGuruList)),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: TextTypography(
                              type: TextType.LABEL_TITLE,
                              text: "Spesialisasi Mapel"),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: DropdownFilter(
                                onChanged: (String? value) {
                                  setState(() {
                                    if (value != null) {
                                      _ahliMapel = value;
                                    }
                                  });
                                },
                                content: _ahliMapel,
                                items: mapelList))
                      ],
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: TextTypography(
                        type: TextType.LABEL_TITLE, text: "Alamat Rumah"),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: TextInputCustom(
                        controller: addressController,
                        hint: "Alamat",
                        type: TextInputCustomType.WITH_ICON,
                        icon: Icons.location_on,
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextButton(
                            onPressed: () {
                              submitWarningDialog(2);
                              /*if (widget.type == UserType.SISWA) {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => const CompleteStudentInfo(),
                                            ));
                                      } else {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => const CompleteTeacherInfo(),
                                            ));
                                      }*/
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.all(20)),
                            child: TextTypography(
                              type: TextType.DESCRIPTION,
                              text: "Lewati",
                              color: green,
                            )),
                        ButtonWidget(
                          background: green,
                          tint: white,
                          type: ButtonType.LARGE,
                          content: "Simpan",
                          onPressed: () {
                            if ((webImage != null || imageFile != null) && _sekolah.isNotEmpty && telpController.text.isNotEmpty) {
                              submitWarningDialog(1);
                            } else {
                              submitWarningDialog(2);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            BlocConsumer<RegisterDetailBloc, RonggaState>(
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
                  if (method == 1) {
                    if (state.datastore) {
                      Future.delayed(const Duration(seconds: 1), () {
                        showSubmitDialog(2);
                      });
                    } else {
                      Future.delayed(const Duration(seconds: 1), () {
                        showSubmitDialog(3);
                      });
                    }
                  } else {
                    BlocProvider.of<LoginBloc>(context).add(AuthLogin(
                        no_induk: widget.no_induk, password: widget.password));
                  }
                }
                return const SizedBox(width: 0);
              },
            ),
            BlocConsumer<LoginBloc, RonggaState>(
              listener: (_, state) {},
              builder: (_, state) {
                if (state is SuccessState) {
                  _saveSession(state.datastore);
                }
                return const SizedBox(width: 0);
              },
            ),
          ],
        ),
      ),
      onWillPop: () async {
        backWarningDialog();
        return false;
      },
    );
  }
}
