import 'package:flutter/material.dart';

class Answer {
  final int id;
  final int questionId;
  final String answer;
  final DateTime createdAt;
  final DateTime updatedAt;

  Answer({
    required this.id,
    required this.questionId,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      questionId: json['question_id'],
      answer: json['answer'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class RespuestaPregunta extends StatefulWidget {
  final dynamic pregunta;

  RespuestaPregunta({required this.pregunta});

  @override
  _RespuestaPreguntaState createState() => _RespuestaPreguntaState();
}

class _RespuestaPreguntaState extends State<RespuestaPregunta> {
  TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responder Pregunta'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.pregunta['question'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _answerController,
              decoration: InputDecoration(
                hintText: 'Escribe tu respuesta',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Lógica para enviar la respuesta al servidor
              String answer = _answerController.text;
              // ...
            },
            child: Text('Enviar Respuesta'),
          ),
        ],
      ),
    );
  }
}