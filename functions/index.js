const admin = require("firebase-admin");
const functionsV2 = require("firebase-functions/v2");

// initialize app
admin.initializeApp();

// send push notification
exports.sendFcmMessage = functionsV2.https.onCall((request) => {
  console.log("myPayload:", request.data);
  admin.messaging().send(request.data.payload).then((response) => {
    console.log("Successfully sent message:", response);
  }).catch((error) => {
    console.log("Error sending message:", error);
  });
});

// subscribe to topic
exports.subscribeToTopic = functionsV2.https.onCall((request) => {
  console.log("requestData:", request.data);
  admin.messaging().subscribeToTopic(request.data.registrationTokens, request.data.topic).then((response) => {
    // See the MessagingTopicManagementResponse reference documentation
    // for the contents of response.
    console.log("Successfully subscribed to topic:", response);
  }).catch((error) => {
    console.log("Error subscribing to topic:", error);
  });
});

// unsubscribe from topic
exports.unsubscribeFromTopic = functionsV2.https.onCall((request) => {
  admin.messaging().unsubscribeFromTopic(request.data.registrationTokens, request.data.topic).then((response) => {
    // See the MessagingTopicManagementResponse reference documentation
    // for the contents of response.
    console.log("Successfully unsubscribed from topic:", response);
  }).catch((error) => {
    console.log("Error unsubscribing from topic:", error);
  });
});

