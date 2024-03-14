import 'package:applimode_app/src/features/firebase_storage/firebase_storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> deleteStorageList(Ref ref, String path) async {
  final listResult = await ref
      .read(firebaseStorageRepositoryProvider)
      .storageRef(path)
      .listAll();

  for (var item in listResult.items) {
    item.delete();
  }
}
