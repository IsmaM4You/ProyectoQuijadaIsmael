import 'package:flutter/material.dart';
import 'Usuarios.dart';
import 'Preguntas.dart';
import 'Respuestas.dart';
import 'Comentarios.dart';
import 'Categorias.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Usuarios'),
              onTap: () {
                Navigator.pushNamed(context, '/usuarios');
              },
            ),
            ListTile(
              title: Text('Categorías'),
              onTap: () {
                Navigator.pushNamed(context, '/categorias');
              },
            ),
            ListTile(
              title: Text('Respuestas'),
              onTap: () {
                Navigator.pushNamed(context, '/respuestas');
              },
            ),
            ListTile(
              title: Text('Preguntas'),
              onTap: () {
                Navigator.pushNamed(context, '/preguntas');
              },
            ),
            ListTile(
              title: Text('Comentarios'),
              onTap: () {
                Navigator.pushNamed(context, '/comentarios');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            String itemName = '';
            switch (index) {
              case 0:
                itemName = 'Usuarios';
                break;
              case 1:
                itemName = 'Categorías';
                break;
              case 2:
                itemName = 'Respuestas';
                break;
              case 3:
                itemName = 'Preguntas';
                break;
              case 4:
                itemName = 'Comentarios';
                break;
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      switch (index) {
                        case 0:
                          return UsuariosPage();
                        case 1:
                          return CategoriasPage();
                        case 2:
                          return RespuestasPage();
                        case 3:
                          return PreguntasPage();
                        case 4:
                          return ComentariosPage();
                        default:
                          throw Exception('Página no encontrada');
                      }
                    },
                  ),
                );
              },
              child: Container(
                height: 50,
                color: Colors.red,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Center(
                  child: Text(
                    itemName,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
