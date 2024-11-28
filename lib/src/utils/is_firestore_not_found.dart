bool isFirestoreNotFound(String message) {
  return message.contains('cloud_firestore/not-found');
}
