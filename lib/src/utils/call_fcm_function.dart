import 'package:cloud_functions/cloud_functions.dart';

void callFcmFunction({
  required String functionName,
  String? type,
  required String content,
  String? postId,
  String? commentId,
  bool isTopic = false,
  String? topic,
  String? token,
}) {
  final callable = FirebaseFunctions.instance.httpsCallable(functionName);
  final payload = {
    "notification": {
      // "title": "Noti Title",
      "body": content,
    },
    "data": {
      if (type != null && type.isNotEmpty) "type": type,
      if (postId != null && postId.isNotEmpty) "postId": postId,
      if (commentId != null && commentId.isNotEmpty) "commentId": commentId,
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
    },
    if (isTopic) "topic": topic,
    if (!isTopic) "token": token,
    "android": {
      "priority": "normal", // high
    },
    "apns": {
      "headers": {
        "apns-priority": "5", // 10
      },
      "payload": {
        "aps": {
          "sound": "default",
        },
      }
    },
  };
  callable.call(<String, dynamic>{"payload": payload});
}
