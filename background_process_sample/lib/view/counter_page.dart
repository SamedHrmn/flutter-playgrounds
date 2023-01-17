import 'dart:developer';

import 'package:flutter/material.dart';

import '../util/background_service_helper.dart';
import '../util/notification_helper.dart';
import '../util/shared_prefs_util.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> with WidgetsBindingObserver {
  int _counter = 0;

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });

    await SharedPrefsUtil().setCounter(_counter);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    NotificationHelper.instance.cancelAllNotification();

    Future.microtask(() async {
      _counter = await SharedPrefsUtil().getCounter() ?? 0;
      setState(() {});
      final isDetached = await SharedPrefsUtil().getIsDetached();

      if (isDetached == true) {
        await SharedPrefsUtil().setIsDetached(false);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        log('INACTIVE');
        SharedPrefsUtil().setIsDetached(true);
        SharedPrefsUtil().setCounter(_counter).then(
              (_) => BackgroundServiceHelper.startService(_counter),
            );
        break;
      case AppLifecycleState.resumed:
        log('RESUME');
        SharedPrefsUtil().getCounter().then((value) {
          _counter = value ?? 0;
        });
        setState(() {});
        NotificationHelper.instance.cancelAllNotification();
        break;
      default:
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _titleText(),
            _counterText(),
          ],
        ),
      ),
      floatingActionButton: _incrementButton(),
    );
  }

  FloatingActionButton _incrementButton() {
    return FloatingActionButton(
      onPressed: () async => await _incrementCounter(),
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Counter Page'),
    );
  }

  Widget _counterText() {
    return FutureBuilder<int?>(
      future: SharedPrefsUtil().getCounter(),
      builder: (context, snapshot) {
        if (snapshot.data == null) return const SizedBox();

        return Text(
          snapshot.data!.toString(),
          style: Theme.of(context).textTheme.headline4,
        );
      },
    );
  }

  Text _titleText() {
    return const Text(
      'You have pushed the button this many times:',
    );
  }
}
