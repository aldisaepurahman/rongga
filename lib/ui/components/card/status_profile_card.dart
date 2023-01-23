import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/item_list/status_profile_item_list.dart';

class StatusProfileCard extends StatelessWidget {
  const StatusProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextTypography(
              type: TextType.TITLE,
              text: "Status Siswa",
            ),
            const SizedBox(height: 15),
            const StatusProfileItemList(
              label: "Status Awal",
              description: "Peserta didik baru"
            ),
            const SizedBox(height: 15),
            const StatusProfileItemList(
                label: "Tahun Masuk",
                description: "2022"
            ),
            const SizedBox(height: 15),
            const StatusProfileItemList(
                label: "Tingkat Kelas",
                description: "VII (Tujuh)"
            ),
            const SizedBox(height: 15),
            const StatusProfileItemList(
                label: "Rombel Kelas",
                description: "7C"
            ),
          ],
        )
    );
  }

}