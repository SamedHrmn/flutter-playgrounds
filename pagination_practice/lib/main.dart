import 'package:flutter/material.dart';
import 'package:pagination_practice/home_view_model.dart';
import 'package:pagination_practice/widget/paginated_list_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material App', home: const HomeView());
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final homeViewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination Controller Sample'),
      ),
      body: SafeArea(
        child: SizedBox(
          height: 500,
          child: PaginatedListView(
            controller: homeViewModel.productPController,
            itemBuilder: (context, item) {
              return Card(
                child: ListTile(
                  leading: Text(
                    item.id?.toString() ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  title: Text(item.price?.toString() ?? ''),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
