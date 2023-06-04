import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:non_cognitive/ui/components/chart/bar.dart';
import 'package:non_cognitive/ui/components/core/card_container.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';

class PsychologyCard extends StatelessWidget {
  final String title;
  final List<Map<String, String>> information;
  const PsychologyCard({super.key, required this.title, required this.information});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        children: [
          TextTypography(
            type: TextType.TITLE,
            text: title,
          ),
          for (var i = 0; i < information.length; i++)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    if (i % 2 == 0) ...[
                      Align(
                        alignment: Alignment.center,
                        child: Lottie.asset(information[i]["images"]!,
                            repeat: true, animate: true, reverse: false, height: MediaQuery.of(context).size.height * 0.1),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextTypography(type: TextType.TITLE, text: information[i]["title"]!),
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextTypography(
                                    type: TextType.DESCRIPTION,
                                    text: information[i]["description"]!,
                                    align: TextAlign.justify,
                                  )
                              ),
                            ],
                          )
                      )
                    ] else ...[
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextTypography(type: TextType.TITLE, text: information[i]["title"]!),
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextTypography(
                                    type: TextType.DESCRIPTION,
                                    text: information[i]["description"]!,
                                    align: TextAlign.justify,
                                  )
                              ),
                            ],
                          )
                      ),
                      const SizedBox(width: 30),
                      Align(
                        alignment: Alignment.center,
                        child: Lottie.asset(information[i]["images"]!,
                            repeat: true, animate: true, reverse: false, height: MediaQuery.of(context).size.height * 0.1),
                      )
                    ]
                  ],
                )
              ],
            )
        ],
      ),
    );
  }

}