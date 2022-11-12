import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/viewmodel/post_view_model.dart';

class Home extends StatefulHookConsumerWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => Future.wait([
          ref.read(postNotifier).getAllPosts(),
          ref.read(postNotifier).fakeReq(),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        log('outer consumer');

        return Scaffold(
          appBar: AppBar(
            title: const Text('Material App Bar'),
          ),
          body: Consumer(builder: (context, ref, child) {
            final postState = ref.watch(postNotifier.select((value) => value.postStateEnum));
            log('postState consumer');

            if (postState == PostStateEnum.none) {
              return const SizedBox();
            } else if (postState == PostStateEnum.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (postState == PostStateEnum.loaded) {
              final posts = ref.watch(postNotifier.notifier).allPosts;
              log('posts consumer');
              return Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (context, index) => ListTile(
                      trailing: Text(posts[index].id?.toString() ?? '?'),
                      leading: Text(posts[index].id?.toString() ?? '?'),
                    ),
                  ))
                ],
              );
            }

            return const Center(
              child: Text('Error occured !'),
            );
          }),
        );
      },
    );
  }
}
