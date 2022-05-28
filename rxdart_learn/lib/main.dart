import 'package:flutter/material.dart';
import 'package:rxdart_learn/bloc/json_api.dart';
import 'package:rxdart_learn/bloc/search_bloc.dart';
import 'package:rxdart_learn/bloc/search_result.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final SearchBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = SearchBloc(jsonApi: JsonApi());
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RxDart Learn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              onChanged: bloc.search.add,
            ),
            Expanded(
                child: StreamBuilder<SearchResult?>(
              stream: bloc.results,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text("Waiting.."),
                  );
                }

                final state = snapshot.data;
                if (state is SearchResultLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchResultHasError) {
                  print(state.error);
                  return Center(
                    child: Text("Something went wrong !"),
                  );
                } else if (state is SearchResultNoResult) {
                  return Center(
                    child: Text("No result."),
                  );
                } else {
                  final item = snapshot.data as SearchResultWithResult;
                  return ListView.builder(
                    itemCount: item.result.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          trailing: Text(item.result[index].title),
                        ),
                      );
                    },
                  );
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
