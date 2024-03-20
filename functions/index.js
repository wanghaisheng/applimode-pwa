const admin = require("firebase-admin");
// const functionsV1 = require("firebase-functions");
const functionsV2 = require("firebase-functions/v2");
// import * as admin from "firebase-admin";
// import {onDocumentCreated} from "firebase-functions/v2/firestore";

/*
const newPostMessage = {
  notification: {
    title: "새글",
    body: "새로운 글이 올라왔습니다!",
  },
  data: {
    // type: "post",
    content: "새로운 글이 올라왔습니다!",
    // english version
    // content: "A new post has been uploaded!",
  },
  topic: "newPost",
};
*/

// initialize app
admin.initializeApp();

/*
exports.onPostCreated = functionsV2.firestore.onDocumentCreated("posts/{id}", (event) => {
  admin.messaging().send(newPostMessage).then((response) => {
    console.log("Successfully sent message:", response);
  }).catch((error) => {
    console.log("Error sending message:", error);
  });
});
*/

exports.sendFcmMessage = functionsV2.https.onCall((request) => {
  console.log("myPayload:", request.data);
  admin.messaging().send(request.data.payload).then((response) => {
    console.log("Successfully sent message:", response);
  }).catch((error) => {
    console.log("Error sending message:", error);
  });
});

/*
exports.onCommentCreated = functionsV2.https.onCall((request) => {
  console.log("myPayload:", request.data);
  admin.messaging().send(request.data.payload).then((response) => {
    console.log("payload:", request.data.payload);
    console.log("Successfully sent message:", response);
  }).catch((error) => {
    console.log("payload:", request.data.payload);
    console.log("Error sending message:", error);
  });
});
*/

/*
exports.onCommentCreated = functionsV2.firestore.onDocumentCreated("postComments/{id}", (event) => {
  const comment = event.data.data();
  const user = admin.firestore().collection("users").doc(comment.uid).get();
  console.log("comment", comment);
  console.log("user", user);
  const commentMessage = {
    notification: {
      title: "새 댓글",
      body: "새로운 댓글이 올라왔습니다!",
    },
    data: {
      type: "comments",
      postId: event.params.id,
      content: "새로운 댓글이 올라왔습니다!",
      // english version
      // content: "A new comment has been uploaded!",
    },
    // topic: "newPost",
    token: user["fcmToken"],
  };
  admin.messaging().send(commentMessage).then((response) => {
    console.log("Successfully sent message:", response);
  }).catch((error) => {
    console.log("Error sending message:", error);
  });
});
*/
