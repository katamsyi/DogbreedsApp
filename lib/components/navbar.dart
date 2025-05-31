import 'package:finalproject/pages/convert.dart';
import 'package:finalproject/pages/homepage.dart';
import 'package:finalproject/pages/profile.dart';
import 'package:finalproject/pages/review.dart';
import 'package:finalproject/pages/petshop_page.dart'; // import halaman petshop
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  // Tambahkan PetshopPage ke list pages
  final List<Widget> pages = [
    HomePage(),
    ConvertPage(),
    SaranKesan(),
    ProfilePage(),
    PetshopPage(),
  ];

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
        data: ThemeData(canvasColor: const Color(0xffCEAB93)),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Iconsax.note), label: 'Dogs'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calculate), label: 'Convert'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notes_rounded), label: 'Review'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded), label: 'Profile'),
            BottomNavigationBarItem(
                icon: Icon(Icons.store), label: 'Petshop'), // item baru
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xffFFFBE9),
          unselectedItemColor: const Color(0xff854836),
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
