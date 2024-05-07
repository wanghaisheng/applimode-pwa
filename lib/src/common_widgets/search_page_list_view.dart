import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SearchPageListItemBuilder<Document> = Widget Function(
  BuildContext context,
  int index,
  DocumentSnapshot<Document> doc,
);

typedef SearchPageListLoadingBuilder = Widget Function(BuildContext context);

typedef SearchPageListErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace stackTrace,
);

typedef SearchPageListEmptyBuilder = Widget Function(BuildContext context);

class SearchPageListView<Document> extends ConsumerStatefulWidget {
  const SearchPageListView({
    super.key,
    required this.searchWords,
    required this.searchQuery,
    required this.query,
    required this.itemBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.listState,
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
    this.useDidUpdateWidget = false,
    this.refreshUpdatedDocs = false,
    this.resetUpdatedDocIds,
    this.updatedDocsState,
    this.useUid = false,
  });

  final String searchWords;
  final Future<List<String>> Function(String) searchQuery;
  final DocumentReference<Document> Function(String) query;
  final SearchPageListItemBuilder<Document> itemBuilder;
  final SearchPageListLoadingBuilder? loadingBuilder;
  final SearchPageListErrorBuilder? errorBuilder;
  final SearchPageListEmptyBuilder? emptyBuilder;
  final ProviderListenable<int>? listState;
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
  final bool useDidUpdateWidget;
  final bool refreshUpdatedDocs;
  final VoidCallback? resetUpdatedDocIds;
  final ProviderListenable<List<String>>? updatedDocsState;
  final bool useUid;

  @override
  ConsumerState<SearchPageListView<Document>> createState() =>
      _SearchPageListViewState<Document>();
}

