import 'package:applimode_app/custom_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_item_mute_state.g.dart';

@Riverpod(keepAlive: true)
class PostsItemMuteState extends _$PostsItemMuteState {
  @override
  bool build() {
    return isPostsItemVideoMute;
  }

  void setTrue() {
    state = true;
  }

  void setFalse() {
    state = false;
  }
}
