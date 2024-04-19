import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RespuestasPage extends StatefulWidget {
  @override
  _RespuestasPageState createState() => _RespuestasPageState();
}

class _RespuestasPageState extends State<RespuestasPage> {
  late List<dynamic> respuestas = [];

  @override
  void initState() {
    super.initState();
    obtenerRespuestas();
  }

  Future<void> obtenerRespuestas() async {
    try {
      final response = await http.get(Uri.parse('https://quijada.terrabyteco.com/api/answers/question/3'));

      if (response.statusCode == 200) {
        setState(() {
          respuestas = jsonDecode(response.body);
        });
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Error al cargar las respuestas');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error al cargar las respuestas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Respuestas de la pregunta número 3'),
      ),
      body: respuestas.isNotEmpty
          ? ListView.builder(
              itemCount: respuestas.length,
              itemBuilder: (context, index) {
                final respuesta = respuestas[index];
                return ListTile(
                  title: Text(respuesta['answer']),
                  // Puedes mostrar más detalles de la respuesta si es necesario
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}