import '../../domain/domain.dart';

class CommentsModel {
  final String avatar;
  final String name;
  final String content;

  CommentsModel({
    required this.avatar,
    required this.name,
    required this.content,
  });

  factory CommentsModel.fromJson(Map<String, dynamic> json) {
    return CommentsModel(
      avatar: json['avatar'],
      name: json['name'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
    'avatar': avatar,
    'name': name,
    'content': content,
  };

  CommentsEntity toEntity() {
    return CommentsEntity(avatar: avatar, name: name, content: content);
  }
}
