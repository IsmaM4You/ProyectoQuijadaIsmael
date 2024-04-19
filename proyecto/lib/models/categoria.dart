class Category {
  final int id;
  final String type;

  Category({
    required this.id,
    required this.type,
  });

factory Category.fromJson(Map <String,dynamic>json){
    return switch(json){
      {
        'id': int id,
        'type': String type,
      }=>

      Category(
        id:id,
        type:type,
      ), 
      _=> throw const FormatException('Falló al cargar el modelo'),
    };
  }
}
  