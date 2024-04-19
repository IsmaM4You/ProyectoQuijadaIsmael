import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto/Preguntas.dart';
import 'package:proyecto/Categorias.dart';
import 'package:proyecto/UsuarioYo.dart'; 
import 'package:proyecto/pages/Login_Page.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool _isLoggedIn = false;
  String? _username;

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('username');
    setState(() {
      _isLoggedIn = false;
    });
  }

  void _updateLoginStatus(bool loggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = loggedIn;
      if (_isLoggedIn) {
        _username = prefs.getString('username');
      } else {
        _username = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.person), 
            onPressed: () {
              if (_isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsuarioYo(logoutCallback: _logout, username: _username)),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage(updateLoginStatus: _updateLoginStatus)),
                );
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Menú Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Categorías'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoriasPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Preguntas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreguntasPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (_isLoggedIn) {
                  // Aquí puedes implementar alguna acción adicional al hacer clic en la imagen
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(updateLoginStatus: _updateLoginStatus)),
                  );
                }
              },
              child: Image.network(
                'https://qph.cf2.quoracdn.net/main-qimg-c9e1b85a396425f16c4c6e241861fa12-lq',
                loadingBuilder: (context, child, progress) {
                  if (progress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            if (_isLoggedIn && _username != null)
              Text(
                'Bienvenido, $_username',
                style: TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }
}
