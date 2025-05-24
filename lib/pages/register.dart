import 'package:finalproject/model/user.dart';
import 'package:finalproject/service/user_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String error = "";
  late UserModel _currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F5E7),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 350,
              child: Stack(
                children: [
                  Positioned(
                      top: 40,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        children: [
                          Image.asset("assets/image/splash_screen.png"),
                          Text(
                            "Woofye",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            _usernameField(),
            SizedBox(height: 20),
            _passwordField(),
            SizedBox(height: 10),
            _registerButton(),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(
                    color: Color(0xffAD8B73),
                    fontSize: 14.0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/login');
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Color(0xffF4BFBF),
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _usernameField() {
    return TextField(
      controller: _usernameController,
      cursorColor: Color(0xffAD8B73),
      decoration: InputDecoration(
        labelText: 'Username',
        hintText: 'username',
        labelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
        ),
        prefixIcon: Icon(
          Iconsax.user,
          color: Color(0xffAD8B73),
          size: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 18.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextField(
      obscureText: true,
      controller: _passwordController,
      cursorColor: Color(0xffAD8B73),
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'password',
        labelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
        ),
        prefixIcon: Icon(
          Iconsax.lock,
          color: Color(0xffAD8B73),
          size: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 18.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return MaterialButton(
      onPressed: () async {
        if (_usernameController.text.isEmpty ||
            _passwordController.text.isEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: const Text('Please fill all data first!'),
              actions: <TextButton>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return; // Menghentikan eksekusi jika data tidak lengkap
        }

        // Menambahkan debug print untuk melihat data yang dimasukkan
        print("Username: ${_usernameController.text}");
        print("Password: ${_passwordController.text}");

        // Membuat objek UserModel untuk data yang dimasukkan
        UserModel user = UserModel(
            username: _usernameController.text,
            password: _passwordController.text);

        try {
          // Mencetak log sebelum menambahkan pengguna ke database
          print("Mencoba untuk menambahkan pengguna ke database...");
          await userDatabaseHelper.createUser(user);
          print("Pengguna berhasil ditambahkan ke database");

          // Mengambil pengguna yang baru didaftarkan untuk verifikasi
          var listUser = await userDatabaseHelper.getUserByUsernameAndPassword(
              _usernameController.text, _passwordController.text);

          // Debug log untuk melihat apakah pengguna berhasil ditemukan
          print("Pengguna ditemukan: ${listUser.length}");

          if (listUser.length > 0) {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: const Text('Registration Success!'),
                actions: <TextButton>[
                  TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "/login");
                      _usernameController.clear();
                      _passwordController.clear();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            print("Pengguna tidak ditemukan setelah registrasi.");
            Navigator.pop(context);
          }
        } catch (e) {
          setState(() {
            error = e.toString();
            print("Terjadi kesalahan saat registrasi: $error"); // Debug error
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: Text('$error'),
                actions: <TextButton>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          });
          return;
        }
        setState(() {
          error = "User Created";
        });
      },
      height: 45,
      color: Color(0xffAD8B73),
      child: Text(
        "Register",
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
