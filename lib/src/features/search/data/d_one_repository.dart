import 'dart:convert';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/env/env.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/utils/string_converter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'd_one_repository.g.dart';

class DOneRepository {
  const DOneRepository();

  static const baseUrl = dOneBaseUrl;
  static const postsBasePath = '/api/posts';
  static const searchLimit = 20;

  Future<List<String>> getPostsSearchPage(String search, [int? start]) async {
    final optimized = StringConverter.toSearch(search);
    final url = Uri.https(
      baseUrl,
      postsBasePath,
      <String, String>{
        'q': optimized,
        if (start != null) 's': start.toString(),
      },
    );
    final response = await http.get(
      url,
      headers: {
        "X-Custom-Auth-Key": Env.workerKey,
        "Content-Type": contentJson,
      },
    );
    final data = (jsonDecode(response.body) as List<dynamic>)
        .map((e) => e['pid'] as String)
        .toList();
    return data;
  }

  Future<List<String>> getPostsSearchAll(String search) async {
    final optimized = StringConverter.toSearch(search);
    final url = Uri.https(
      baseUrl,
      '$postsBasePath/all',
      <String, String>{
        'q': optimized,
      },
    );
    final response = await http.get(
      url,
      headers: {
        "X-Custom-Auth-Key": Env.workerKey,
        "Content-Type": contentJson,
      },
    );
    final data = (jsonDecode(response.body) as List<dynamic>)
        .map((e) => e['pid'] as String)
        .toList();
    return data;
  }

  Future<void> postPostsSearch(String postId, String search) async {
    final url = Uri.https(baseUrl, '$postsBasePath/$postId');
    http.post(
      url,
      headers: {
        "X-Custom-Auth-Key": Env.workerKey,
        "Content-Type": "text/plain",
      },
      body: search,
    );
  }

  Future<void> putPostsSearch(String postId, String search) async {
    final url = Uri.https(baseUrl, '$postsBasePath/$postId');
    http.put(
      url,
      headers: {
        "X-Custom-Auth-Key": Env.workerKey,
        "Content-Type": "text/plain",
      },
      body: search,
    );
  }

  Future<void> deletePostsSearch(String postId) async {
    final url = Uri.https(baseUrl, '$postsBasePath/$postId');
    http.delete(
      url,
      headers: {
        "X-Custom-Auth-Key": Env.workerKey,
      },
    );
  }
}

@riverpod
DOneRepository dOneRepository(DOneRepositoryRef ref) {
  return const DOneRepository();
}
