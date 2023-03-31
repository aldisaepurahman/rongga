import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/navigation/sidebar.dart';
import 'package:non_cognitive/utils/user_type.dart';

class MainLayout extends StatefulWidget {
  final UserType type;
  final String menu_name;
  final Widget child;

  const MainLayout({super.key, required this.type, required this.menu_name, required this.child});

  @override
  State<StatefulWidget> createState() => _MainLayout();
}

class _MainLayout extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SidebarCustom(type: widget.type, menu_name: widget.menu_name),
            Expanded(
                child: Column(
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: widget.child,
                          )
                        )
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }

}