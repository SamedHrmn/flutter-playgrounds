import 'dart:async';

import 'package:textfield_searching/json_service.dart';

import 'user_model.dart';

enum UserState {
  INITIAL,
  LOADING,
  LOADED,
}

enum SearchState {
  INITIAL,
  LOADING,
  LOADED,
}

class UserViewModel {
  final IJsonService jsonService = JsonService();
  List<User?> users = [];
  List<User?> searchResult = [];

  StreamController<UserState> userController = StreamController.broadcast()..add(UserState.INITIAL);
  StreamController<SearchState> searchController = StreamController.broadcast()..add(SearchState.INITIAL);

  Future<void> getAllUser() async {
    users.clear();
    userController.add(UserState.LOADING);
    await Future.delayed(const Duration(seconds: 2));
    final userList = await jsonService.getAllUser();
    for (var i = 0; i < userList.length; i++) {
      users.add(User.fromJson(userList[i]));
    }

    userController.add(UserState.LOADED);
  }

  void searchOperation({required String searchText}) {
    searchController.add(SearchState.LOADING);

    searchResult.clear();
    for (var element in users) {
      final word = element?.username?.trim();
      if (word?.toLowerCase().contains(searchText.toLowerCase()) == true) {
        searchResult.add(element);
      }
    }

    searchController.add(SearchState.LOADED);
  }

  void dispose() {
    userController.close();
    searchController.close();
  }
}
