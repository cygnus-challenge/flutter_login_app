import 'package:auth_app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_app/features/home/cubit/user_cubit.dart';
import 'package:auth_app/features/home/view/home_page.dart';
import 'package:auth_app/features/auth/cubit/login_cubit.dart';
import 'package:auth_app/features/auth/views/login_page.dart';
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
      routes: {
        '/': (context) => BlocProvider(
          create: (_) => LoginCubit(),
          child: LoginPage()
        ),
        '/home': (context) => BlocProvider(
          create: (_) => UserCubit()..loadUsers(),
          child: const HomePage(), 
        ),
      },
      initialRoute: '/',
    );
  }
}