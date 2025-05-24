import 'package:finalproject/service/user_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String error = "";

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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Sorry, we're working on getting this fixed ASAP"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                        color: Color(0xffF4BFBF),
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(height: 30),
            MaterialButton(
              onPressed: () async {
                if (_usernameController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  return showDialog(
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
                }
                try {
                  var listUser =
                      await userDatabaseHelper.getUserByUsernameAndPassword(
                          _usernameController.text, _passwordController.text);
                  if (listUser.length > 0) {
                    final snackbar = SnackBar(
                      content: Text('Login Success'),
                    );
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setString('username', listUser[0].username!);
                    pref.setInt('userId', listUser[0].id!);
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/navbar', (Route<dynamic> route) => false);
                  }
                } catch (e) {
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: const Text('Username/password is wrong'),
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
                }
              },
              height: 45,
              color: Color(0xffAD8B73),
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    color: Color(0xffAD8B73),
                    fontSize: 14.0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/register');
                  },
                  child: Text(
                    'Register',
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
}
