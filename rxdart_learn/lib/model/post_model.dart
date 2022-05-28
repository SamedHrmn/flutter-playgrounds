import 'package:flutter/foundation.dart' show immutable;

@immutable
class PostModel extends SearchableBaseModel {
  final int userId;
  final int id;
  final String title;
  final String body;

  const PostModel({required this.userId, required this.id, required this.title, required this.body}) : super(id: id, title: title, userId: userId);

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(userId: json["userId"], id: json["id"], title: json["title"], body: json["body"]);
  }
}

abstract class SearchableBaseModel {
  final int userId;
  final int id;
  final String title;

  const SearchableBaseModel({required this.userId, required this.id, required this.title});
}
