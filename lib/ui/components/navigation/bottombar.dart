import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/color.dart';

class BottomNavBar extends StatefulWidget {
  final Function callback;
  /*final ValueChanged<int> currentPageIndex;
  final ValueChanged<int> nextPageIndex;*/

  const BottomNavBar({super.key, required this.callback,
    // required this.currentPageIndex, required this.nextPageIndex
  });

  @override
  _BottomNavBar createState() => _BottomNavBar();
}

class _BottomNavBar extends State<BottomNavBar> {
  int _selectedBarIcon = 0;

  void _changeBarIcon(int indexIcon) {
    // widget.currentPageIndex(_selectedBarIcon);
    setState(() {
      _selectedBarIcon = indexIcon;
    });
    // widget.nextPageIndex(indexIcon);
    widget.callback(indexIcon);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Cari",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      currentIndex: _selectedBarIcon,
      onTap: _changeBarIcon,
      unselectedLabelStyle: TextStyle(
        fontFamily: "Poppins",
        color: white,
        fontSize: 12,
      ),
      selectedLabelStyle: TextStyle(
          fontFamily: "Poppins",
          color: orange,
          fontSize: 12,
          fontWeight: FontWeight.bold
      ),
      unselectedItemColor: white,
      selectedItemColor: orange,
      backgroundColor: skyBlue,
    );
  }

}