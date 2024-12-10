import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/main_posts_list.dart';
import 'package:flutter/material.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_app_bar/posts_app_bar.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/posts_drawer.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_floating_action_button/posts_floating_action_button.dart';

class MainPostsScreen extends StatelessWidget {
  const MainPostsScreen({
    super.key,
    this.type = PostsListType.square,
  });

  final PostsListType type;

  @override
  Widget build(BuildContext context) {
    final isPage = type == PostsListType.page;
    return Scaffold(
      appBar: isPage
          ? PostsAppBar(
              forceMaterialTransparency: true,
              foregroundColor: Colors.white,
              elevation: 0,
            )
          : null,
      body: MainPostsList(type: type),
      floatingActionButton: PostsFloatingActionButton(),
      drawer: PostsDrawer(),
      drawerEnableOpenDragGesture: false,
      extendBodyBehindAppBar: isPage ? true : false,
      backgroundColor: isPage ? Colors.black : null,
    );
  }
}
