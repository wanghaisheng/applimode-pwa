import 'dart:developer' as dev;

import 'package:applimode_app/src/app_settings/app_settings_controller.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SimplePageListItemBuilder<Document> = Widget Function(
  BuildContext context,
  int index,
  QueryDocumentSnapshot<Document> doc,
);

typedef SimplePageListLoadingBuilder = Widget Function(BuildContext context);

typedef SimplePageListErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace stackTrace,
);

typedef SimplePageListEmptyBuilder = Widget Function(BuildContext context);

class SimplePageListView<Document> extends ConsumerStatefulWidget {
  const SimplePageListView({
    super.key,
    required this.query,
    required this.itemBuilder,
    this.isPage = false,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.listState,
    this.showMain = false,
    this.mainQuery,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.prototypeItem,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.pageController,
    this.pageSnapping = true,
    this.onPageChanged,
    this.findChildIndexCallback,
    this.allowImplicitScrolling = false,
    this.scrollBehavior,
    this.padEnds = true,
    this.recentDocQuery,
    this.useDidUpdateWidget = false,
    this.refreshUpdatedDocs = false,
    this.updatedDocQuery,
    this.isRootTabel = false,
    this.resetUpdatedDocIds,
    this.updatedDocsState,
    this.useUid = false,
    this.isSearchView = false,
    this.searchWords,
  });

  final Query<Document> query;
  final SimplePageListItemBuilder<Document> itemBuilder;
  final bool isPage;
  final SimplePageListLoadingBuilder? loadingBuilder;
  final SimplePageListErrorBuilder? errorBuilder;
  final SimplePageListEmptyBuilder? emptyBuilder;
  final ProviderListenable<int>? listState;
  final bool showMain;
  final Query<Document>? mainQuery;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final Widget? prototypeItem;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final PageController? pageController;
  final bool pageSnapping;
  final void Function(int)? onPageChanged;
  final int Function(Key)? findChildIndexCallback;
  final bool allowImplicitScrolling;
  final ScrollBehavior? scrollBehavior;
  final bool padEnds;
  final Query<Document>? recentDocQuery;
  final bool useDidUpdateWidget;
  final bool refreshUpdatedDocs;
  final Query<Document>? updatedDocQuery;
  final bool isRootTabel;
  final VoidCallback? resetUpdatedDocIds;
  final ProviderListenable<List<String>>? updatedDocsState;
  final bool useUid;
  final bool isSearchView;
  final String? searchWords;

  @override
  ConsumerState<SimplePageListView<Document>> createState() =>
      _SimplePageListViewState<Document>();
}

