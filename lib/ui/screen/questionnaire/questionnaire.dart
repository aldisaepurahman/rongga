import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/card/question_card.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/dialog/dialog_double_button.dart';
import 'package:non_cognitive/ui/components/navigation/appbar.dart';
import 'package:non_cognitive/ui/layout/main_layout.dart';
import 'package:non_cognitive/ui/screen/main_menu/siswa/home_student.dart';
import 'package:non_cognitive/ui/screen/navigations.dart';
import 'package:non_cognitive/utils/questionnaire_list.dart';
import 'package:non_cognitive/utils/user_type.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({super.key});

  @override
  State<StatefulWidget> createState() => _Questionnaire();
}

class _Questionnaire extends State<Questionnaire> {
  final _controller = PageController();
  static const _duration = Duration(milliseconds: 300);
  static const _curve = Curves.ease;

  void backWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogDoubleButton(
          title: "Peringatan!",
          content:
              "Jawaban yang anda pilih tidak akan tersimpan. Anda yakin akan membatalkan tes ini?",
          path_image: "assets/images/caution.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const StudentHome(type: UserType.SISWA, expandedContents: true),
                ));
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
          content: "Apakah anda yakin dengan jawaban yang anda pilih?",
          path_image: "assets/images/questionmark.json",
          buttonLeft: "Tidak",
          buttonRight: "Ya",
          onPressedButtonLeft: () {
            Navigator.of(context).pop();
          },
          onPressedButtonRight: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const StudentHome(type: UserType.SISWA, expandedContents: true),
                ));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        type: UserType.SISWA,
        menu_name: "Lembar Tes",
        child: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) {},
          children: [
            for (var i = 0; i < questionnaire_list.length; i++)
              ListView(shrinkWrap: true, children: [
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
                          text: "Lembar Tes",
                          type: TextType.HEADER
                      ),
                    )
                  ],
                ),
                CardContainer(
                    child: Column(
                      children: [
                        TextTypography(
                          type: TextType.TITLE,
                          text: questionnaire_list[i].title,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextTypography(
                              type: TextType.DESCRIPTION,
                              text: questionnaire_list[i].description,
                            )),
                      ],
                    )),
                for (var questions in questionnaire_list[i].question_list)
                  QuestionCard(
                    question: questions,
                    onSelectedChoice: (value) {
                      questions.groupValue = value!;
                    },
                    onAlternativeFilled: (value) {
                      questions.alternativeValue = value;
                    },
                  ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (i > 0)
                          ButtonWidget(
                            background: green,
                            tint: green,
                            type: ButtonType.OUTLINED_SMALL,
                            content: "Sebelumnya",
                            onPressed: () {
                              _controller.previousPage(
                                  duration: _duration, curve: _curve);
                            },
                          ),
                        const SizedBox(width: 10),
                        ButtonWidget(
                          background: green,
                          tint: white,
                          type: ButtonType.SMALL,
                          content: (i != questionnaire_list.length - 1)
                              ? "Selanjutnya"
                              : "Selesai",
                          onPressed: () {
                            (i != questionnaire_list.length - 1)
                                ? _controller.nextPage(
                                duration: _duration, curve: _curve)
                                : submitWarningDialog();
                          },
                        )
                      ],
                    )),
              ])
          ],
        )
    );
  }
}
