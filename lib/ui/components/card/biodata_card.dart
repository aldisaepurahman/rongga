import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/item_list/profile_item_list.dart';

class BiodataCard extends StatelessWidget {
  const BiodataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextTypography(
              type: TextType.TITLE,
              text: "Biodata",
            ),
            const SizedBox(height: 15),
            const ProfileItemList(
                icon: Icons.numbers_sharp,
                label: "NIS",
                description: "198242749"
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: gray,
            ),
            const ProfileItemList(
                icon: Icons.person,
                label: "Nama",
                description: "Rahman Aji"
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: gray,
            ),
            const ProfileItemList(
                icon: Icons.email,
                label: "Email",
                description: "ajirahman@gmail.com"
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: gray,
            ),
            const ProfileItemList(
                icon: Icons.man,
                label: "Jenis Kelamin",
                description: "Laki-laki"
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: gray,
            ),
            const ProfileItemList(
                icon: Icons.phone,
                label: "No. Telepon",
                description: "0895635117001"
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: gray,
            ),
            const ProfileItemList(
                icon: Icons.home_outlined,
                label: "Alamat",
                description: "Jl. Nusa Persada Jakarta"
            ),
          ],
        )
    );
  }

}