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
      id: json['id'] as int,
      questionId: json['question_id'] as int,
      answer: json['answer'] as String,
      createdAt: DateTime.parse(json['createdAt']), 
      updatedAt: DateTime.parse(json['updatedAt']), 
    );
  }
}