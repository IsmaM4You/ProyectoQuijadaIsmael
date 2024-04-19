import 'package:flutter/material.dart';
import 'package:proyecto/pages/MainMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto/pages/Token.dart'; 

class UsuarioYo extends StatefulWidget {
  final Function() logoutCallback;
  final String? username;

  UsuarioYo({required this.logoutCallback, this.username});

  @override
  _UsuarioYoState createState() => _UsuarioYoState();
}

class _UsuarioYoState extends State<UsuarioYo> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String? _email;
  int? _userId;
  String? _username; 
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    _userId = prefs.getInt('userId');
    _accessToken = token; // Asignar el token de acceso

    if (token != null && _userId != null) {
      var url = Uri.parse('https://quijada.terrabyteco.com/api/users/$_userId');
      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _nameController.text = jsonData['name'];
          _emailController.text = jsonData['email'];
          _email = jsonData['email'];
          _username = jsonData['name']; 
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    _userId = prefs.getInt('userId');

    if (token != null && _userId != null) {
      var url = Uri.parse('https://quijada.terrabyteco.com/api/users/update/$_userId');
      var response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }, body: jsonEncode({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
      }));

      if (response.statusCode == 200) {
        // Actualización exitosa
        print('Datos actualizados correctamente.');
        // Actualizar la página para reflejar los nuevos datos
        _fetchUserData();
      } else {
        // Error al actualizar
        print('Error al actualizar los datos.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Usuario: ${_username ?? ""}', // Usamos _username
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            if (_email != null)
              Text(
                'Email: $_email',
                style: TextStyle(fontSize: 20),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_accessToken != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TokenPage(accessToken: _accessToken!)),
                  );
                } else {
                  // Manejar el caso en el que _accessToken sea nulo
                  print('Error: El token de acceso es nulo.');
                }
              },
              child: const Text('Token Personal'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateUserData();
              },
              child: Text('Actualizar Datos'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                await prefs.remove('userId');
                await prefs.remove('isLoggedIn');
                widget.logoutCallback();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainMenu(title: 'YahooNiggan')),
                );
              },
              child: Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
