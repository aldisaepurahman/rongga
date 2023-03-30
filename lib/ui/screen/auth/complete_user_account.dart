import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/bottom_sheet_item.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/circle_avatar.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/bottom_sheet.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';
import 'package:non_cognitive/ui/components/forms/dropdown_filter.dart';
import 'package:non_cognitive/ui/screen/auth/complete_student_info.dart';
import 'package:non_cognitive/ui/screen/auth/complete_teacher_info.dart';
import 'package:non_cognitive/ui/screen/navigations.dart';
import 'package:non_cognitive/utils/user_type.dart';

class CompleteUserAccount extends StatefulWidget {
  final UserType type;
  const CompleteUserAccount({super.key, required this.type});

  @override
  State<CompleteUserAccount> createState() => _CompleteUserAccount();

}

class _CompleteUserAccount extends State<CompleteUserAccount> {
  final telpController = TextEditingController();
  final schoolController = TextEditingController();
  final addressController = TextEditingController();

  late List<BottomSheetCustomItem> bottom_sheet_profile_list = <BottomSheetCustomItem>[];

  final Map<String, int> tingkatKelasOpt = {
    "VII (Tujuh)": 7,
    "VIII (Delapan)": 8,
    "IX (Sembilan)": 9,
  };

  final List<String> tingkatKelasList = ["VII (Tujuh)", "VIII (Delapan)", "IX (Sembilan)"];

  final Map<String, int> statusSiswaOpt = {
    "Peserta didik baru": 0,
    "Peserta didik pindahan dari sekolah lain": 1,
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

  final tahunController = TextEditingController(text: "2022");
  final rombelController = TextEditingController(text: "7C");
  String _statusSiswa = "Peserta didik baru";
  String _tingkatSiswa = "VII (Tujuh)";

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
            /*Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Navigations(type: widget.type, hasExpandedContents: false),
                ));*/
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
          content: type == 1 ? "Apakah anda yakin dengan informasi yang anda masukkan?" : "Jika tidak melengkapi data akun, anda bisa melengkapinya pada halaman profil anda, yakin untuk lewati?",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            /*Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Navigations(type: UserType.SISWA, hasExpandedContents: false),
                ));*/
          },
        );
      },
    );
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
        },
      ),
      BottomSheetCustomItem(
        icon: Icons.camera_alt,
        title: "Ambil Gambar dari Camera",
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    ];
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
                      type: TextType.HEADER,
                      text: "Lengkapi Data Akun Anda"
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Center(
                  child: TextTypography(
                    type: TextType.DESCRIPTION,
                    text: "Lengkapi data diri berikut ini untuk menyelesaikan proses registrasi akun anda",
                    align: TextAlign.center,
                  ),
                ),
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
                                    text: "Foto Profil Anda"
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: Center(
                                child: Stack(
                                  children: [
                                    const CircleAvatarCustom(
                                        image: "",
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
                                            showModalBottomSheet(
                                              context: context,
                                              shape: const RoundedRectangleBorder( // <-- SEE HERE
                                                borderRadius: BorderRadius.vertical(
                                                  top: Radius.circular(25.0),
                                                ),
                                              ),
                                              builder: (context) => BottomSheetCustom(items: bottom_sheet_profile_list),
                                            );
                                          },
                                        )
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: TextTypography(
                                type: TextType.LABEL_TITLE,
                                text: widget.type == UserType.SISWA ? "Asal Sekolah" : "Sekolah Tempat Mengajar"
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: TextInputCustom(
                                controller: schoolController,
                                hint: widget.type == UserType.SISWA ? "Asal Sekolah" : "Sekolah Tempat Mengajar",
                                type: TextInputCustomType.WITH_ICON,
                                icon: Icons.school_outlined,
                              )
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: TextTypography(
                                type: TextType.MINI_DESCRIPTION,
                                text: "Misal : SMP Negeri 1 Bandung"
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: TextTypography(
                                type: TextType.LABEL_TITLE,
                                text: "No. Telepon Aktif"
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
                          if (widget.type == UserType.SISWA)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: TextTypography(
                                      type: TextType.LABEL_TITLE,
                                      text: "Status Awal"
                                  ),
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
                                        items: statusSiswaList
                                    )
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: TextTypography(
                                      type: TextType.LABEL_TITLE,
                                      text: "Tahun Masuk"
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: TextInputCustom(
                                      controller: tahunController,
                                      hint: "Tahun",
                                      type: TextInputCustomType.WITH_ICON,
                                      icon: Icons.date_range,
                                    )
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: TextTypography(
                                      type: TextType.LABEL_TITLE,
                                      text: "Tingkat Kelas"
                                  ),
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
                                        items: tingkatKelasList
                                    )
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: TextTypography(
                                      type: TextType.LABEL_TITLE,
                                      text: "Rombel Kelas"
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: TextInputCustom(
                                      controller: rombelController,
                                      hint: "Rombel Kelas",
                                      type: TextInputCustomType.WITH_ICON,
                                      icon: Icons.class_rounded,
                                    )
                                ),
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
                                )
                              ],
                            ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: TextTypography(
                                type: TextType.LABEL_TITLE,
                                text: "Alamat Rumah"
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
                                    submitWarningDialog(1);
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    )
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
                            type: TextType.LABEL_TITLE,
                            text: "Foto Profil Anda"
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Center(
                        child: Stack(
                          children: [
                            const CircleAvatarCustom(
                                image: "",
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
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder( // <-- SEE HERE
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0),
                                        ),
                                      ),
                                      builder: (context) => BottomSheetCustom(items: bottom_sheet_profile_list),
                                    );
                                  },
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: TextTypography(
                          type: TextType.LABEL_TITLE,
                          text: widget.type == UserType.SISWA ? "Asal Sekolah" : "Sekolah Tempat Mengajar"
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: TextInputCustom(
                          controller: schoolController,
                          hint: widget.type == UserType.SISWA ? "Asal Sekolah" : "Sekolah Tempat Mengajar",
                          type: TextInputCustomType.WITH_ICON,
                          icon: Icons.school_outlined,
                        )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: TextTypography(
                          type: TextType.MINI_DESCRIPTION,
                          text: "Misal : SMP Negeri 1 Bandung"
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: TextTypography(
                          type: TextType.LABEL_TITLE,
                          text: "No. Telepon Aktif"
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
                    if (widget.type == UserType.SISWA)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: TextTypography(
                                type: TextType.LABEL_TITLE,
                                text: "Status Awal"
                            ),
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
                                  items: statusSiswaList
                              )
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: TextTypography(
                                type: TextType.LABEL_TITLE,
                                text: "Tahun Masuk"
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: TextInputCustom(
                                controller: tahunController,
                                hint: "Tahun",
                                type: TextInputCustomType.WITH_ICON,
                                icon: Icons.date_range,
                              )
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: TextTypography(
                                type: TextType.LABEL_TITLE,
                                text: "Tingkat Kelas"
                            ),
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
                                  items: tingkatKelasList
                              )
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: TextTypography(
                                type: TextType.LABEL_TITLE,
                                text: "Rombel Kelas"
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: TextInputCustom(
                                controller: rombelController,
                                hint: "Rombel Kelas",
                                type: TextInputCustomType.WITH_ICON,
                                icon: Icons.class_rounded,
                              )
                          ),
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
                          )
                        ],
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: TextTypography(
                          type: TextType.LABEL_TITLE,
                          text: "Alamat Rumah"
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
                      margin: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextButton(
                              onPressed: () {
                                submitWarningDialog(2);
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
                              submitWarningDialog(1);
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
                          )
                        ],
                      ),
                    )
                  ],
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