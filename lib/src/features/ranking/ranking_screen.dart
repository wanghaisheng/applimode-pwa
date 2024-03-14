import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';
import 'package:applimode_app/src/common_widgets/user_items/user_item.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/comments/data/post_comments_repository.dart';
import 'package:applimode_app/src/features/comments/domain/post_comment.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_item.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_posts_item.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/updated_comment_ids_list.dart';
import 'package:applimode_app/src/utils/updated_post_ids_list.dart';
import 'package:applimode_app/src/utils/updated_user_ids_list.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum RankFirstFilter {
  post,
  comment,
  user;
}

enum RankSecondFilter {
  likeCount,
  dislikeCount,
  sumCount,
}

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> {
  late RankFirstFilter firstFilter;
  late RankSecondFilter secondFilter;
  late int currentYear;
  late List<int> yearsList;
  int? yearFilter;
  int? monthFilter;
  int? dayFilter;
  late Query<dynamic>? query;

  final List<int> monthsList = List<int>.generate(12, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    firstFilter = RankFirstFilter.post;
    secondFilter = RankSecondFilter.likeCount;
    currentYear = int.tryParse(DateFormat('y').format(DateTime.now())) ??
        rankingCurrentYear;
    yearsList = [for (var i = currentYear; i >= currentYear - 4; i--) i];
  }

  ProviderListenable<int>? _buildListState() {
    switch (firstFilter) {
      case RankFirstFilter.post:
        return postsListStateProvider;
      case RankFirstFilter.comment:
        return commentsListStateProvider;
      case RankFirstFilter.user:
        return null;
    }
  }

  Query<dynamic> _buildUpdatedDocQuery() {
    switch (firstFilter) {
      case RankFirstFilter.post:
        return ref.watch(postsRepositoryProvider).postsRef();
      case RankFirstFilter.comment:
        return ref.watch(postCommentsRepositoryProvider).postCommentsRef();
      case RankFirstFilter.user:
        return ref.watch(appUserRepositoryProvider).usersRef();
    }
  }

  void Function() _buildResetUpdatedDocIds() {
    switch (firstFilter) {
      case RankFirstFilter.post:
        return ref.watch(updatedPostIdsListProvider.notifier).removeAll;
      case RankFirstFilter.comment:
        return ref.watch(updatedCommentIdsListProvider.notifier).removeAll;
      case RankFirstFilter.user:
        return ref.watch(updatedUserIdsListProvider.notifier).removeAll;
    }
  }

  ProviderListenable<List<String>> _buildUpdatedDocsState() {
    switch (firstFilter) {
      case RankFirstFilter.post:
        return updatedPostIdsListProvider;
      case RankFirstFilter.comment:
        return updatedCommentIdsListProvider;
      case RankFirstFilter.user:
        return updatedUserIdsListProvider;
    }
  }

  @override
  Widget build(BuildContext context) {
    // default post query
    final postQuery = ref.watch(postsRepositoryProvider).postsRef().orderBy(
          secondFilter.name,
          descending: true,
        );

    // default comment query
    final commentQuery =
        ref.watch(postCommentsRepositoryProvider).postCommentsRef().orderBy(
              secondFilter.name,
              descending: true,
            );

    // default user query
    final userQuery = ref.watch(appUserRepositoryProvider).usersRef().orderBy(
          secondFilter.name,
          descending: true,
        );

    // set query
    if (firstFilter == RankFirstFilter.post) {
      if (yearFilter == null) {
        query = postQuery;
      } else if (yearFilter != null &&
          monthFilter == null &&
          dayFilter == null) {
        query = postQuery.where('year', isEqualTo: yearFilter);
      } else if (yearFilter != null &&
          monthFilter != null &&
          dayFilter == null) {
        query = postQuery.where(
          'month',
          isEqualTo: Format.yearMonthToInt(DateTime(yearFilter!, monthFilter!)),
        );
      } else if (yearFilter != null &&
          monthFilter != null &&
          dayFilter != null) {
        query = postQuery.where('day',
            isEqualTo: Format.yearMonthDayToInt(
                DateTime(yearFilter!, monthFilter!, dayFilter!)));
      }
    } else if (firstFilter == RankFirstFilter.comment) {
      if (yearFilter == null) {
        query = commentQuery;
      } else if (yearFilter != null &&
          monthFilter == null &&
          dayFilter == null) {
        query = commentQuery.where('year', isEqualTo: yearFilter);
      } else if (yearFilter != null &&
          monthFilter != null &&
          dayFilter == null) {
        query = commentQuery.where(
          'month',
          isEqualTo: Format.yearMonthToInt(DateTime(yearFilter!, monthFilter!)),
        );
      } else if (yearFilter != null &&
          monthFilter != null &&
          dayFilter != null) {
        query = commentQuery.where('day',
            isEqualTo: Format.yearMonthDayToInt(
                DateTime(yearFilter!, monthFilter!, dayFilter!)));
      }
    } else {
      query = userQuery;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.ranking),
        automaticallyImplyLeading: kIsWeb ? false : true,
        leading: kIsWeb ? const WebBackButton() : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // first filter
                  Expanded(
                    flex: 1,
                    child: MenuAnchor(
                      builder: (context, controller, child) {
                        return RankingMenuAnchorButton(
                          controller: controller,
                          label: getFirstLabel(firstFilter),
                          buttonBackgroundColor: const Color(0xFF187B30),
                        );
                      },
                      menuChildren: [
                        ...RankFirstFilter.values.map(
                          (item) => MenuItemButton(
                            onPressed: () {
                              firstFilter = item;
                              if (item == RankFirstFilter.user) {
                                yearFilter = null;
                                monthFilter = null;
                                dayFilter = null;
                              }
                              setState(() {});
                            },
                            child: Text(getFirstLabel(item)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // second filter
                  Expanded(
                    flex: 1,
                    child: MenuAnchor(
                      builder: (context, controller, child) {
                        return RankingMenuAnchorButton(
                          controller: controller,
                          label: getSecondLabel(secondFilter),
                          buttonBackgroundColor: const Color(0xFFFF6F68),
                        );
                      },
                      menuChildren: [
                        if (showLikeCount)
                          MenuItemButton(
                            onPressed: () {
                              secondFilter = RankSecondFilter.likeCount;
                              setState(() {});
                            },
                            child: Text(
                                getSecondLabel(RankSecondFilter.likeCount)),
                          ),
                        if (showDislikeCount)
                          MenuItemButton(
                            onPressed: () {
                              secondFilter = RankSecondFilter.dislikeCount;
                              setState(() {});
                            },
                            child: Text(
                                getSecondLabel(RankSecondFilter.dislikeCount)),
                          ),
                        if (showSumCount)
                          MenuItemButton(
                            onPressed: () {
                              secondFilter = RankSecondFilter.sumCount;
                              setState(() {});
                            },
                            child:
                                Text(getSecondLabel(RankSecondFilter.sumCount)),
                          ),
                        /*
                        ...RankSecondFilter.values.map(
                          (item) => MenuItemButton(
                            onPressed: () {
                              secondFilter = item;
                              setState(() {});
                            },
                            child: Text(getSecondLabel(item)),
                          ),
                        ),
                        */
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // year
                  Expanded(
                    flex: 1,
                    child: MenuAnchor(
                      builder: (context, controller, child) {
                        return RankingMenuAnchorButton(
                          controller: controller,
                          label: yearFilter?.toString() ?? context.loc.allTime,
                          disable: firstFilter == RankFirstFilter.user,
                          buttonBackgroundColor: const Color(0xFF2D8498),
                        );
                      },
                      menuChildren: [
                        MenuItemButton(
                          onPressed: () {
                            yearFilter = null;
                            monthFilter = null;
                            dayFilter = null;
                            setState(() {});
                          },
                          child: Text(context.loc.allTime),
                        ),
                        ...yearsList.map(
                          (year) => MenuItemButton(
                            onPressed: () {
                              yearFilter = year;
                              setState(() {});
                            },
                            child: Text(year.toString()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // month
                  Expanded(
                    flex: 1,
                    child: MenuAnchor(
                      builder: (context, controller, child) {
                        return RankingMenuAnchorButton(
                          controller: controller,
                          label: monthFilter != null
                              ? Format.getMonthLabel(context, monthFilter)
                              : context.loc.allMonths,
                          disable: firstFilter == RankFirstFilter.user ||
                              yearFilter == null,
                          buttonBackgroundColor: const Color(0xFF00C6C7),
                        );
                      },
                      menuChildren: [
                        MenuItemButton(
                          onPressed: () {
                            monthFilter = null;
                            dayFilter = null;
                            setState(() {});
                          },
                          child: Text(context.loc.allMonths),
                        ),
                        ...monthsList.map(
                          (month) => MenuItemButton(
                            onPressed: () {
                              monthFilter = month;
                              setState(() {});
                            },
                            child: Text(Format.getMonthLabel(context, month)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // day
                  Expanded(
                    flex: 1,
                    child: MenuAnchor(
                      builder: (context, controller, child) {
                        return RankingMenuAnchorButton(
                          controller: controller,
                          label: dayFilter != null
                              ? Format.getDayLabel(
                                  context,
                                  yearFilter ?? 2023,
                                  monthFilter ?? 1,
                                  dayFilter,
                                )
                              : context.loc.allDays,
                          disable: firstFilter == RankFirstFilter.user ||
                              yearFilter == null ||
                              monthFilter == null,
                          buttonBackgroundColor: const Color(0xFFB57E79),
                        );
                      },
                      menuChildren: [
                        MenuItemButton(
                          onPressed: () {
                            dayFilter = null;
                            setState(() {});
                          },
                          child: Text(context.loc.allDays),
                        ),
                        if (yearFilter != null && monthFilter != null)
                          ...Format.getDaysList(yearFilter!, monthFilter!).map(
                            (day) => MenuItemButton(
                              onPressed: () {
                                dayFilter = day;
                                setState(() {});
                              },
                              child: Text(
                                Format.getDayLabel(
                                  context,
                                  yearFilter!,
                                  monthFilter!,
                                  day,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SimplePageListView(
              query: query ?? postQuery,
              shrinkWrap: true,
              useDidUpdateWidget: true,
              listState: _buildListState(),
              refreshUpdatedDocs: true,
              updatedDocQuery: _buildUpdatedDocQuery(),
              resetUpdatedDocIds: _buildResetUpdatedDocIds(),
              updatedDocsState: _buildUpdatedDocsState(),
              useUid: firstFilter == RankFirstFilter.user ? true : false,
              itemBuilder: (context, index, doc) {
                final item = doc.data();
                if (item is Post) {
                  return SmallPostsItem(
                    post: item,
                    index: index,
                    isRankingPage: true,
                    isLikeRanking: secondFilter == RankSecondFilter.likeCount,
                    isDislikeRanking:
                        secondFilter == RankSecondFilter.dislikeCount,
                    isSumRanking: secondFilter == RankSecondFilter.sumCount,
                  );
                }
                if (item is PostComment) {
                  return PostCommentsItem(
                    comment: item,
                    isRanking: true,
                  );
                }
                if (item is AppUser) {
                  return UserItem(
                    appUser: item,
                    index: index,
                    isRanking: true,
                    profileImageSize: profileSizeBigger,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  String getFirstLabel(RankFirstFilter filter) {
    switch (filter) {
      case RankFirstFilter.post:
        return context.loc.rankPost;
      case RankFirstFilter.comment:
        return context.loc.rankComment;
      case RankFirstFilter.user:
        return context.loc.rankUser;
    }
  }

  String getSecondLabel(RankSecondFilter filter) {
    switch (filter) {
      case RankSecondFilter.likeCount:
        return context.loc.rankLike;
      case RankSecondFilter.dislikeCount:
        return context.loc.rankDislike;
      case RankSecondFilter.sumCount:
        return context.loc.rankSum;
    }
  }
}

class RankingMenuAnchorButton extends StatelessWidget {
  const RankingMenuAnchorButton({
    super.key,
    required this.controller,
    required this.label,
    this.disable = false,
    this.buttonBackgroundColor,
  });

  final MenuController controller;
  final String label;
  final bool disable;
  final Color? buttonBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: disable
          ? null
          : () async {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
      style: ButtonStyle(
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 0,
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return Theme.of(context).colorScheme.onSurface.withOpacity(0.12);
            } else {
              return buttonBackgroundColor;
            }
          }),
          foregroundColor: const MaterialStatePropertyAll(Colors.white)),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
