import 'package:flutter/cupertino.dart';
import 'package:non_cognitive/ui/components/badges/badges.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/circle_avatar.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/utils/user_type.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class ItemSearchCard extends StatelessWidget {
  final String name;
  final String id_number;
  final String image;
  final UserType type;
  final BadgesType? badgesType;
  final VoidCallback? onCheckDetailed;

  const ItemSearchCard({
    super.key,
    required this.name,
    required this.id_number,
    required this.image,
    required this.type,
    this.onCheckDetailed,
    this.badgesType});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatarCustom(
                  fromNetwork: image,
                  path: "assets/images/no_image.png",
                  isWeb: kIsWeb,
                  radius: 30),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTypography(
                      type: TextType.TITLE,
                      text: name,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextTypography(
                              type: TextType.DESCRIPTION,
                              text: id_number,
                            ),
                            /*if (type == UserType.SISWA)
                              Badges(type: badgesType!)*/
                          ],
                        )
                    ),
                  ],
                )
              )
            ],
          ),
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ButtonWidget(
                background: orange,
                tint: black,
                type: ButtonType.LARGE_WIDE,
                content: "Cek Detail",
                onPressed: onCheckDetailed,
              )
          ),
        ],
      ),
    );
  }

}