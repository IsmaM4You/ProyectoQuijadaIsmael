import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreguntasItem extends StatefulWidget {
  final int categoriaId;

  const PreguntasItem({required this.categoriaId});

  @override
  _PreguntasItemState createState() => _PreguntasItemState();
}

class _PreguntasItemState extends State<PreguntasItem> {
  late List<dynamic> preguntas = [];
  late Map<int, List<dynamic>> respuestas = {};
  late TextEditingController _textEditingController = TextEditingController();
  late TextEditingController _nuevaPreguntaController = TextEditingController();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _fetchPreguntas();
    _loadLoginStatus();
  }

  Future<void> _loadLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _fetchPreguntas() async {
    final response = await http.get(Uri.parse('https://quijada.terrabyteco.com/api/questions/${widget.categoriaId}'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        preguntas = responseData;
      });
    } else {
      throw Exception('Failed to load preguntas');
    }
  }

Future<void> _crearPregunta(String nuevaPregunta) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  if (!isLoggedIn) {
    _checkLoggedIn(context, null);
  } else {
    final response = await http.post(
      Uri.parse('https://quijada.terrabyteco.com/api/questions'),
      body: jsonEncode({
        'category_id': widget.categoriaId,
        'question': nuevaPregunta,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      await _fetchPreguntas();
    } else {
      throw Exception('Failed to create pregunta');
    }
  }
}


Future<void> _crearRespuesta(int preguntaId, String nuevaRespuesta) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  if (!isLoggedIn) {
    _checkLoggedIn(context, preguntaId);
  } else {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Respuesta'),
          content: Text(nuevaRespuesta),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _mostrarDialogoAgregarRespuesta(preguntaId, nuevaRespuesta);
              },
              child: const Text('Editar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo sin hacer nada
              },
              child: const Text('Eliminar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final response = await http.post(
                  Uri.parse('https://quijada.terrabyteco.com/api/answers'),
                  body: jsonEncode({
                    'question_id': preguntaId,
                    'answer': nuevaRespuesta,
                  }),
                  headers: {'Content-Type': 'application/json'},
                );

                if (response.statusCode == 201) {
                  await _fetchRespuestas(preguntaId);
                } else {
                  throw Exception('Failed to create respuesta');
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preguntas de la categoría ${widget.categoriaId}'),
      ),
      body: preguntas.isNotEmpty
          ? ListView.builder(
              itemCount: preguntas.length,
              itemBuilder: (context, index) {
                final pregunta = preguntas[index];
                final preguntaId = pregunta['id'];
                final respuestasExisten = respuestas.containsKey(preguntaId);
                final respuestasMostrar = respuestasExisten ? respuestas[preguntaId] : [];

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
                    if (respuestasMostrar != null && respuestasMostrar.isNotEmpty)
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _checkLoggedIn(context, preguntaId);
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Agregar nueva pregunta'),
                content: TextFormField(
                  controller: _nuevaPreguntaController,
                  decoration: const InputDecoration(labelText: 'Nueva pregunta'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una pregunta';
                    }
                    return null;
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final nuevaPregunta = _nuevaPreguntaController.text;
                      await _crearPregunta(nuevaPregunta);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _nuevaPreguntaController.dispose();
    super.dispose();
  }

  Future<void> _fetchRespuestas(int preguntaId) async {
    final response = await http.get(Uri.parse('https://quijada.terrabyteco.com/api/answers/question/$preguntaId'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        respuestas[preguntaId] = responseData;
      });
    } else {
      throw Exception('Failed to load respuestas');
    }
  }

Future<void> _checkLoggedIn(BuildContext context, preguntaId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  if (!_isLoggedIn) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Iniciar sesión'),
          content: const Text('Debes iniciar sesión para responder la pregunta o agregar una nueva.'),
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
    if (preguntaId != null) {
      _mostrarDialogoAgregarRespuesta(preguntaId, "");
    } else {
      _mostrarDialogoAgregarPregunta();
    }
  }
}

Future<void> _mostrarDialogoAgregarPregunta() async {
  TextEditingController controller = TextEditingController();
  showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Agregar nueva pregunta'),
        content: TextFormField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nueva pregunta'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa una pregunta';
            }
            return null;
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final nuevaPregunta = controller.text;
              await _crearPregunta(nuevaPregunta);
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}

Future<void> _mostrarDialogoAgregarRespuesta(int preguntaId, String respuesta) async {
  TextEditingController controller = TextEditingController(text: respuesta);
  showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Agregar nueva respuesta'),
        content: TextFormField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Respuesta'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa una respuesta';
            }
            return null;
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final respuestaText = controller.text;
              Navigator.of(context).pop(); // Cerrar el diálogo de agregar respuesta
              _crearRespuesta(preguntaId, respuestaText);
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
}