class CommentsEntity {
  final String avatar;
  final String name;
  final String content;

  CommentsEntity({
    required this.avatar,
    required this.name,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
    'avatar': avatar,
    'name': name,
    'content': content,
  };
}