class _SearchPageListViewState<Document>
    extends ConsumerState<SearchPageListView<Document>>
    with WidgetsBindingObserver {
  late List<DocumentSnapshot<Document>> docs = [];
  late List<String> pids = [];
  late bool isFetching = false;
  late bool isFetchingMore = false;
  late bool hasMore = false;
  late int refreshTime = DateTime.now().millisecondsSinceEpoch;
  late bool hasMain = false;

  @override
  void initState() {
    super.initState();
    if (widget.searchWords.trim().length > 1) {
      _fechDocs();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SearchPageListView<Document> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.useDidUpdateWidget && widget.searchWords.trim().length > 1) {
      pids = [];
      docs = [];
      _fechDocs();
    }
    /*
    if (widget.useDidUpdateWidget &&
        oldWidget.searchWords != widget.searchWords) {
      if (widget.searchWords.length < 2) {
        pids = [];
        docs = [];
      } else {
        pids = [];
        docs = [];
        _fechDocs();
      }
    }
    */
  }

  void _fetchNextPage() {
    if (isFetching || isFetchingMore || !hasMore) {
      return;
    }
    _fechDocs(nextPage: true);
  }

  Future<void> _fechDocs({bool nextPage = false}) async {
    if (widget.searchWords.length < 2) {
      pids = [];
      docs = [];
      return;
    }
    if (nextPage) {
      isFetchingMore = true;
    } else {
      isFetching = true;
    }
    Future.microtask(() => setState(() {}));
    if (nextPage) {
      debugPrint('fetch search next page');
      final lastIndex = pids.length > docs.length + listFetchLimit
          ? docs.length + listFetchLimit
          : pids.length;
      for (final pid in pids.sublist(docs.length, lastIndex)) {
        final snapshot = await widget.query(pid).get();
        docs.add(snapshot);
      }
    } else {
      debugPrint('fetch search initial page');
      pids = await widget.searchQuery(widget.searchWords);
      final lastIndex =
          pids.length > listFetchLimit ? listFetchLimit : pids.length;

      for (final pid in pids.sublist(0, lastIndex)) {
        final snapshot = await widget.query(pid).get();
        docs.add(snapshot);
      }

      refreshTime = DateTime.now().millisecondsSinceEpoch;
    }

    if (pids.length > docs.length) {
      hasMore = true;
    } else {
      hasMore = false;
    }

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
          final newDoc = await widget.query(updatedDocId).get();
          docs = [
            for (final doc in docs)
              if (doc.id == updatedDocId) newDoc else doc
          ];
        }
      }
      widget.resetUpdatedDocIds?.call();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // wher user changes doc, refesh
    if (widget.listState != null) {
      ref.listen(widget.listState!, (_, next) {
        if (next > refreshTime) {
          docs = [];
          _fechDocs();
        }
      });
    }

    if (widget.refreshUpdatedDocs && widget.updatedDocsState != null) {
      ref.listen(widget.updatedDocsState!, (_, next) {
        debugPrint('updatedDocs: $next');
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

// limit version
/*
class SearchPageListView<Document> extends ConsumerStatefulWidget {
  const SearchPageListView({
    super.key,
    required this.searchWords,
    required this.searchQuery,
    required this.query,
    required this.itemBuilder,
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
    this.useDidUpdateWidget = false,
    this.refreshUpdatedDocs = false,
    this.resetUpdatedDocIds,
    this.updatedDocsState,
    this.useUid = false,
  });

  final String searchWords;
  final Future<List<String>> Function(String, [int?]) searchQuery;
  final DocumentReference<Document> Function(String) query;
  final SearchPageListItemBuilder<Document> itemBuilder;
  final SearchPageListLoadingBuilder? loadingBuilder;
  final SearchPageListErrorBuilder? errorBuilder;
  final SearchPageListEmptyBuilder? emptyBuilder;
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
  final bool useDidUpdateWidget;
  final bool refreshUpdatedDocs;
  final VoidCallback? resetUpdatedDocIds;
  final ProviderListenable<List<String>>? updatedDocsState;
  final bool useUid;

  @override
  ConsumerState<SearchPageListView<Document>> createState() =>
      _SearchPageListViewState<Document>();
}

class _SearchPageListViewState<Document>
    extends ConsumerState<SearchPageListView<Document>>
    with WidgetsBindingObserver {
  late List<DocumentSnapshot<Document>> docs = [];
  late bool isFetching = false;
  late bool isFetchingMore = false;
  late bool hasMore = false;
  late int refreshTime = DateTime.now().millisecondsSinceEpoch;
  late bool hasMain = false;

  static const fetchLimit = 20;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SearchPageListView<Document> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.useDidUpdateWidget &&
        oldWidget.searchWords != widget.searchWords) {
      if (widget.searchWords.length < 2) {
        docs = [];
      } else {
        docs = [];
        _fechDocs();
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
    if (widget.searchWords.length < 2) {
      docs = [];
      return;
    }
    List<DocumentSnapshot<Document>> snapshots = [];
    if (nextPage) {
      isFetchingMore = true;
    } else {
      isFetching = true;
    }
    Future.microtask(() => setState(() {}));
    if (nextPage) {
      final searchPids =
          await widget.searchQuery(widget.searchWords, docs.length);
      for (final pid in searchPids) {
        final snapshot = await widget.query(pid).get();
        snapshots.add(snapshot);
      }
    } else {
      final searchPids = await widget.searchQuery(widget.searchWords);
      for (final pid in searchPids) {
        final snapshot = await widget.query(pid).get();
        snapshots.add(snapshot);
      }

      refreshTime = DateTime.now().millisecondsSinceEpoch;
    }

    if (snapshots.length > fetchLimit) {
      hasMore = true;
      snapshots.removeLast();
    } else {
      hasMore = false;
    }
    docs = [...docs, ...snapshots];

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
          final newDoc = await widget.query(updatedDocId).get();
          docs = [
            for (final doc in docs)
              if (doc.id == updatedDocId) newDoc else doc
          ];
        }
      }
      widget.resetUpdatedDocIds?.call();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // wher user changes doc, refesh
    if (widget.listState != null) {
      ref.listen(widget.listState!, (_, next) {
        if (next > refreshTime) {
          docs = [];
          _fechDocs();
        }
      });
    }

    if (widget.refreshUpdatedDocs && widget.updatedDocsState != null) {
      ref.listen(widget.updatedDocsState!, (_, next) {
        debugPrint('updatedDocs: $next');
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
*/