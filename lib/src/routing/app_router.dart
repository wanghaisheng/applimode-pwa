import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/app_settings/app_settings_controller.dart';
import 'package:applimode_app/src/common_widgets/error_widgets/error_scaffold.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/full_image_screen.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/admin_settings/presentation/admin_settings_screen.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_phone_screen.dart';
import 'package:applimode_app/src/features/like_users/like_users_screen.dart';
import 'package:applimode_app/src/features/policies/app_privacy_screen.dart';
import 'package:applimode_app/src/features/policies/app_terms_screen.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/presentation/main_posts_screen.dart';
import 'package:applimode_app/src/features/posts/presentation/search_screen.dart';
import 'package:applimode_app/src/features/posts/presentation/sub_posts_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/change_email_screen/change_email_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/change_password_screen/change_password_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/edit_bio_screen/edit_bio_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/edit_username_screen/edit_username_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_comments_screen/profile_comments_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_likes_screen/profile_likes_screen.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_posts_screen/profile_posts_screen.dart';
import 'package:applimode_app/src/features/ranking/ranking_screen.dart';
import 'package:applimode_app/src/features/video_player/full_video_screen.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/build_slide_transition.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:applimode_app/src/utils/multi_images.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/presentation/app_user_check_screen.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_sign_in_screen.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_screen.dart';
import 'package:applimode_app/src/features/editor/presentation/editor_screen.dart';
import 'package:applimode_app/src/features/post/presentation/post_screen.dart';
import 'package:applimode_app/src/features/posts/domain/post_and_writer.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_screen.dart';
import 'package:applimode_app/src/routing/go_router_refresh_stream.dart';
import 'package:video_player/video_player.dart';

part 'app_router.g.dart';

class ScreenPaths {
  static String home = '/';
  static String firebaseSignIn = '/firebaseSignIn';
  static String phone = '/phone';
  static String appUserCheck = '/appUserCheck';
  static String write = '/write';
  static String search = '/search';
  static String adminSettings = '/adminSettings';
  static String recommendedPosts = '/recommendedPosts';
  static String ranking = '/ranking';
  static String post(String postId) => '/post/$postId';
  static String edit(String postId) => '/post/$postId/edit';
  static String comments(String postId) => '/post/$postId/comments';
  static String postLikes(String postId) => '/post/$postId/likes';
  static String postDislikes(String postId) => '/post/$postId/dislikes';
  static String replies(String postId, String commentId) =>
      '/post/$postId/comments/$commentId';
  static String account(String uid) => '/account/$uid';
  static String editUsername(String uid, String username) =>
      '/account/$uid/editUsername/$username';
  static String editBio(String uid, String bio) => '/account/$uid/editBio/$bio';
  static String changeEmail(String uid, String email) =>
      '/account/$uid/changeEmail/$email';
  static String changePassword(String uid) => '/account/$uid/changePassword';
  static String profile(String uid) => '/profile/$uid';
  static String userPosts(String uid) => '/$uid/posts';
  static String userComments(String uid) => '/$uid/comments';
  static String userLikes(String uid) => '/$uid/likes';
  static String commentLikes(String commentId) => '/comment/$commentId/likes';
  static String commentDislikes(String commentId) =>
      '/comment/$commentId/dislikes';
  static String image(String imageUrl) => '/image?imageUrl=$imageUrl';
  static String video(String videoUrl) => '/video?videoUrl=$videoUrl';
  static String appInfo = '/appInfo';
  static String appPrivacy = '/privacy';
  static String appTerms = '/terms';
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final adminSettings = ref.watch(adminSettingsProvider);
  final categories = adminSettings.mainCategory;
  final showAppStyleOption = adminSettings.showAppStyleOption;
  final postsListType = adminSettings.postsListType;
  final appSettings = ref.watch(appSettingsControllerProvider);
  final postsRepository = ref.watch(postsRepositoryProvider);

