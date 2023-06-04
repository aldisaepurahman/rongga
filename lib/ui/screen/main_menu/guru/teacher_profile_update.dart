import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/data/bloc/events.dart';
import 'package:non_cognitive/data/bloc/rongga_state.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_bloc.dart';
import 'package:non_cognitive/data/bloc/teacher/teacher_event.dart';
import 'package:non_cognitive/data/model/bottom_sheet_item.dart';
import 'package:non_cognitive/data/model/teacher.dart';
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
import 'package:non_cognitive/ui/components/navigation/appbar.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/change_password.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherProfileUpdate extends StatefulWidget {
  final UserType type;
  final Teacher teacher;
  const TeacherProfileUpdate({super.key, required this.type, required this.teacher});

  @override
  State<StatefulWidget> createState() => _TeacherProfileUpdate();
}

class _TeacherProfileUpdate extends State<TeacherProfileUpdate> {
  /*final Map<String, int> tingkatKelasOpt = {
    "VII (Tujuh)": 7,
    "VIII (Delapan)": 8,
    "IX (Sembilan)": 9,
  };*/

  final List<String> statusGuruList = ["Guru Tetap", "Guru Honorer"];

  final Map<String, int> statusGuruOpt = {
    "Guru Tetap": 1,
    "Guru Honorer": 2
  };

  final List<String> mapelList = [
    "Pendidikan Agama dan Budi Pekerti",
    "Pendidikan Pancasila dan Kewarganegaraan",
    "Bahasa Indonesia",
    "Matematika",
    "Bahasa Inggris",
    "Ilmu Pengetahuan Alam",
    "Ilmu Pengetahuan Sosial",
    "Seni Budaya dan Prakarya",
    "Pendidikan Jasmani, Olahraga dan Kesehatan",
    "Bahasa Daerah",
    "Bimbingan dan Konseling"
  ];

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

  late List<BottomSheetCustomItem> bottom_sheet_profile_list = <BottomSheetCustomItem>[];

  /*final idNumberController = TextEditingController(text: "198242749");
  final nameController = TextEditingController(text: "Rahman Aji");
  final emailController = TextEditingController(text: "ajirahman@gmail.com");*/
  String _genderType = "Laki-laki";
  /*final telpController = TextEditingController(text: "0895635117001");
  final addressController = TextEditingController(text: "Jl. Nusa Persada Jakarta");*/
  String _ahliMapel = "Pendidikan Agama dan Budi Pekerti";
  String _statusKerja = "Guru Tetap";
  String _imagePath = "";

  late TextEditingController idNumberController;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController telpController;
  late TextEditingController addressController;

