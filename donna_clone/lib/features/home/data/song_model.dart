class SongModel {
  final String? id;
  final String? imageUrl;
  final String? title;
  final String? author;
  final num? count;
  final num? likes;

  SongModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.count,
    required this.likes,
  });

  factory SongModel.fromMap(Map<String, dynamic> json) {
    return SongModel(
      id: json["id"],
      imageUrl: json["imageUrl"],
      title: json["title"],
      author: json["author"],
      count: json["count"] as int?,
      likes: json["likes"] as int?,
    );
  }
}
