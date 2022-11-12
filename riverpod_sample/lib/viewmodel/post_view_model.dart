// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_sample/model/post_model.dart';
import 'package:riverpod_sample/service/posts_service.dart';

final postNotifier = ChangeNotifierProvider(
  (_) => PostViewModel(postService: PostService()),
);

enum PostStateEnum {
  none,
  loading,
  loaded,
  error,
}

class PostViewModel extends ChangeNotifier {
  final List<Post> _allPosts = [];
  late final IPostService postService;

  PostStateEnum postStateEnum = PostStateEnum.none;

  PostViewModel({
    required this.postService,
  });

  List<Post> get allPosts => List.unmodifiable(_allPosts);

  Future<void> getAllPosts() async {
    log('getAllPosts');
    _allPosts.clear();
    postStateEnum = PostStateEnum.loading;
    notifyListeners();

    try {
      final postResponse = await postService.getPosts();
      for (var value in postResponse) {
        final model = Post.fromJson(value as Map<String, dynamic>);
        _allPosts.add(model);
      }
    } catch (e) {
      postStateEnum = PostStateEnum.error;
      notifyListeners();
    }

    postStateEnum = PostStateEnum.loaded;
    notifyListeners();
  }

  Future<void> fakeReq() async {
    await Future.delayed(Duration(seconds: 1));
    log('fakeReq');
    notifyListeners();
  }
}
