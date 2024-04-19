class Question {
  final int id;
  final String question;
  final int categoryId;

  Question({
    required this.id,
    required this.question,
    required this.categoryId,
  });

factory Question.fromJson(Map <String,dynamic>json){
    return switch(json){
      {
        'id': int id,
        'question': String question,
        'categoryId': int categoryId
      }=>

      Question(
        id:id,
        question:question,
        categoryId:categoryId
      ), 
      _=> throw const FormatException('Falló al cargar el modelo'),
    };
  }
}
  