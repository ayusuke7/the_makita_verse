import 'package:core/core.dart';

class CommentsEntity {
  final String avatar;
  final String name;
  final String content;

  CommentsEntity({
    required this.avatar,
    required this.name,
    required this.content,
  });

  CommentsModel toModel() {
    return CommentsModel(
      avatar: avatar,
      name: name,
      content: content,
    );
  }
}
