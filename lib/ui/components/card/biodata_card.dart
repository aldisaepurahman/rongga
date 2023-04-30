import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/teacher.dart';
import 'package:non_cognitive/data/model/users.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/item_list/profile_item_list.dart';
import 'package:non_cognitive/utils/user_type.dart';

class BiodataCard extends StatelessWidget {
  final Users user_data;
  const BiodataCard({super.key, required this.user_data});

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
            ProfileItemList(
                icon: Icons.numbers_sharp,
                label: (user_data is Teacher) ? "NIP" : "NIS",
                description: user_data.idNumber!
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: gray,
            ),
            ProfileItemList(
                icon: Icons.person,
                label: "Nama",
                description: user_data.name!
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: gray,
            ),
            ProfileItemList(
                icon: Icons.email,
                label: "Email",
                description: user_data.email!
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: gray,
            ),
            ProfileItemList(
                icon: Icons.man,
                label: "Jenis Kelamin",
                description: user_data.gender!
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: gray,
            ),
            ProfileItemList(
                icon: Icons.phone,
                label: "No. Telepon",
                description: user_data.no_telp!
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: gray,
            ),
            ProfileItemList(
                icon: Icons.location_on,
                label: "Alamat",
                description: user_data.address!
            ),
          ],
        )
    );
  }

}