import 'dart:convert';
import 'dart:io';

abstract class IPostService {
  Future<List<dynamic>> getPosts();
}

class PostService extends IPostService {
  static PostService? _postService;

  factory PostService() => _postService ??= PostService._();

  PostService._();

  static const String postUrl = 'https://jsonplaceholder.typicode.com/posts';

  @override
  Future<List<dynamic>> getPosts() async {
    final request = await HttpClient().getUrl(Uri.parse(postUrl));
    final response = await request.close();
    final contentAsString = await utf8.decodeStream(response);
    return jsonDecode(contentAsString);
  }
}
