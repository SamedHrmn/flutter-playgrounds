import 'package:custom_widgets/listwheel_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeView());
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material App Bar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: Center(
            child: ElevatedButton(
              child: Text("ListWheel Picker"),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ListWheelView(),
              )),
            ),
          )),
        ],
      ),
    );
  }
}
