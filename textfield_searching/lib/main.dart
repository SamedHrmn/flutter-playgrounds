import 'package:flutter/material.dart';
import 'package:textfield_searching/user_viewmodel.dart';

import 'user_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final UserViewModel userViewModel;
  bool _isSearching = false;
  final String _appBarText = "Search Sample";

  late final TextEditingController _editingController;

  @override
  void initState() {
    _editingController = TextEditingController();
    userViewModel = UserViewModel();
    Future.microtask(() async => userViewModel.getAllUser());

    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    userViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching ? null : Text(_appBarText),
          bottom: _isSearching ? _appBar() : null,
          actions: [
            _searchButton(),
          ],
        ),
        body: _isSearching ? _filteredUsersList() : _usersList(),
      ),
    );
  }

  IconButton _searchButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSearching = true;
        });
      },
      icon: const Icon(Icons.search),
    );
  }

  AppBar _appBar() {
    return AppBar(
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 20),
        child: TextField(
          controller: _editingController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 24),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                _isSearching = false;
              });
            } else {
              setState(() {
                _isSearching = true;
              });
            }
            userViewModel.searchOperation(searchText: value);
          },
        ),
      ),
    );
  }

  StreamBuilder<UserState> _usersList() {
    return StreamBuilder<UserState>(
      stream: userViewModel.userController.stream,
      builder: (context, snapshot) {
        if (snapshot.data == UserState.LOADING) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            itemBuilder: (context, index) {
              return UserCard(user: userViewModel.users[index]);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemCount: userViewModel.users.length);
      },
    );
  }

  StreamBuilder<SearchState> _filteredUsersList() {
    return StreamBuilder<SearchState>(
      stream: userViewModel.searchController.stream,
      builder: (context, snapshot) {
        if (snapshot.data == SearchState.LOADING) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            itemBuilder: (context, index) {
              return UserCard(user: userViewModel.searchResult[index]);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemCount: userViewModel.searchResult.length);
      },
    );
  }
}
