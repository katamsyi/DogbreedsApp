import 'package:finalproject/pages/convert.dart';
import 'package:finalproject/pages/homepage.dart';
import 'package:finalproject/pages/profile.dart';
import 'package:finalproject/pages/review.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  List pages = [HomePage(), ConvertPage(), SaranKesan(), ProfilePage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: Theme(
          data: ThemeData(canvasColor: Color(0xffCEAB93)),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Iconsax.note), label: 'Dogs'),
              BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Convert'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notes_rounded), label: 'Review'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_rounded), label: 'Profile'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xffFFFBE9),
            unselectedItemColor: Color(0xff854836),
            onTap: _onItemTapped,
          ),
        ));
  }
}
