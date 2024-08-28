import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_floating_action_button/posts_fabs.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/main_posts_list.dart';
import 'package:applimode_app/custom_settings.dart';
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
    switch (type) {
      case PostsListType.small:
        return const Scaffold(
          appBar: PostsAppBar(),
          body: MainPostsList(type: PostsListType.small),
          floatingActionButton: PostsFloatingActionButton(),
          drawer: PostsDrawer(),
          drawerEnableOpenDragGesture: false,
        );
      case PostsListType.square:
        return const Scaffold(
          appBar: PostsAppBar(),
          body: MainPostsList(
            type: PostsListType.square,
          ),
          floatingActionButton:
              useDirectUploadButton ? PostsFabs() : PostsFloatingActionButton(),
          drawer: PostsDrawer(),
          drawerEnableOpenDragGesture: false,
        );
      case PostsListType.page:
        return const Scaffold(
          backgroundColor: Colors.black,
          appBar: PostsAppBar(
            forceMaterialTransparency: true,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: MainPostsList(
            type: PostsListType.page,
          ),
          floatingActionButton:
              useDirectUploadButton ? PostsFabs() : PostsFloatingActionButton(),
          drawer: PostsDrawer(),
          drawerEnableOpenDragGesture: false,
          extendBodyBehindAppBar: true,
        );
      case PostsListType.round:
        return const Scaffold(
          appBar: PostsAppBar(),
          body: MainPostsList(
            type: PostsListType.round,
          ),
          floatingActionButton:
              useDirectUploadButton ? PostsFabs() : PostsFloatingActionButton(),
          drawer: PostsDrawer(),
          drawerEnableOpenDragGesture: false,
        );
      case PostsListType.mixed:
        return const Scaffold(
          appBar: PostsAppBar(),
          body: MainPostsList(
            type: PostsListType.mixed,
          ),
          floatingActionButton:
              useDirectUploadButton ? PostsFabs() : PostsFloatingActionButton(),
          drawer: PostsDrawer(),
          drawerEnableOpenDragGesture: false,
        );
    }
  }
}
