import 'package:flutter/material.dart';

class PaginatedListView<T> extends StatefulWidget {
  const PaginatedListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
  });

  final Widget Function(BuildContext context, T item) itemBuilder;
  final PaginationController<T> controller;

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    widget.controller.loadNextPage();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 64) {
      if (widget.controller.state.isLoading ||
          widget.controller.state.hasError) {
        return;
      }
      widget.controller.loadNextPage();
    }
  }

  Widget _buildItem(int index, PaginationState<T> state) {
    if (index >= state.items.length) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      return const SizedBox.shrink();
    }
    return widget.itemBuilder(context, state.items[index]);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final state = widget.controller.state;
        if (state.hasError && state.items.isEmpty) {
          return Center(
            child: Text('An error occured'),
          );
        }

        if (state.items.isEmpty && !state.isLoading) {
          return const Center(child: Text('No items found'));
        }

        return Stack(
          children: [
            AnimatedOpacity(
              duration: Durations.medium1,
              opacity: state.isLoading ? 0.3 : 1,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.items.length,
                itemBuilder: (context, index) => _buildItem(index, state),
              ),
            ),
            if (state.isLoading) ...{
              Center(
                child: CircularProgressIndicator(),
              ),
            },
          ],
        );
      },
    );
  }
}

class PaginationController<T> extends ChangeNotifier {
  PaginationController({required this.fetchItems})
      : _state = PaginationState<T>();

  final Future<List<T>?> Function(int page) fetchItems;

  PaginationState<T> _state;
  PaginationState<T> get state => _state;

  Future<void> loadNextPage() async {
    if (_state.isLoading) return;

    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final newItems = await fetchItems(_state.currentPage);

      // If newItems is null, treat it as an empty list
      final items = newItems ?? [];

      _state = _state.copyWith(
        items: [..._state.items, ...items],
        currentPage: _state.currentPage + 1,
        isLoading: false,
        hasError: false,
        errorMessage: null,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }
}

class PaginationState<T> {
  final List<T> items;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final int currentPage;

  const PaginationState({
    this.items = const [],
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.currentPage = 1,
  });

  PaginationState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    int? currentPage,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
