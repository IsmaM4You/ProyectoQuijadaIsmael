import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto/pages/MainMenu.dart';
import 'package:proyecto/pages/Register_Page.dart';

class LoginPage extends StatefulWidget {
  final void Function(bool loggedIn) updateLoginStatus;

  const LoginPage({Key? key, required this.updateLoginStatus}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessageFromBackend = '';
  String _accessToken = '';

  Future<void> _login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://quijada.terrabyteco.com/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final accessToken = jsonData['access_token'];
        final userId = jsonData['user']['id']; // Obtener el ID del usuario

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', accessToken);
        await prefs.setInt('userId', userId); // Almacenar el ID del usuario
        prefs.setBool('isLoggedIn', true);
        widget.updateLoginStatus(true);

        setState(() {
          _accessToken = accessToken;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainMenu(title: 'YahooNiggan')),
        );
      } else {
        final responseData = json.decode(response.body);
        final errorMessage = responseData['message'];
        setState(() {
          _errorMessageFromBackend = errorMessage ?? 'Error desconocido al iniciar sesión';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessageFromBackend = 'Error al iniciar sesión. Por favor, intenta nuevamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();
                _login(email, password);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessageFromBackend,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