class _SimplePageListViewState<Document>
    extends ConsumerState<SimplePageListView<Document>>
    with WidgetsBindingObserver {
  late List<QueryDocumentSnapshot<Document>> docs = [];
  late bool isFetching = false;
  late bool isFetchingMore = false;
  late bool hasMore = false;
  late int refreshTime = DateTime.now().millisecondsSinceEpoch;
  late bool hasMain = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!widget.isSearchView ||
        widget.isSearchView &&
            widget.searchWords != null &&
            widget.searchWords!.length > 1) {
      _fechDocs();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkRecentDoc();
    }
  }

  @override
  void didUpdateWidget(covariant SimplePageListView<Document> oldWidget) {
    if (widget.useDidUpdateWidget &&
        widget.isSearchView &&
        widget.searchWords != null &&
        widget.searchWords!.length > 1) {
      docs = [];
      _fechDocs();
    }
    if (widget.useDidUpdateWidget &&
        !widget.isSearchView &&
        oldWidget.query != widget.query) {
      docs = [];
      _fechDocs();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _checkRecentDoc() async {
    if (widget.recentDocQuery != null) {
      final snapshot = await widget.recentDocQuery!.get();
      if (snapshot.docs.isNotEmpty && docs.isNotEmpty) {
        final recentDoc = snapshot.docs.first;
        if (hasMain && docs.length > 1 && recentDoc.id != docs[1].id) {
          docs = [];
          _fechDocs();
        } else if (!hasMain && recentDoc.id != docs[0].id) {
          docs = [];
          _fechDocs();
        }
      }
    }
  }

  void _fetchNextPage() {
    if (isFetching || isFetchingMore || !hasMore) {
      return;
    }
    _fechDocs(nextPage: true);
  }

  Future<void> _fechDocs({bool nextPage = false}) async {
    QuerySnapshot<Document>? querySnapshot;
    QueryDocumentSnapshot<Document>? mainSnapshot;
    if (nextPage) {
      isFetchingMore = true;
    } else {
      isFetching = true;
    }
    Future.microtask(() => setState(() {}));
    if (nextPage) {
      querySnapshot = await widget.query
          .startAfterDocument(docs.last)
          .limit(listFetchLimit + 1)
          .get();
    } else {
      if (widget.showMain && widget.mainQuery != null) {
        final mainQuerySnapshot = await widget.mainQuery!.get();
        final docs = mainQuerySnapshot.docs;
        if (docs.isNotEmpty) {
          mainSnapshot = docs.first;
          hasMain = true;
        }
      }
      querySnapshot = mainSnapshot != null
          ? await widget.query.limit(listFetchLimit).get()
          : await widget.query.limit(listFetchLimit + 1).get();
      refreshTime = DateTime.now().millisecondsSinceEpoch;
    }
    final result = mainSnapshot != null
        ? [mainSnapshot, ...querySnapshot.docs]
        : querySnapshot.docs;

    if (result.length > listFetchLimit) {
      hasMore = true;
      result.removeLast();
    } else {
      hasMore = false;
    }
    docs = [...docs, ...result];

    setState(() {
      if (nextPage) {
        isFetchingMore = false;
      } else {
        isFetching = false;
      }
    });
  }

  Future<void> updateDocs(List<String> updatedDocIds) async {
    if (docs.isNotEmpty && updatedDocIds.isNotEmpty) {
      final docIds = List.from(docs.map((snapshot) => snapshot.id));
      for (final updatedDocId in updatedDocIds) {
        if (docIds.contains(updatedDocId)) {
          final querySnapshot = await widget.updatedDocQuery!
              .where(widget.useUid ? 'uid' : 'id', isEqualTo: updatedDocId)
              .limit(1)
              .get();
          final newDoc =
              querySnapshot.docs.isNotEmpty ? querySnapshot.docs[0] : null;
          if (newDoc != null) {
            docs = [
              for (final doc in docs)
                if (doc.id == updatedDocId) newDoc else doc
            ];
          }
        }
      }
      widget.resetUpdatedDocIds?.call();
      if (mounted) {
        setState(() {});
      }

      /*
      if (widget.isRootTabel) {
        widget.resetUpdatedDocIds?.call();
        setState(() {});
      } else {
        setState(() {});
      }
      */
    }
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(appSettingsControllerProvider);
    final adminSettings = ref.watch(adminSettingsProvider);

    // wher user changes doc, refesh
    if (widget.listState != null) {
      ref.listen(widget.listState!, (_, next) {
        if (next > refreshTime) {
          docs = [];
          _fechDocs();
        }
      });
    }

    if (widget.refreshUpdatedDocs &&
        widget.updatedDocQuery != null &&
        widget.updatedDocsState != null) {
      ref.listen(widget.updatedDocsState!, (_, next) {
        dev.log('updatedDocs: $next');
        updateDocs(next);
      });
    }

    // when fist fetch loading
    if (isFetching) {
      if (widget.loadingBuilder != null) {
        return widget.loadingBuilder!.call(context);
      }

      return const Center(child: CupertinoActivityIndicator());
    }

    // when doc is empty
    if (docs.isEmpty) {
      if (widget.emptyBuilder != null) {
        return widget.emptyBuilder!.call(context);
      }

      return Center(child: Text(context.loc.noContent));
    }

    if (widget.isPage) {
      return PageView.builder(
        itemBuilder: _itemBuilder,
        itemCount: docs.length,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        controller: widget.pageController,
        physics: widget.physics,
        pageSnapping: widget.pageSnapping,
        onPageChanged: widget.onPageChanged,
        findChildIndexCallback: widget.findChildIndexCallback,
        dragStartBehavior: widget.dragStartBehavior,
        allowImplicitScrolling: widget.allowImplicitScrolling,
        restorationId: widget.restorationId,
        clipBehavior: widget.clipBehavior,
        scrollBehavior: widget.scrollBehavior,
        padEnds: widget.padEnds,
      );
    }

    final currentListType = adminSettings.showAppStyleOption
        ? PostsListType.values[appSettings.appStyle ?? 1]
        : adminSettings.postsListType;
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (currentListType == PostsListType.square &&
        screenWidth > pcWidthBreakpoint &&
        !widget.isSearchView) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
        ),
        itemBuilder: _itemBuilder,
        itemCount: docs.length,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        controller: widget.controller,
        primary: widget.primary,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        padding: widget.padding,
        addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
        addRepaintBoundaries: widget.addRepaintBoundaries,
        addSemanticIndexes: widget.addSemanticIndexes,
        cacheExtent: widget.cacheExtent,
        semanticChildCount: widget.semanticChildCount,
        dragStartBehavior: widget.dragStartBehavior,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        restorationId: widget.restorationId,
        clipBehavior: widget.clipBehavior,
      );
    }
    return ListView.builder(
      itemBuilder: _itemBuilder,
      itemCount: docs.length,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemExtent: widget.itemExtent,
      prototypeItem: widget.prototypeItem,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      cacheExtent: widget.cacheExtent,
      semanticChildCount: widget.semanticChildCount,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      restorationId: widget.restorationId,
      clipBehavior: widget.clipBehavior,
    );
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    final isLastItem = index + 1 == docs.length;
    if (isLastItem && hasMore) _fetchNextPage();
    final doc = docs[index];
    return widget.itemBuilder(context, index, doc);
  }
}
