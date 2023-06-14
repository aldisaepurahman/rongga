import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/student/student_bloc.dart';
import 'package:non_cognitive/data/bloc/student/student_event.dart';
import 'package:non_cognitive/data/model/bottom_sheet_item.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/circle_avatar.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/bottom_sheet.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_no_button.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_photo_button.dart';
import 'package:non_cognitive/ui/components/dialog/loading_dialog.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/components/forms/radio_button.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/change_password.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class StudentProfileUpdate extends StatefulWidget {
  final Student student;

  const StudentProfileUpdate({super.key, required this.student});

  @override
  State<StatefulWidget> createState() => _StudentProfileUpdate();
}

class _StudentProfileUpdate extends State<StudentProfileUpdate> {
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

  late List<BottomSheetCustomItem> bottom_sheet_profile_list =
      <BottomSheetCustomItem>[];

  /*final idNumberController = TextEditingController(text: "198242749");
  final nameController = TextEditingController(text: "Rahman Aji");
  final emailController = TextEditingController(text: "ajirahman@gmail.com");*/
  String _genderType = "Laki-laki";

  /*final telpController = TextEditingController(text: "0895635117001");
  final addressController = TextEditingController(text: "Jl. Nusa Persada Jakarta");
  final tahunController = TextEditingController(text: "2022");
  final rombelController = TextEditingController(text: "7C");*/
  String _statusSiswa = "Peserta didik baru";
  String _tingkatSiswa = "VII (Tujuh)";
  String _imagePath = "";
  String _tempImagePath = "";

  late TextEditingController idNumberController;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController telpController;
  late TextEditingController addressController;
  late TextEditingController tahunController;
  late TextEditingController rombelController;

