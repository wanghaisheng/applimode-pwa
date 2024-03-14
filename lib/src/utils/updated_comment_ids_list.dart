import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'updated_comment_ids_list.g.dart';

@riverpod
class UpdatedCommentIdsList extends _$UpdatedCommentIdsList {
  @override
  List<String> build() {
    return [];
  }

  void set(String id) {
    if (!state.contains(id)) {
      state = [...state, id];
    }
  }

  void remove(String id) {
    if (!state.contains(id)) {
      state = state.where((element) => element != id).toList();
    }
  }

  void removeAll() {
    state = [];
  }
}
