import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreguntasPage extends StatefulWidget {
  @override
  _PreguntasPageState createState() => _PreguntasPageState();
}

class _PreguntasPageState extends State<PreguntasPage> {
  late Future<List<dynamic>> futurePreguntas;
  Map<int, List<dynamic>> respuestas = {};

  @override
  void initState() {
    super.initState();
    futurePreguntas = fetchPreguntas();
  }

  Future<List<dynamic>> fetchPreguntas() async {
    try {
      final response =
          await http.get(Uri.parse('https://quijada.terrabyteco.com/api/questions/list'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load preguntas');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load preguntas');
    }
  }

  Future<void> _fetchRespuestas(int preguntaId) async {
    try {
      final response = await http.get(Uri.parse('https://quijada.terrabyteco.com/api/answers/question/$preguntaId'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          respuestas[preguntaId] = responseData;
        });
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load respuestas');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load respuestas');
    }
  }

  Future<void> _checkLoggedIn(BuildContext context, int preguntaId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Iniciar sesión'),
            content: const Text('Debes iniciar sesión para responder la pregunta.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      TextEditingController _respuestaController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Responder pregunta'),
            content: TextField(
              controller: _respuestaController,
              decoration: InputDecoration(
                hintText: 'Tu respuesta',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  String respuestaText = _respuestaController.text;
                  _enviarRespuesta(preguntaId, respuestaText);
                  Navigator.of(context).pop();
                },
                child: const Text('Enviar'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _enviarRespuesta(int preguntaId, String nuevaRespuesta) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    final response = await http.post(
      Uri.parse('https://quijada.terrabyteco.com/api/answers'),
      body: jsonEncode({
        'question_id': preguntaId,
        'username': username,
        'answer': nuevaRespuesta,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      await _fetchRespuestas(preguntaId);
    } else {
      throw Exception('Failed to create respuesta');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preguntas'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futurePreguntas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No se encontraron preguntas.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pregunta = snapshot.data![index];
                final preguntaId = pregunta['id'];
                final respuestasExisten = respuestas.containsKey(preguntaId);
                final respuestasMostrar = respuestasExisten ? respuestas[preguntaId]! : [];

                return Column(
                  children: [
                    ListTile(
                      title: Text(pregunta['question']),
                      onTap: () async {
                        if (!respuestasExisten) {
                          await _fetchRespuestas(preguntaId);
                        }
                      },
                    ),
                    if (respuestasMostrar.isNotEmpty)
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: respuestasMostrar.map<Widget>((respuesta) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Respuesta: ${respuesta['answer']}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _checkLoggedIn(context, preguntaId);
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
