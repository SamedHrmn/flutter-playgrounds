import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart_learn/model/post_model.dart';

@immutable
class AlbumModel extends SearchableBaseModel {
  final int userId;
  final int id;
  final String title;

  const AlbumModel({required this.userId, required this.id, required this.title}) : super(id: id, title: title, userId: userId);

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      userId: json["userId"],
      id: json["id"],
      title: json["title"],
    );
  }
}
