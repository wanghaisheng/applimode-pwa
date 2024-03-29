import 'package:applimode_app/src/common_widgets/animated_color_box.dart';
import 'package:applimode_app/src/common_widgets/title_text_widget.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post_and_writer.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasicBlockItem extends ConsumerWidget {
  const BasicBlockItem({
    super.key,
    this.aspectRatio,
    this.isPage = false,
    this.index,
    this.postId,
    this.postAndWriter,
  });

  final double? aspectRatio;
  final bool isPage;
  final int? index;
  final String? postId;
  final PostAndWriter? postAndWriter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final appUser =
        user != null ? ref.watch(appUserFutureProvider(user.uid)).value : null;
    final postTitleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontSize: basicPostsItemTitleFontsize,
        );
    final screenWidth = MediaQuery.sizeOf(context).width;

    return InkWell(
      onTap: (appUser != null &&
              appUser.isAdmin &&
              postId != null &&
              postAndWriter != null)
          ? () => context.push(
                ScreenPaths.post(postId!),
                extra: postAndWriter,
              )
          : null,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: aspectRatio ?? 1.0,
            child: AnimatedColorBox(
              index: index,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: SafeArea(
                  child: TitleTextWidget(
                    title: context.loc.blockedPost,
                    textStyle: postTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          if (!isPage && screenWidth <= pcWidthBreakpoint)
            const SizedBox(height: cardBottomPadding),
        ],
      ),
    );
  }
}
