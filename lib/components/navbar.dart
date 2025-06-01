import 'package:finalproject/pages/convert.dart';
import 'package:finalproject/pages/homepage.dart';
import 'package:finalproject/pages/profile.dart';
import 'package:finalproject/pages/review.dart';
import 'package:finalproject/pages/petshop_page.dart';
import 'package:finalproject/pages/premium_upgrade_page.dart'; // Import halaman premium upgrade
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  // List pages - index 1 (Convert) menggunakan Container placeholder
  // karena akan diakses melalui premium upgrade page
  final List<Widget> pages = [
    HomePage(), // index 0 - Dogs
    Container(), // index 1 - Convert (placeholder)
    SaranKesan(), // index 2 - Review
    ProfilePage(), // index 3 - Profile
    PetshopPage(), // index 4 - Petshop
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      // Ketika user klik tab Convert (index 1)
      // Langsung navigate ke halaman premium upgrade
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PremiumUpgradePage(),
        ),
      );
      // Tidak mengubah _selectedIndex agar tab tidak berubah warna
      return;
    }

    // Untuk tab lainnya, update selected index seperti biasa
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
                icon: Icon(Icons.calculate), label: 'Upgrade'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notes_rounded), label: 'Review'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Petshop'),
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
