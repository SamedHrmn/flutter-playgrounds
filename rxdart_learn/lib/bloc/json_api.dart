import 'dart:convert';
import 'dart:io';

import 'package:rxdart_learn/model/album_model.dart';
import 'package:rxdart_learn/model/post_model.dart';

enum ApiUrl {
  album("albums"),
  post("posts");

  String toUrl() {
    return base + endPoint;
  }

  final String base = "https://jsonplaceholder.typicode.com/";
  final String endPoint;

  const ApiUrl(this.endPoint);
}

class JsonApi {
  JsonApi._();
  factory JsonApi() => JsonApi._();

  List<AlbumModel>? _albums;
  List<PostModel>? _posts;

  Future<List<SearchableBaseModel>> search(String title) async {
    final term = title.trim().toLowerCase();

    final cachedResult = _extractSearchableUsingTitle(term);
    if (cachedResult != null) {
      return cachedResult;
    }

    final albums = await _getJson(url: ApiUrl.album.toUrl());
    _albums = albums.map((e) => AlbumModel.fromJson(e)).toList();

    final posts = await _getJson(url: ApiUrl.post.toUrl());
    _posts = posts.map((e) => PostModel.fromJson(e)).toList();

    return _extractSearchableUsingTitle(term) ?? [];
  }

  List<SearchableBaseModel>? _extractSearchableUsingTitle(String title) {
    final cachedPosts = _posts;
    final cachedAlbums = _albums;

    if (cachedPosts != null && cachedAlbums != null) {
      List<SearchableBaseModel> results = [];

      for (var post in cachedPosts) {
        if (post.title.trim().contains(title)) {
          results.add(post);
        }
      }

      for (var album in cachedAlbums) {
        if (album.title.trim().contains(title)) {
          results.add(album);
        }
      }
      return results;
    }
    return null;
  }

  Future<List<dynamic>> _getJson({required String url}) async {
    return HttpClient()
        .getUrl(Uri.parse(url))
        .then((req) => req.close())
        .then((response) => response.transform(utf8.decoder).join())
        .then((jsonString) => json.decode(jsonString) as List<dynamic>);
  }
}