  // for ios web need to remove transition
  final isIosWeb = kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  final isAndOrWin = defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.windows;

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    redirect: (context, state) async {
      final user = authRepository.currentUser;
      final isLoggedIn = user != null;
      final path = state.uri.path;
      if (isLoggedIn) {
        if (path == ScreenPaths.firebaseSignIn) {
          return ScreenPaths.home;
        }
      }
      if (!isLoggedIn) {
        if (path == ScreenPaths.write) {
          return ScreenPaths.firebaseSignIn;
        }
        if (isInitialSignIn && path.startsWith('/')) {
          return ScreenPaths.firebaseSignIn;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MainPostsScreen(
          type: showAppStyleOption
              ? PostsListType.values[appSettings.appStyle ?? 1]
              : postsListType,
        ),
      ),
      GoRoute(
          path: ScreenPaths.firebaseSignIn,
          pageBuilder: (context, state) {
            if (isIosWeb) {
              return const NoTransitionPage(
                child: FirebaseSignInScreen(),
              );
            }
            if (isAndOrWin) {
              return const CustomTransitionPage(
                fullscreenDialog: true,
                transitionsBuilder: buildVerticalSlideTransitiron,
                child: FirebaseSignInScreen(),
              );
            }
            return const CupertinoPage(
              child: FirebaseSignInScreen(),
            );
          }),
      GoRoute(
          path: ScreenPaths.phone,
          pageBuilder: (context, state) {
            if (isIosWeb) {
              return const NoTransitionPage(
                child: FirebasePhoneScreen(),
              );
            }
            if (isAndOrWin) {
              return const CustomTransitionPage(
                // fullscreenDialog: true,
                transitionsBuilder: buildVerticalSlideTransitiron,
                child: FirebasePhoneScreen(),
              );
            }
            return const CupertinoPage(
              child: FirebasePhoneScreen(),
            );
          }),
      GoRoute(
          path: ScreenPaths.appUserCheck,
          pageBuilder: (context, state) {
            if (isIosWeb) {
              return const NoTransitionPage(
                child: AppUserCheckScreen(),
              );
            }
            if (isAndOrWin) {
              return const CustomTransitionPage(
                fullscreenDialog: true,
                transitionsBuilder: buildVerticalSlideTransitiron,
                child: AppUserCheckScreen(),
              );
            }
            return const CupertinoPage(
              fullscreenDialog: true,
              child: AppUserCheckScreen(),
            );
          }),
      GoRoute(
          path: ScreenPaths.write,
          pageBuilder: (context, state) {
            if (isIosWeb) {
              return const NoTransitionPage(
                child: EditorScreen(),
              );
            }
            if (isAndOrWin) {
              return const CustomTransitionPage(
                fullscreenDialog: true,
                transitionsBuilder: buildVerticalSlideTransitiron,
                child: EditorScreen(),
              );
            }
            return const CupertinoPage(
              child: EditorScreen(),
            );
          }),
      GoRoute(
          path: ScreenPaths.search,
          pageBuilder: (context, state) {
            final preSearchWord = state.extra as String?;
            if (isIosWeb) {
              return NoTransitionPage(
                child: SearchScreen(
                  preSearchWord: preSearchWord,
                ),
              );
            }
            if (isAndOrWin) {
              return CustomTransitionPage(
                transitionsBuilder: buildHorizontalSlideTransitiron,
                child: SearchScreen(
                  preSearchWord: preSearchWord,
                ),
              );
            }
            return CupertinoPage(
              child: SearchScreen(
                preSearchWord: preSearchWord,
              ),
            );
          }),
      GoRoute(
          path: ScreenPaths.adminSettings,
          pageBuilder: (context, state) {
            if (isIosWeb) {
              return const NoTransitionPage(
                child: AdminSettingsScreen(),
              );
            }
            if (isAndOrWin) {
              return const CustomTransitionPage(
                transitionsBuilder: buildHorizontalSlideTransitiron,
                child: AdminSettingsScreen(),
              );
            }
            return const CupertinoPage(
              child: AdminSettingsScreen(),
            );
          }),
      GoRoute(
          path: ScreenPaths.recommendedPosts,
          pageBuilder: (context, state) {
            if (isIosWeb) {
              return NoTransitionPage(
                child: SubPostsScreen(
                  appBarTitle: context.loc.recommendedPosts,
                  query: postsRepository.recommendedPostsQuery(),
                  type: showAppStyleOption
                      ? PostsListType.values[appSettings.appStyle ?? 1]
                      : postsListType,
                ),
              );
            }
            if (isAndOrWin) {
              return CustomTransitionPage(
                transitionsBuilder: buildHorizontalSlideTransitiron,
                child: SubPostsScreen(
                  appBarTitle: context.loc.recommendedPosts,
                  query: postsRepository.recommendedPostsQuery(),
                  type: showAppStyleOption
                      ? PostsListType.values[appSettings.appStyle ?? 1]
                      : postsListType,
                ),
              );
            }
            return CupertinoPage(
              child: SubPostsScreen(
                appBarTitle: context.loc.recommendedPosts,
                query: postsRepository.recommendedPostsQuery(),
                type: showAppStyleOption
                    ? PostsListType.values[appSettings.appStyle ?? 1]
                    : postsListType,
              ),
            );
          }),
      GoRoute(
          path: ScreenPaths.ranking,
          pageBuilder: (context, state) {
            if (isIosWeb) {
              return const NoTransitionPage(
                child: RankingScreen(),
              );
            }
            if (isAndOrWin) {
              return const CustomTransitionPage(
                transitionsBuilder: buildHorizontalSlideTransitiron,
                child: RankingScreen(),
              );
            }
            return const CupertinoPage(
              child: RankingScreen(),
            );
          }),
      ...categories.map(
        (category) => GoRoute(
          path: category.path,
          pageBuilder: (context, state) {
            if (isIosWeb) {
              return NoTransitionPage(
                child: SubPostsScreen(
                  query: postsRepository.categoryPostsQuery(category.index),
                  appBarTitle: category.title,
                  type: showAppStyleOption
                      ? PostsListType.values[appSettings.appStyle ?? 1]
                      : postsListType,
                ),
              );
            }
            if (isAndOrWin) {
              return CustomTransitionPage(
                transitionsBuilder: buildHorizontalSlideTransitiron,
                child: SubPostsScreen(
                  query: postsRepository.categoryPostsQuery(category.index),
                  appBarTitle: category.title,
                  type: showAppStyleOption
                      ? PostsListType.values[appSettings.appStyle ?? 1]
                      : postsListType,
                ),
              );
            }
            return CupertinoPage(
              child: SubPostsScreen(
                query: postsRepository.categoryPostsQuery(category.index),
                appBarTitle: category.title,
                type: showAppStyleOption
                    ? PostsListType.values[appSettings.appStyle ?? 1]
                    : postsListType,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: '/post/:id',
        pageBuilder: (context, state) {
          final postId = state.pathParameters['id']!;
          final postAndWriter = state.extra as PostAndWriter?;
          if (isIosWeb) {
            return NoTransitionPage(
              child: PostScreen(
                postId: postId,
                postAndWriter: postAndWriter,
              ),
            );
          }
          if (isAndOrWin) {
            return CustomTransitionPage(
              transitionsBuilder: buildHorizontalSlideTransitiron,
              child: PostScreen(
                postId: postId,
                postAndWriter: postAndWriter,
              ),
            );
          }
          return CupertinoPage(
            child: PostScreen(
              postId: postId,
              postAndWriter: postAndWriter,
            ),
          );
        },
        routes: [
          GoRoute(
            path: 'edit',
            pageBuilder: (context, state) {
              final postId = state.pathParameters['id'];
              final postAndWriter = state.extra as PostAndWriter?;
              if (isIosWeb) {
                return NoTransitionPage(
                  child: EditorScreen(
                    postId: postId,
                    postAndWriter: postAndWriter,
                  ),
                );
              }
              if (isAndOrWin) {
                return CustomTransitionPage(
                  fullscreenDialog: true,
                  transitionsBuilder: buildVerticalSlideTransitiron,
                  child: EditorScreen(
                    postId: postId,
                    postAndWriter: postAndWriter,
                  ),
                );
              }
              return CupertinoPage(
                child: EditorScreen(
                  postId: postId,
                  postAndWriter: postAndWriter,
                ),
              );
            },
          ),
          GoRoute(
            path: 'likes',
            pageBuilder: (context, state) {
              final postId = state.pathParameters['id'];
              if (isIosWeb) {
                return NoTransitionPage(
                  child: LikeUsersScreen(
                    postId: postId,
                    isDislike: false,
                  ),
                );
              }
              if (isAndOrWin) {
                return CustomTransitionPage(
                  fullscreenDialog: true,
                  transitionsBuilder: buildVerticalSlideTransitiron,
                  child: LikeUsersScreen(
                    postId: postId,
                    isDislike: false,
                  ),
                );
              }
              return CupertinoPage(
                child: LikeUsersScreen(
                  postId: postId,
                  isDislike: false,
                ),
              );
            },
          ),
          GoRoute(
            path: 'dislikes',
            pageBuilder: (context, state) {
              final postId = state.pathParameters['id'];
              if (isIosWeb) {
                return NoTransitionPage(
                  child: LikeUsersScreen(
                    postId: postId,
                    isDislike: true,
                  ),
                );
              }
              if (isAndOrWin) {
                return CustomTransitionPage(
                  fullscreenDialog: true,
                  transitionsBuilder: buildVerticalSlideTransitiron,
                  child: LikeUsersScreen(
                    postId: postId,
                    isDislike: true,
                  ),
                );
              }
              return CupertinoPage(
                child: LikeUsersScreen(
                  postId: postId,
                  isDislike: true,
                ),
              );
            },
          ),
          GoRoute(
            path: 'comments',
            pageBuilder: (context, state) {
              final postId = state.pathParameters['id']!;
              final postWriter = state.extra as AppUser?;
              if (isIosWeb) {
                return NoTransitionPage(
                  child: PostCommentsScreen(
                    postId: postId,
                    postWriter: postWriter,
                  ),
                );
              }
              if (isAndOrWin) {
                return CustomTransitionPage(
                  fullscreenDialog: true,
                  transitionsBuilder: buildVerticalSlideTransitiron,
                  child: PostCommentsScreen(
                    postId: postId,
                    postWriter: postWriter,
                  ),
                );
              }
              return CupertinoPage(
                child: PostCommentsScreen(
                  postId: postId,
                  postWriter: postWriter,
                ),
              );
            },
            routes: [
              GoRoute(
                path: ':parentCommentId',
                pageBuilder: (context, state) {
                  final postId = state.pathParameters['id']!;
                  final commentId = state.pathParameters['parentCommentId']!;
                  if (isIosWeb) {
                    return NoTransitionPage(
                      child: PostCommentsScreen(
                        postId: postId,
                        parentCommentId: commentId,
                      ),
                    );
                  }
                  if (isAndOrWin) {
                    return CustomTransitionPage(
                      transitionsBuilder: buildHorizontalSlideTransitiron,
                      child: PostCommentsScreen(
                        postId: postId,
                        parentCommentId: commentId,
                      ),
                    );
                  }
                  return CupertinoPage(
                    child: PostCommentsScreen(
                      postId: postId,
                      parentCommentId: commentId,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
          path: '/account/:uid',
          pageBuilder: (context, state) {
            final uid = state.pathParameters['uid']!;
            if (isIosWeb) {
              return NoTransitionPage(
                child: CustomProfileScreen(
                  uid: uid,
                  isAccount: true,
                ),
              );
            }
            if (isAndOrWin) {
              return CustomTransitionPage(
                fullscreenDialog: true,
                transitionsBuilder: buildVerticalSlideTransitiron,
                child: CustomProfileScreen(
                  uid: uid,
                  isAccount: true,
                ),
              );
            }
            return CupertinoPage(
              child: CustomProfileScreen(
                uid: uid,
                isAccount: true,
              ),
            );
          },
          routes: [
            GoRoute(
              path: 'editUsername/:username',
              pageBuilder: (context, state) {
                final username = state.pathParameters['username']!;
                if (isIosWeb) {
                  return NoTransitionPage(
                    child: EditUsernameScreen(
                      username: username,
                    ),
                  );
                }
                if (isAndOrWin) {
                  return CustomTransitionPage(
                    transitionsBuilder: buildHorizontalSlideTransitiron,
                    child: EditUsernameScreen(
                      username: username,
                    ),
                  );
                }
                return CupertinoPage(
                  child: EditUsernameScreen(
                    username: username,
                  ),
                );
              },
            ),
            GoRoute(
              path: 'editBio/:bio',
              pageBuilder: (context, state) {
                final bio = state.pathParameters['bio']!;
                if (isIosWeb) {
                  return NoTransitionPage(
                    child: EditBioScreen(
                      bio: bio,
                    ),
                  );
                }
                if (isAndOrWin) {
                  return CustomTransitionPage(
                    transitionsBuilder: buildHorizontalSlideTransitiron,
                    child: EditBioScreen(
                      bio: bio,
                    ),
                  );
                }
                return CupertinoPage(
                  child: EditBioScreen(
                    bio: bio,
                  ),
                );
              },
            ),
            GoRoute(
              path: 'changeEmail/:email',
              pageBuilder: (context, state) {
                final email = state.pathParameters['email']!;
                if (isIosWeb) {
                  return NoTransitionPage(
                    child: ChangeEmailScreen(
                      email: email,
                    ),
                  );
                }
                if (isAndOrWin) {
                  return CustomTransitionPage(
                    transitionsBuilder: buildHorizontalSlideTransitiron,
                    child: ChangeEmailScreen(
                      email: email,
                    ),
                  );
                }
                return CupertinoPage(
                  child: ChangeEmailScreen(
                    email: email,
                  ),
                );
              },
            ),
            GoRoute(
              path: 'changePassword',
              pageBuilder: (context, state) {
                if (isIosWeb) {
                  return const NoTransitionPage(
                    child: ChangePasswordScreen(),
                  );
                }
                if (isAndOrWin) {
                  return const CustomTransitionPage(
                    transitionsBuilder: buildHorizontalSlideTransitiron,
                    child: ChangePasswordScreen(),
                  );
                }
                return const CupertinoPage(
                  child: ChangePasswordScreen(),
                );
              },
            ),
          ]),
      GoRoute(
        path: '/:uid/posts',
        pageBuilder: (context, state) {
          final uid = state.pathParameters['uid']!;
          if (isIosWeb) {
            return NoTransitionPage(
              child: ProfilePostsScreen(
                uid: uid,
                type: showAppStyleOption
                    ? PostsListType.values[appSettings.appStyle ?? 1]
                    : postsListType,
              ),
            );
          }
          if (isAndOrWin) {
            return CustomTransitionPage(
              transitionsBuilder: buildHorizontalSlideTransitiron,
              child: ProfilePostsScreen(
                uid: uid,
                type: showAppStyleOption
                    ? PostsListType.values[appSettings.appStyle ?? 1]
                    : postsListType,
              ),
            );
          }
          return CupertinoPage(
            child: ProfilePostsScreen(
              uid: uid,
              type: showAppStyleOption
                  ? PostsListType.values[appSettings.appStyle ?? 1]
                  : postsListType,
            ),
          );
        },
      ),
      GoRoute(
        path: '/:uid/comments',
        pageBuilder: (context, state) {
          final uid = state.pathParameters['uid']!;
          if (isIosWeb) {
            return NoTransitionPage(
              child: ProfileCommentsScreen(uid: uid),
            );
          }
          if (isAndOrWin) {
            return CustomTransitionPage(
              transitionsBuilder: buildHorizontalSlideTransitiron,
              child: ProfileCommentsScreen(uid: uid),
            );
          }
          return CupertinoPage(
            child: ProfileCommentsScreen(uid: uid),
          );
        },
      ),
      GoRoute(
        path: '/:uid/likes',
        pageBuilder: (context, state) {
          final uid = state.pathParameters['uid']!;
          if (isIosWeb) {
            return NoTransitionPage(
              child: ProfileLikesScreen(
                uid: uid,
                type: showAppStyleOption
                    ? PostsListType.values[appSettings.appStyle ?? 1]
                    : postsListType,
              ),
            );
          }
          if (isAndOrWin) {
            return CustomTransitionPage(
              transitionsBuilder: buildHorizontalSlideTransitiron,
              child: ProfileLikesScreen(
                uid: uid,
                type: showAppStyleOption
                    ? PostsListType.values[appSettings.appStyle ?? 1]
                    : postsListType,
              ),
            );
          }
          return CupertinoPage(
            child: ProfileLikesScreen(
              uid: uid,
              type: showAppStyleOption
                  ? PostsListType.values[appSettings.appStyle ?? 1]
                  : postsListType,
            ),
          );
        },
      ),
      GoRoute(
        path: '/profile/:uid',
        pageBuilder: (context, state) {
          final uid = state.pathParameters['uid']!;
          if (isIosWeb) {
            return NoTransitionPage(
              child: CustomProfileScreen(
                uid: uid,
              ),
            );
          }
          if (isAndOrWin) {
            return CustomTransitionPage(
              fullscreenDialog: true,
              transitionsBuilder: buildVerticalSlideTransitiron,
              child: CustomProfileScreen(
                uid: uid,
              ),
            );
          }
          return CupertinoPage(
            child: CustomProfileScreen(
              uid: uid,
            ),
          );
        },
      ),
      GoRoute(
        path: '/comment/:commentId/likes',
        pageBuilder: (context, state) {
          final commentId = state.pathParameters['commentId'];
          if (isIosWeb) {
            return NoTransitionPage(
              child: LikeUsersScreen(
                isCommentLikes: true,
                postCommentId: commentId,
                isDislike: false,
              ),
            );
          }
          if (isAndOrWin) {
            return CustomTransitionPage(
              fullscreenDialog: true,
              transitionsBuilder: buildVerticalSlideTransitiron,
              child: LikeUsersScreen(
                isCommentLikes: true,
                postCommentId: commentId,
                isDislike: false,
              ),
            );
          }
          return CupertinoPage(
            child: LikeUsersScreen(
              isCommentLikes: true,
              postCommentId: commentId,
              isDislike: false,
            ),
          );
        },
      ),
      GoRoute(
        path: '/comment/:commentId/dislikes',
        pageBuilder: (context, state) {
          final commentId = state.pathParameters['commentId'];
          if (isIosWeb) {
            return NoTransitionPage(
              child: LikeUsersScreen(
                isCommentLikes: true,
                postCommentId: commentId,
                isDislike: true,
              ),
            );
          }
          if (isAndOrWin) {
            return CustomTransitionPage(
              fullscreenDialog: true,
              transitionsBuilder: buildVerticalSlideTransitiron,
              child: LikeUsersScreen(
                isCommentLikes: true,
                postCommentId: commentId,
                isDislike: true,
              ),
            );
          }
          return CupertinoPage(
            child: LikeUsersScreen(
              isCommentLikes: true,
              postCommentId: commentId,
              isDislike: true,
            ),
          );
        },
      ),
      GoRoute(
        path: '/image',
        pageBuilder: (context, state) {
          String imageUrl = state.uri.queryParameters['imageUrl']!;
          if (imageUrl.startsWith('https://firebasestorage.googleapis.com/')) {
            imageUrl = state.uri.toString().replaceAll('/image?imageUrl=', '');
            final splits = imageUrl.split('/o/');
            imageUrl = '${splits[0]}/o/${splits[1].replaceAll('/', '%2f')}';
          }

          final multiImages = state.extra as MultiImages?;
          if (isIosWeb) {
            return NoTransitionPage(
              child: FullImageScreen(
                imageUrl: imageUrl,
                imageUrlsList: multiImages?.imageUrlsList,
                currentIndex: multiImages?.currentIndex,
              ),
            );
          }
          if (isAndOrWin) {
            return MaterialPage(
              child: FullImageScreen(
                imageUrl: imageUrl,
                imageUrlsList: multiImages?.imageUrlsList,
                currentIndex: multiImages?.currentIndex,
              ),
            );
          }
          return CupertinoPage(
            child: FullImageScreen(
              imageUrl: imageUrl,
              imageUrlsList: multiImages?.imageUrlsList,
              currentIndex: multiImages?.currentIndex,
            ),
          );
        },
      ),
      GoRoute(
        path: '/video',
        pageBuilder: (context, state) {
          String videoUrl = state.uri.queryParameters['videoUrl']!;
          if (videoUrl.startsWith('https://firebasestorage.googleapis.com/')) {
            videoUrl = state.uri.toString().replaceAll('/video?videoUrl=', '');
            final splits = videoUrl.split('/o/');
            videoUrl = '${splits[0]}/o/${splits[1].replaceAll('/', '%2f')}';
          }

          final controller = state.extra as VideoPlayerController?;
          if (isIosWeb) {
            return NoTransitionPage(
              child: FullVideoScreen(
                videoUrl: videoUrl,
                videoController: controller,
              ),
            );
          }
          if (isAndOrWin) {
            return MaterialPage(
              child: FullVideoScreen(
                videoUrl: videoUrl,
                videoController: controller,
              ),
            );
          }
          return CupertinoPage(
            child: FullVideoScreen(
              videoUrl: videoUrl,
              videoController: controller,
            ),
          );
        },
      ),
      GoRoute(
        path: '/privacy',
        pageBuilder: (context, state) {
          if (isIosWeb) {
            return const NoTransitionPage(
              child: AppPrivacyScreen(),
            );
          }
          if (isAndOrWin) {
            return const CustomTransitionPage(
              transitionsBuilder: buildHorizontalSlideTransitiron,
              child: AppPrivacyScreen(),
            );
          }
          return const CupertinoPage(
            child: AppPrivacyScreen(),
          );
        },
      ),
      GoRoute(
        path: '/terms',
        pageBuilder: (context, state) {
          if (isIosWeb) {
            return const NoTransitionPage(
              child: AppTermsScreen(),
            );
          }
          if (isAndOrWin) {
            return const CustomTransitionPage(
              transitionsBuilder: buildHorizontalSlideTransitiron,
              child: AppTermsScreen(),
            );
          }
          return const CupertinoPage(
            child: AppTermsScreen(),
          );
        },
      ),
      GoRoute(
        path: '/appInfo',
        pageBuilder: (context, state) {
          final thisYear = DateTime.now().year;
          final legalese = '© $thisYear $appCreator';
          if (isIosWeb) {
            return NoTransitionPage(
              child: LicensePage(
                applicationName: fullAppName,
                applicationLegalese: legalese,
                applicationVersion: appVersion,
              ),
            );
          }
          if (isAndOrWin) {
            return CustomTransitionPage(
              transitionsBuilder: buildHorizontalSlideTransitiron,
              child: LicensePage(
                applicationName: fullAppName,
                applicationLegalese: legalese,
                applicationVersion: appVersion,
              ),
            );
          }
          return CupertinoPage(
            child: LicensePage(
              applicationName: fullAppName,
              applicationLegalese: legalese,
              applicationVersion: appVersion,
            ),
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
        child: ErrorScaffold(
      errorMessage: context.loc.pageNotFound,
      isHome: true,
    )),
  );
}
