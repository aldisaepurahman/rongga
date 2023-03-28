import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/button.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:non_cognitive/ui/components/core/typography.dart';
import 'package:non_cognitive/ui/components/slider/slider.dart';
import 'package:non_cognitive/ui/screen/auth/register.dart';
import 'package:non_cognitive/utils/onboarding_list.dart';

class OnboardingPage extends StatefulWidget {
  final bool isMobilePage;
  final ValueChanged<int>? onButtonClicked;
  const OnboardingPage({super.key, required this.isMobilePage, this.onButtonClicked});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();

}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    if (!widget.isMobilePage) {
      Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (currentIndex < 1) {
          currentIndex++;
        } else {
          currentIndex = 0;
        }
        _controller.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Image.asset(contents[i].image, width: 300, height: 200),
                      const SizedBox(height: 20),
                      TextTypography(
                          type: TextType.HEADER,
                          text: contents[i].title
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: TextTypography(
                            type: TextType.DESCRIPTION,
                            text: contents[i].description
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(widget.isMobilePage ? 0 : 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                    (index) => SliderCustom(currentIndex: currentIndex, index: index),
              ),
            ),
          ),
          Visibility(
            visible: widget.isMobilePage,
            child: Padding(
                padding: const EdgeInsets.all(50),
                child: ButtonWidget(
                  background: green,
                  tint: white,
                  type: ButtonType.LARGE_WIDE,
                  content: currentIndex != contents.length-1 ? "Lanjut" : "Daftar Sekarang",
                  onPressed: () {
                    if (currentIndex != contents.length-1) {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.bounceIn
                      );
                    }
                    if (widget.isMobilePage) {
                      widget.onButtonClicked!(currentIndex);
                    }
                    /*else {
                      Navigator.of(context).pop();
                    }*/
                  },
                )
            )
          )
        ],
      ),
    );
  }

}