import 'package:auth_app/core/theme/theme.dart';
import '/../data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:auth_app/features/home/page/home_page.dart';
import 'package:auth_app/features/auth/page/login_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth with BloC App',
      theme: AppTheme.darkThemeMode,
      initialRoute: '/login',
      onGenerateRoute: (settings){
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
              builder: (context) => LoginPage(),
            );
          case '/home':
            return MaterialPageRoute(
              builder: (context) => 
              HomePage(authenticatedUser: settings.arguments as User?),
              settings: settings,
            );
          default:
          return null;
        }
      },
    );
  }
}