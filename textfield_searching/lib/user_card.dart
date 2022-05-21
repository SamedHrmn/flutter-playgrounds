import 'dart:math';

import 'package:flutter/material.dart';

import 'user_model.dart';

class UserCard extends StatefulWidget {
  const UserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User? user;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  double _opacity = 0.0;
  final Duration _opacityDuration = const Duration(milliseconds: 1000);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: _opacityDuration,
      child: Card(
        elevation: 8,
        shadowColor: Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
        child: ListTile(
          leading: Text(widget.user?.username ?? "-"),
        ),
      ),
    );
  }
}
