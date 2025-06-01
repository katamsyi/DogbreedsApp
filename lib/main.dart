import 'package:finalproject/pages/splashscreen.dart';
import 'package:finalproject/routes/route.dart';
import 'package:finalproject/service/notification_service.dart';
import 'package:finalproject/service/profile_database_helper.dart'; 
import 'package:flutter/material.dart';

void main() async {
  // Pastikan Flutter bindings diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  
  // HANYA UNTUK DEVELOPMENT/TESTING - Reset database
  // Comment/hapus baris ini setelah masalah teratasi
  // try {
  //   await ProfileDatabaseHelper.resetDatabase();
  //   print('Database reset successfully');
  // } catch (e) {
  //   print('Error resetting database: $e');
  // }
  
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