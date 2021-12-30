import 'package:flutter/material.dart';

import 'view/animated_container_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material App Bar'),
      ),
      body: Column(
        children: [
          Flexible(
            child: Center(
                child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AnimatedContainersView(),
                        )),
                    child: Text("Animated Containers"))),
          ),
        ],
      ),
    );
  }
}