  File? imageFile;
  Uint8List? webImage;
  bool isSubmitted = false;
  Map<String, dynamic> student_data = {};
  String filenames = "";
  int method = 0;
  bool cardVisible = true;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void editPhotoWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogPhotoButton(
          title: "Halo!",
          content:
          "Coba pilih salah satu opsi dibawah ini.",
          path_image: "assets/images/caution.json",
          buttonLeft: "Ambil Gambar Dari Galeri",
          buttonRight: "Hapus Foto Profil",
          buttonBottom: "Kembali",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
            _getProfilePhoto();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            deletePhotoWarningDialog();
          },
          onPressedButtonBottom: () {
            Navigator.of(context).pop();
          }
        );
      },
    );
  }

  void deletePhotoWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Tunggu, ya!",
          content:
          "Kamu yakin ingin menghapus foto profilmu?",
          path_image: "assets/images/caution.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            isSubmitted = true;
            validateAndSend(2);
          },
        );
      },
    );
  }

  void backWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content:
              "Perubahan yang anda inginkan tidak akan tersimpan. Anda yakin akan membatalkan perubahan ini?",
          path_image: "assets/images/caution.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void submitWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content: "Apakah anda yakin dengan perubahan ini?",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pop();
            isSubmitted = true;
            validateAndSend(1);
            // Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> _saveSession() async {
    final SharedPreferences prefs = await _prefs;

    prefs.remove("user");

    var users = {
      "id": widget.student!.id_users,
      "no_induk": idNumberController.text,
      "nama": nameController.text,
      "email": emailController.text,
      "password": widget.student!.password,
      "gender": _genderType,
      "no_telp": telpController.text,
      "photo": (method == 1) ? (filenames.isNotEmpty) ? "${widget.student!.id_users}_$filenames" : widget.student!.photo : "",
      "alamat": addressController.text,
      "id_sekolah": widget.student!.id_sekolah,
      "id_siswa": widget.student!.id_siswa,
      "tahun_masuk": tahunController.text,
      "status_awal_siswa": statusSiswaOpt[_statusSiswa],
      'tingkat': tingkatKelasNumOpt[_tingkatSiswa],
      'prev_tahun_ajaran': widget.student!.prev_tahun_ajaran,
      'kuesioner': widget.student!.kuesioner,
      'deskripsi': _tingkatSiswa,
      'rombel': widget.student!.tingkat != tingkatKelasNumOpt[_tingkatSiswa] ? "" : widget.student!.rombel,
      'id_tahun_ajaran': widget.student!.id_tahun_ajaran,
      'tahun_ajaran': widget.student!.tahun_ajaran,
      'token': widget.student!.token
    };

    prefs.setString("user", jsonEncode(users));
  }

  void validateAndSend(int method) async {
    filenames = (method == 1 && (webImage != null || imageFile != null)) ? "${DateFormat('ddMMyyyy_hhmmss').format(DateTime.now())}.jpg" : "";
    this.method = method;

    student_data = {
      "id": widget.student!.id_users,
      "no_induk": idNumberController.text,
      "nama": nameController.text,
      "email": emailController.text,
      "gender": _genderType,
      "telp": telpController.text,
      "tempPhoto": widget.student!.photo,
      "alamat": addressController.text,
      "status_siswa": statusSiswaOpt[_statusSiswa],
      "id_tingkat_siswa": tingkatKelasOpt[_tingkatSiswa],
      "tahun_masuk": tahunController.text,
      "method": method
    };

    if ((webImage != null || imageFile != null) && (method != 2)) {
      student_data["photo"] = (kIsWeb) ? await MultipartFile.fromBytes(webImage!, filename: filenames) : await MultipartFile.fromFile(imageFile!.path, filename: filenames);
    }
    print(student_data.toString());

    if (student_data["no_induk"].isNotEmpty && student_data["email"].isNotEmpty && student_data["nama"].isNotEmpty
    && student_data["gender"].isNotEmpty && student_data["status_siswa"] > 0 && student_data["id_tingkat_siswa"] > 0
    && student_data["tahun_masuk"].isNotEmpty) {
      BlocProvider.of<StudentBloc>(context).add(StudentUpdateProfile(student: student_data, token: widget.student.token!));
    }
     else {
      showSubmitDialog(4);
    }
  }

  void showSubmitDialog(int dialogType) {
    String imgPath = (dialogType > 1)
        ? (dialogType == 2)
        ? "assets/images/happy-student-success.json"
        : "assets/images/learn-incorrect.json"
        : "assets/images/loading_icon.json";
    String content = (dialogType > 1)
        ? (dialogType == 2)
        ? "Hore, profilmu sudah berhasil diperbarui."
        : "Duh, pastiin semua data terisi serta format foto yang digunakan harus JPG/PNG."
        : "";

    showDialog(
      context: context,
      builder: (context) {
        if (dialogType == 2) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<StudentBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 3) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<StudentBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 4) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<StudentBloc>(context).add(ResetEvent());
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

  void _getProfilePhoto() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.image,
        // allowedExtensions: ['jpg', 'jpeg', 'png'],
        allowMultiple: false);

    if (pickedFile != null) {
      setState(() {
        if (!kIsWeb) {
          imageFile = File(pickedFile.files.single.path!);
        } else {
          webImage = pickedFile.files.single.bytes;
        }
      });
    }
    /*if (!kIsWeb) {
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
    }*/
  }

  void initProfile() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      cardVisible = prefs.getBool("updateProfileCard") ?? true;
    });
  }

  @override
  void initState() {
    super.initState();
    initProfile();
    BlocProvider.of<StudentBloc>(context).add(ResetEvent());

    bottom_sheet_profile_list = [
      BottomSheetCustomItem(
        icon: Icons.photo,
        title: "Ambil Gambar dari Galeri",
        onTap: () {
          Navigator.of(context).pop();
          _getProfilePhoto();
        },
      ),
      BottomSheetCustomItem(
          icon: Icons.delete_outline,
          title: "Hapus Foto Profil",
          onTap: () {
            Navigator.of(context).pop();
            deletePhotoWarningDialog();
          },
          color: red),
    ];

    /*if (!kIsWeb) {
      bottom_sheet_profile_list.insert(1, BottomSheetCustomItem(
        icon: Icons.camera_alt,
        title: "Ambil Gambar dari Camera",
        onTap: () {
          Navigator.of(context).pop();
        },
      ));
    }*/

    idNumberController = TextEditingController(text: widget.student.idNumber);
    nameController = TextEditingController(text: widget.student.name);
    emailController = TextEditingController(text: widget.student.email);
    telpController = TextEditingController(text: widget.student.no_telp);
    addressController = TextEditingController(text: widget.student.address);
    tahunController = TextEditingController(text: widget.student.tahun_masuk);
    rombelController = TextEditingController(text: widget.student.rombel);

    _genderType = widget.student.gender!;
    _statusSiswa = statusSiswaList[widget.student.status_siswa! - 1];
    _tingkatSiswa = widget.student.deskripsi!;
    _imagePath = widget.student.photo!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _showMobile = MediaQuery.of(context).size.width < screenMd;

    return MainLayout(
        type: UserType.SISWA,
        menu_name: "Update Profil",
        floatingButton: ButtonWidget(
          background: orange,
          tint: black,
          type: ButtonType.FLOAT,
          icon: Icons.save,
          onPressed: () {
            submitWarningDialog();
          },
        ),
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
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
                            backWarningDialog();
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 25, left: 25, bottom: 15),
                    child: TextTypography(
                        text: "Update Profil", type: TextType.HEADER),
                  )
                ],
              ),
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
                                      text: "Di halaman ini, kamu bisa mengubah data pribadi yang dapat dilihat oleh guru di sekolahmu. Pastikan "
                                          "untuk melengkapi semua data yang ada disini ya.",
                                    ),
                                    if (!kIsWeb) ...[
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
                                            prefs.setBool(
                                                "updateProfileCard", cardVisible);
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
                child: Stack(
                  children: [
                    CircleAvatarCustom(
                        image: imageFile,
                        fromNetwork: _imagePath,
                        path: "assets/images/no_image.png",
                        webPreview: webImage,
                        isWeb: kIsWeb,
                        radius: _showMobile ? 50 : 80),
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
                            if (kIsWeb) {
                              editPhotoWarningDialog();
                            } else {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  // <-- SEE HERE
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                builder: (context) => BottomSheetCustom(
                                    items: bottom_sheet_profile_list),
                              );
                            }
                          },
                        ))
                  ],
                ),
              ),
              if (_showMobile) _renderMobile() else _renderWeb(),
              BlocConsumer<StudentBloc, RonggaState>(
                listener: (_, state) {},
                builder: (_, state) {
                  if (state is LoadingState) {
                    if (isSubmitted) {
                      Future.delayed(const Duration(seconds: 1), () {
                        showSubmitDialog(1);
                      });
                    }
                  } if (state is FailureState) {
                    isSubmitted = !isSubmitted;
                    Future.delayed(const Duration(seconds: 1), () {
                      showSubmitDialog(3);
                    });
                  } if (state is CrudState) {
                    isSubmitted = !isSubmitted;
                    if (state.datastore) {
                      _saveSession();
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
            ]));
  }

  ListView _renderMobile() {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: TextTypography(
              type: TextType.LABEL_TITLE, text: "NIS (Nomor Induk Siswa)"),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: TextInputCustom(
            controller: idNumberController,
            hint: "NIS atau NIP",
            type: TextInputCustomType.WITH_ICON,
            icon: Icons.numbers,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child:
              TextTypography(type: TextType.LABEL_TITLE, text: "Nama Lengkap"),
        ),
        Container(
            margin: const EdgeInsets.only(top: 15),
            child: TextInputCustom(
              controller: nameController,
              hint: "Nama Lengkap",
              type: TextInputCustomType.WITH_ICON,
              icon: Icons.person,
            )),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: TextTypography(type: TextType.LABEL_TITLE, text: "Email"),
        ),
        Container(
            margin: const EdgeInsets.only(top: 15),
            child: TextInputCustom(
              controller: emailController,
              hint: "Email",
              type: TextInputCustomType.WITH_ICON,
              icon: Icons.email,
            )),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: TextTypography(
              type: TextType.LABEL_TITLE, text: "Jenis Kelamin Anda"),
        ),
        Container(
            height: 30,
            margin: const EdgeInsets.only(top: 15),
            child: RadioButton(
              type: RadioType.HORIZONTAL,
              choiceList: const <String>["Laki-laki", "Perempuan"],
              selectedChoice: _genderType,
              onSelectedChoice: (value) {
                _genderType = value!;
              },
            )),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child:
              TextTypography(type: TextType.LABEL_TITLE, text: "No. Telepon"),
        ),
        Container(
            margin: const EdgeInsets.only(top: 15),
            child: TextInputCustom(
              controller: telpController,
              hint: "No. Telepon",
              type: TextInputCustomType.WITH_ICON,
              icon: Icons.phone,
            )),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: TextTypography(type: TextType.LABEL_TITLE, text: "Alamat"),
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
          margin: const EdgeInsets.only(top: 20),
          child: RichText(
            text: TextSpan(
                style: TextStyle(
                    color: green,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins"),
                children: [
                  TextSpan(
                      text: "Lupa password anda?",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ChangePassword(type: UserType.SISWA, id_user: widget.student.id_users!, token: widget.student.token!)));
                        })
                ]),
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 25),
            child: TextTypography(type: TextType.TITLE, text: "Status Siswa"),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child:
              TextTypography(type: TextType.LABEL_TITLE, text: "Status Awal"),
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
          child:
              TextTypography(type: TextType.LABEL_TITLE, text: "Tingkat Kelas"),
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
        Container(
          margin: const EdgeInsets.only(top: 15),
          child:
              TextTypography(type: TextType.LABEL_TITLE, text: "Tahun Masuk"),
        ),
        Container(
            margin: const EdgeInsets.only(top: 15),
            child: TextInputCustom(
              controller: tahunController,
              hint: "Tahun Masuk",
              type: TextInputCustomType.WITH_ICON,
              icon: Icons.date_range,
            ))
      ],
    );
  }

  ListView _renderWeb() {
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: TextTypography(
                      type: TextType.LABEL_TITLE,
                      text: "NIS (Nomor Induk Siswa)"),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: TextInputCustom(
                    controller: idNumberController,
                    hint: "NIS atau NIP",
                    type: TextInputCustomType.WITH_ICON,
                    icon: Icons.numbers,
                  ),
                )
              ],
            )),
            const SizedBox(width: 20),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: TextTypography(
                      type: TextType.LABEL_TITLE, text: "Nama Lengkap"),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: TextInputCustom(
                      controller: nameController,
                      hint: "Nama Lengkap",
                      type: TextInputCustomType.WITH_ICON,
                      icon: Icons.person,
                    ))
              ],
            )),
            const SizedBox(width: 20),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child:
                      TextTypography(type: TextType.LABEL_TITLE, text: "Email"),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: TextInputCustom(
                      controller: emailController,
                      hint: "Email",
                      type: TextInputCustomType.WITH_ICON,
                      icon: Icons.email,
                    ))
              ],
            )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextTypography(
                  type: TextType.LABEL_TITLE, text: "Jenis Kelamin Anda"),
            ),
            const SizedBox(width: 20),
            Container(
                height: 30,
                margin: const EdgeInsets.only(top: 15),
                child: RadioButton(
                  type: RadioType.HORIZONTAL,
                  choiceList: const <String>["Laki-laki", "Perempuan"],
                  selectedChoice: _genderType,
                  onSelectedChoice: (value) {
                    _genderType = value!;
                  },
                )),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: TextTypography(
                      type: TextType.LABEL_TITLE, text: "No. Telepon"),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: TextInputCustom(
                      controller: telpController,
                      hint: "No. Telepon",
                      type: TextInputCustomType.WITH_ICON,
                      icon: Icons.phone,
                    ))
              ],
            )),
            const SizedBox(width: 20),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: TextTypography(
                          type: TextType.LABEL_TITLE, text: "Alamat"),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: TextInputCustom(
                          controller: addressController,
                          hint: "Alamat",
                          type: TextInputCustomType.WITH_ICON,
                          icon: Icons.location_on,
                        ))
                  ],
                )),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: RichText(
            text: TextSpan(
                style: TextStyle(
                    color: green,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins"),
                children: [
                  TextSpan(
                      text: "Lupa password anda?",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ChangePassword(type: UserType.SISWA, id_user: widget.student.id_users!, token: widget.student.token!)));
                        })
                ]),
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 25),
            child: TextTypography(type: TextType.TITLE, text: "Status Siswa"),
          ),
        ),
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Column(
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
                          items: statusSiswaList))
                ],
              )),
              const SizedBox(width: 20),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: TextTypography(
                        type: TextType.LABEL_TITLE, text: "Tingkat Kelas"),
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
                          items: tingkatKelasList))
                ],
              )),
              const SizedBox(width: 20),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: TextTypography(
                        type: TextType.LABEL_TITLE, text: "Tahun Masuk"),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: TextInputCustom(
                        controller: tahunController,
                        hint: "Tahun Masuk",
                        type: TextInputCustomType.WITH_ICON,
                        icon: Icons.date_range,
                      ))
                ],
              )),
            ]),
      ],
    );
  }
}
