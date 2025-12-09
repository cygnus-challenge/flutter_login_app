import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/../core/theme/theme.dart';
import '/../injection_container.dart';
import '/../data/models/user.dart';
import '/../features/home/page/home_page.dart';
import '/../features/auth/page/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = await AppDependencies.init();

  runApp(MyApp(dependencies: dependencies));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: dependencies.pokemonRepository,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auth with BloC App',
        theme: AppTheme.darkThemeMode,
        initialRoute: '/home',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (context) => LoginPage());
            case '/home':
              return MaterialPageRoute(
                builder: (context) => HomePage(
                  authenticatedUser: settings.arguments as User?,
                ),
                settings: settings,
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
