import 'package:applimode_app/src/common_widgets/title_text_widget.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';

class SmallBlockItem extends StatelessWidget {
  const SmallBlockItem({
    super.key,
    this.showDivider = true,
    this.height,
    this.padding,
  });

  final bool showDivider;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: smallPostsItemTitleSize,
        );
    return Column(
      children: [
        SizedBox(
          height: height ?? listSmallItemHeight,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        padding ?? const EdgeInsets.symmetric(horizontal: 24),
                    child: TitleTextWidget(
                      title: context.loc.deletedPost,
                      textStyle: titleTextStyle,
                      maxLines: smallPostsItemTitleMaxLines,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: 0,
            thickness: 0,
            indent: 24,
            endIndent: 24,
          ),
      ],
    );
  }
}
