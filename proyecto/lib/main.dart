import 'package:flutter/material.dart';
import 'package:proyecto/pages/MainMenu.dart';
import 'package:proyecto/pages/Login_Page.dart';
import 'package:proyecto/pages/Register_Page.dart';
import 'package:proyecto/InicioPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IsmaApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/menu',
      routes: {
        '/menu': (context) => MainMenu(title: 'YahooNiggan'),
        '/login': (context) => LoginPage(updateLoginStatus: (bool loggedIn) {  },),
        '/register': (context) => RegisterPage(),
        '/home': (context) => InicioPage(title: 'La mera Papaya'),
      },
    );
  }
}
