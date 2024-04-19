class Comment {
  final int id;
  final int answerId;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    required this.id,
    required this.answerId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      answerId: json['answerId'] as int,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
