import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/constants.dart';
import 'package:non_cognitive/ui/screen/auth/login.dart';
import 'package:non_cognitive/ui/screen/auth/register.dart';
import 'package:non_cognitive/ui/screen/onboarding/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticatePage extends StatefulWidget {
  final bool onboard;
  const AuthenticatePage({super.key, required this.onboard});

  @override
  State<StatefulWidget> createState() => _AuthenticatePage();

}

class _AuthenticatePage extends State<AuthenticatePage> {
  final _controller = PageController();
  static const _duration = Duration(milliseconds: 300);
  static const _curve = Curves.ease;
  bool visible = true;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _saveOnboardingSession() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("onboard", true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _showMobile = MediaQuery.of(context).size.width < screenMd;

    if (_showMobile) {
      return Scaffold(
        body: ListView(
          children: [
            Visibility(
              visible: (widget.onboard) ? false : visible,
                child: SizedBox(
                  height: 800,
                  child: OnboardingPage(
                      isMobilePage: _showMobile,
                      onButtonClicked: (int value) {
                        setState(() {
                          if (value == 1) {
                            visible = false;
                            _saveOnboardingSession();
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