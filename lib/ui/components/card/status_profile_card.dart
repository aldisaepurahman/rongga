import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/student.dart';
import 'package:non_cognitive/data/model/users.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/item_list/status_profile_item_list.dart';
import 'package:non_cognitive/utils/user_type.dart';

import '../../../data/model/teacher.dart';

class StatusProfileCard extends StatelessWidget {
  final Student? student_data;
  final Teacher? teacher_data;
  final UserType type;
  const StatusProfileCard({super.key, this.student_data, this.teacher_data, required this.type});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextTypography(
              type: TextType.TITLE,
              text: (type == UserType.SISWA) ? "Status Siswa" : "Status Guru",
            ),
            const SizedBox(height: 15),
            if (type == UserType.SISWA) ...[
              StatusProfileItemList(
                  label: "Status Awal",
                  description: (student_data?.status_siswa == 1) ? "Peserta didik baru" : "Peserta didik pindahan dari sekolah lain"
              ),
              const SizedBox(height: 15),
              StatusProfileItemList(
                  label: "Tahun Masuk",
                  description: student_data?.tahun_masuk ?? ""
              ),
              const SizedBox(height: 15),
              StatusProfileItemList(
                  label: "Tingkat Kelas",
                  description: student_data?.deskripsi ?? ""
              ),
              const SizedBox(height: 15),
              StatusProfileItemList(
                  label: "Rombel Kelas",
                  description: student_data?.rombel ?? ""
              )
            ]
            else ... [
              StatusProfileItemList(
                  label: "Status Awal",
                  description: (teacher_data?.status_kerja == 1) ? "Guru tetap" : "Guru honorer"
              ),
              const SizedBox(height: 15),
              StatusProfileItemList(
                  label: "Spesialisasi Mata Pelajaran",
                  description: teacher_data?.spesialisasi ?? ""
              ),
            ],
          ],
        )
    );
  }

}