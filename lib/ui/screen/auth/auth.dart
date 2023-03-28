import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/screen/auth/login.dart';
import 'package:non_cognitive/ui/screen/auth/register.dart';
import 'package:non_cognitive/ui/screen/onboarding/onboarding_page.dart';

class AuthenticatePage extends StatefulWidget {
  const AuthenticatePage({super.key});

  @override
  State<StatefulWidget> createState() => _AuthenticatePage();

}

class _AuthenticatePage extends State<AuthenticatePage> {
  final _controller = PageController();
  static const _duration = Duration(milliseconds: 300);
  static const _curve = Curves.ease;
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    final _showMobile = MediaQuery.of(context).size.width < screenMd;

    if (_showMobile) {
      return Scaffold(
        body: ListView(
          children: [
            Visibility(
              visible: visible,
                child: SizedBox(
                  height: 800,
                  child: OnboardingPage(
                      isMobilePage: _showMobile,
                      onButtonClicked: (int value) {
                        setState(() {
                          if (value == 1) {
                            visible = false;
                          }
                        });
                      }
                  ),
                )
            ),
            SizedBox(
              height: 800,
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) {},
                children: [
                  Login(isMobilePage: _showMobile, onTextClicked: () {
                    _controller.nextPage(
                        duration: _duration, curve: _curve);
                  }),
                  Register(isMobilePage: _showMobile, onTextClicked:() {
                    _controller.previousPage(
                        duration: _duration, curve: _curve);
                  })
                ],
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: OnboardingPage(isMobilePage: _showMobile)
          ),
          Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) {},
                children: [
                  Login(isMobilePage: _showMobile, onTextClicked: () {
                    _controller.nextPage(
                        duration: _duration, curve: _curve);
                  }),
                  Register(isMobilePage: _showMobile, onTextClicked:() {
                    _controller.previousPage(
                        duration: _duration, curve: _curve);
                  })
                ],
              )
          )
        ],
      ),
    );
  }
}