  File? imageFile;
  Uint8List? webImage;
  bool isSubmitted = false;
  Map<String, dynamic> teacher_data = {};
  String filenames = "";
  int method = 0;

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
              _getProfilePhoto(ImageSource.gallery);
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
          content: "Perubahan yang anda inginkan tidak akan tersimpan. Anda yakin akan membatalkan perubahan ini?",
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
          },
        );
      },
    );
  }

  Future<void> _saveSession() async {
    final SharedPreferences prefs = await _prefs;

    prefs.remove("user");

    var users = {
      "id": widget.teacher!.id_users,
      "no_induk": idNumberController.text,
      "nama": nameController.text,
      "email": emailController.text,
      "password": widget.teacher!.password,
      "gender": _genderType,
      "no_telp": telpController.text,
      "photo": (method == 1) ? (filenames.isNotEmpty) ? "${widget.teacher!.id_users}_$filenames" : widget.teacher!.photo : "",
      "alamat": addressController.text,
      "id_sekolah": widget.teacher!.id_sekolah,
      "id_guru": widget.teacher!.id_guru,
      "status_ikatan_kerja": statusGuruOpt[_statusKerja],
      'spesialisasi': _ahliMapel,
      'kelompok_mapel': widget.teacher!.kelompok_mapel != kelompokMapelOpt[_ahliMapel] ? kelompokMapelOpt[_ahliMapel] : widget.teacher!.kelompok_mapel,
      'wali_kelas': widget.teacher!.wali_kelas,
      'id_tahun_ajaran': widget.teacher!.id_tahun_ajaran,
      'tahun_ajaran': widget.teacher!.tahun_ajaran,
      'token': widget.teacher!.token
    };

    prefs.setString("user", jsonEncode(users));
  }

  void validateAndSend(int method) async {
    filenames = (method == 1 && (webImage != null || imageFile != null)) ? "${DateFormat('ddMMyyyy_hhmmss').format(DateTime.now())}.jpg" : "";
    this.method = method;

    teacher_data = {
      "id": widget.teacher!.id_users,
      "no_induk": idNumberController.text,
      "nama": nameController.text,
      "email": emailController.text,
      "gender": _genderType,
      "telp": telpController.text,
      "tempPhoto": widget.teacher!.photo,
      "alamat": addressController.text,
      "status_kerja": statusGuruOpt[_statusKerja],
      "id_mapel": mapelOpt[_ahliMapel],
      "method": method
    };

    if ((webImage != null || imageFile != null) && (method != 2)) {
      teacher_data["photo"] = (kIsWeb) ? await MultipartFile.fromBytes(webImage!, filename: filenames) : await MultipartFile.fromFile(imageFile!.path, filename: filenames);
    }
    print(teacher_data.toString());

    if (teacher_data["no_induk"].isNotEmpty && teacher_data["email"].isNotEmpty && teacher_data["nama"].isNotEmpty
        && teacher_data["gender"].isNotEmpty && teacher_data["status_kerja"] > 0 && teacher_data["id_mapel"] > 0) {
      BlocProvider.of<TeacherBloc>(context).add(TeacherUpdateProfile(teacher: teacher_data));
    }
    else {
      showSubmitDialog(4);
    }
  }

  void showSubmitDialog(int dialogType) {
    String imgPath = (dialogType > 1)
        ? (dialogType == 2)
        ? "assets/images/success.json"
        : "assets/images/incorrect.json"
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
            BlocProvider.of<TeacherBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 3) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<TeacherBloc>(context).add(ResetEvent());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else if (dialogType == 4) {
          Future.delayed(const Duration(seconds: 2), () {
            BlocProvider.of<TeacherBloc>(context).add(ResetEvent());
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
    BlocProvider.of<TeacherBloc>(context).add(ResetEvent());

    bottom_sheet_profile_list = [
      BottomSheetCustomItem(
        icon: Icons.photo,
        title: "Ambil Gambar dari Galeri",
        onTap: () {
          Navigator.of(context).pop();
          _getProfilePhoto(ImageSource.gallery);
        },
      ),
      BottomSheetCustomItem(
          icon: Icons.delete_outline,
          title: "Hapus Foto Profil",
          onTap: () {
            Navigator.of(context).pop();
            deletePhotoWarningDialog();
          },
          color: red
      ),
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

    idNumberController = TextEditingController(text: widget.teacher.idNumber);
    nameController = TextEditingController(text: widget.teacher.name);
    emailController = TextEditingController(text: widget.teacher.email);
    telpController = TextEditingController(text: widget.teacher.no_telp);
    addressController = TextEditingController(text: widget.teacher.address);

    _genderType = widget.teacher.gender!;
    _ahliMapel = widget.teacher.spesialisasi!;
    _statusKerja = statusGuruList[widget.teacher.status_kerja!-1];
    _imagePath = widget.teacher.photo!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _showMobile = MediaQuery.of(context).size.width < screenMd;

    return MainLayout(
        type: widget.type,
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
                    margin: const EdgeInsets.only(top: 25, left: 25, bottom: 15),
                    child: TextTypography(
                        text: "Update Profil",
                        type: TextType.HEADER
                    ),
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
                              text: "Di halaman ini, bapak/ibu bisa mengubah data pribadi yang dapat dilihat oleh siswa di sekolah anda. Pastikan "
                                  "untuk melengkapi semua data yang ada disini ya.",
                            ),
                          )
                      )
                    ],
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
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                builder: (context) => BottomSheetCustom(
                                    items: bottom_sheet_profile_list),
                              );
                            }
                          },
                        )
                    )
                  ],
                ),
              ),
              if (_showMobile)
                _renderMobile()
              else
                _renderWeb(),
              BlocConsumer<TeacherBloc, RonggaState>(
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
            ]
        )
    );
  }

  ListView _renderMobile() {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: TextTypography(
              type: TextType.LABEL_TITLE,
              text: "NIS (Nomor Induk Siswa)"
          ),
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
          child: TextTypography(
              type: TextType.LABEL_TITLE,
              text: "Nama Lengkap"
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 15),
            child: TextInputCustom(
              controller: nameController,
              hint: "Nama Lengkap",
              type: TextInputCustomType.WITH_ICON,
              icon: Icons.person,
            )
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: TextTypography(
              type: TextType.LABEL_TITLE,
              text: "Email"
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 15),
            child: TextInputCustom(
              controller: emailController,
              hint: "Email",
              type: TextInputCustomType.WITH_ICON,
              icon: Icons.email,
            )
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: TextTypography(
              type: TextType.LABEL_TITLE,
              text: "Jenis Kelamin Anda"
          ),
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
            )
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: TextTypography(
              type: TextType.LABEL_TITLE,
              text: "No. Telepon"
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 15),
            child: TextInputCustom(
              controller: telpController,
              hint: "No. Telepon",
              type: TextInputCustomType.WITH_ICON,
              icon: Icons.phone,
            )
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: TextTypography(
              type: TextType.LABEL_TITLE,
              text: "Alamat"
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 15),
            child: TextInputCustom(
              controller: addressController,
              hint: "Alamat",
              type: TextInputCustomType.WITH_ICON,
              icon: Icons.location_on,
            )
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
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ChangePassword(type: UserType.GURU, id_user: widget.teacher.id_users!))
                          );
                        })
                ]),
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 25),
            child: TextTypography(
                type: TextType.TITLE,
                text: "Status Guru"
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: TextTypography(
              type: TextType.LABEL_TITLE,
              text: "Status Ikatan Kerja"
          ),
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
                items: statusGuruList
            )
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: TextTypography(
              type: TextType.LABEL_TITLE,
              text: "Spesialisasi Mapel"
          ),
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
                items: mapelList
            )
        ),
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
                          text: "NIS (Nomor Induk Siswa)"
                      ),
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
                )
            ),
            const SizedBox(width: 20),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: TextTypography(
                          type: TextType.LABEL_TITLE,
                          text: "Nama Lengkap"
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: TextInputCustom(
                          controller: nameController,
                          hint: "Nama Lengkap",
                          type: TextInputCustomType.WITH_ICON,
                          icon: Icons.person,
                        )
                    )
                  ],
                )
            ),
            const SizedBox(width: 20),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: TextTypography(
                          type: TextType.LABEL_TITLE,
                          text: "Email"
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: TextInputCustom(
                          controller: emailController,
                          hint: "Email",
                          type: TextInputCustomType.WITH_ICON,
                          icon: Icons.email,
                        )
                    )
                  ],
                )
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: TextTypography(
                  type: TextType.LABEL_TITLE,
                  text: "Jenis Kelamin Anda"
              ),
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
                )
            ),
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
                          type: TextType.LABEL_TITLE,
                          text: "No. Telepon"
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: TextInputCustom(
                          controller: telpController,
                          hint: "No. Telepon",
                          type: TextInputCustomType.WITH_ICON,
                          icon: Icons.phone,
                        )
                    )
                  ],
                )
            ),
            const SizedBox(width: 20),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: TextTypography(
                          type: TextType.LABEL_TITLE,
                          text: "Alamat"
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: TextInputCustom(
                          controller: addressController,
                          hint: "Alamat",
                          type: TextInputCustomType.WITH_ICON,
                          icon: Icons.location_on,
                        )
                    )
                  ],
                )
            ),
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
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ChangePassword(type: UserType.GURU, id_user: widget.teacher.id_users!))
                          );
                        })
                ]),
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 25),
            child: TextTypography(
                type: TextType.TITLE,
                text: "Status Guru"
            ),
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
                            type: TextType.LABEL_TITLE,
                            text: "Status Ikatan Kerja"
                        ),
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
                              items: statusGuruList
                          )
                      )
                    ],
                  )
              ),
              const SizedBox(width: 20),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: TextTypography(
                            type: TextType.LABEL_TITLE,
                            text: "Spesialisasi Mapel"
                        ),
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
                              items: mapelList
                          )
                      ),
                    ],
                  )
              )
            ]
        ),
      ],
    );
  }
}