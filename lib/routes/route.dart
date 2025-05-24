import 'package:finalproject/components/navbar.dart';
import 'package:finalproject/pages/convert.dart';
import 'package:finalproject/pages/homepage.dart';
import 'package:finalproject/pages/login.dart';
import 'package:finalproject/pages/profile.dart';
import 'package:finalproject/pages/register.dart';
import 'package:finalproject/pages/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case '/navbar':
        return MaterialPageRoute(builder: (_) => NavBar());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case '/review':
        return MaterialPageRoute(builder: (_) => SaranKesan());
      case '/convert':
        return MaterialPageRoute(builder: (_) => ConvertPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text('Error page')),
      );
    });
  }
}
