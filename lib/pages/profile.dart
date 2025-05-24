import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: "Kaifa Ahlal Katamsyi");
  final TextEditingController _nimController =
      TextEditingController(text: "123220006");
  final TextEditingController _emailController =
      TextEditingController(text: "kaifaahlalkatamsyi@gmail.com");
  final TextEditingController _birthDateController =
      TextEditingController(text: "23 April 2004");
  final TextEditingController _mottoController =
      TextEditingController(text: "Man Jadda Wa jada");

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text("Profile"),
      //   backgroundColor: Color(0xffCEAB93),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3 + 50,
                  decoration: BoxDecoration(color: Colors.white),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                      color: Color(0xffCEAB93),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 50,
                    left: 165,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        SizedBox(width: 100),
                        IconButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content:
                                    const Text('Are you sure want to log out?'),
                                actions: <TextButton>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'No',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await prefs.remove('username');
                                      if (mounted) {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/login',
                                                (Route<dynamic> route) =>
                                                    false);
                                      }
                                    },
                                    child: const Text('Yes',
                                        style: TextStyle(color: Colors.black)),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.logout_outlined),
                        ),
                      ],
                    )),
                Positioned(
                  left: 100,
                  top: 100,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/image/kai.jpg'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  _nameField(),
                  SizedBox(height: 20),
                  _nimField(),
                  SizedBox(height: 20),
                  _emailField(),
                  SizedBox(height: 20),
                  _birthDateField(),
                  SizedBox(height: 20),
                  _mottoField(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _nameField() {
    return TextField(
      enabled: false,
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.account_circle,
          color: Color(0xffAD8B73),
          size: 25,
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _nimField() {
    return TextField(
      enabled: false,
      controller: _nimController,
      decoration: InputDecoration(
        labelText: 'NIM',
        labelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.contacts_outlined,
          color: Color(0xffAD8B73),
          size: 25,
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextField(
      enabled: false,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.email_rounded,
          color: Color(0xffAD8B73),
          size: 25,
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _birthDateField() {
    return TextField(
      enabled: false,
      controller: _birthDateController,
      decoration: InputDecoration(
        labelText: 'Birth Date',
        labelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.cake,
          color: Color(0xffAD8B73),
          size: 25,
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _mottoField() {
    return TextField(
      enabled: false,
      controller: _mottoController,
      decoration: InputDecoration(
        labelText: 'Motto',
        labelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.note,
          color: Color(0xffAD8B73),
          size: 25,
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 18.0,
        ),
      ),
    );
  }
}
