import 'package:finalproject/pages/splashscreen.dart';
import 'package:finalproject/routes/route.dart';
import 'package:finalproject/service/notification_service.dart'; // Sesuaikan path
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: NotificationOverlay(
        child: const SplashScreen(),
      ),
    );
  }
}
