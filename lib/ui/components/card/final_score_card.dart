import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/forms/text_input.dart';

class FinalScoreCard extends StatefulWidget {
  final String nama_mapel;
  int nilai;
  final ValueChanged<int> onScoreChanged;

  FinalScoreCard({super.key, required this.nama_mapel, required this.nilai, required this.onScoreChanged});

  @override
  State<StatefulWidget> createState() => _FinalScoreCard();

}

class _FinalScoreCard extends State<FinalScoreCard> {
  final nilaiController = TextEditingController();

  @override
  void initState() {
    nilaiController.text = widget.nilai.toString();
    super.initState();
  }

  @override
  void dispose() {
    nilaiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 3,
              child: TextTypography(
                type: TextType.TITLE,
                text: widget.nama_mapel,
              ),
            ),
            Expanded(
                flex: 1,
                child: TextInputCustom(
                  controller: nilaiController,
                  hint: "Nilai",
                  type: TextInputCustomType.NORMAL,
                  onChanged: (value) {
                    if (value != null) {
                      widget.onScoreChanged(int.parse(value));
                    } else {
                      widget.onScoreChanged(0);
                    }
                  },
                )
            )
          ],
        ),
        Divider(
          height: 20,
          thickness: 1,
          color: gray,
        )
      ],
    );
  }

}