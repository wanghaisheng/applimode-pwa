import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'updated_post_ids_list.g.dart';

@riverpod
class UpdatedPostIdsList extends _$UpdatedPostIdsList {
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
