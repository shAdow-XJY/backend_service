import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../common/base_api_config.dart';

class BSNovelAPIConfig extends BSBaseAPIConfig {
  // 私有构造函数
  BSNovelAPIConfig._();

  // 单例实例
  static final BSNovelAPIConfig _instance = BSNovelAPIConfig._();

  // 提供外部调用的单例方法
  factory BSNovelAPIConfig() {
    return _instance;
  }

  // 自定义 API 前缀
  @override
  String get apiPrefix => "/api/novel";

  // 自定义 GET 请求的 API 列表
  static const String getNovels = "/getNovels";
  static const String getNovelById = "/getNovel/<novelId>";
  static const String getNovelChapterById = "/getChapter&novel=<novelId>&chapter=<chapterId>";

  @override
  List<String> get getAPIList => [
    getNovels,
    getNovelById,
    getNovelChapterById,
  ];

  // 自定义 POST 请求的 API 列表
  static const String addNovel = "/novel/add";

  @override
  List<String> get postAPIList => [
    addNovel,
  ];
}


Router createNovelRouter() {
  final router = Router();

  // 返回小说列表
  router.get(BSNovelAPIConfig.getNovels, (Request request) {
    return Response.ok(jsonEncode({'novels': ['Novel 1', 'Novel 2']}), headers: {'Content-Type': 'application/json'});
  });

  // 返回特定小说
  router.get(BSNovelAPIConfig.getNovelById, (Request request, String novelId) {
    return Response.ok(jsonEncode({'id': novelId, 'name': 'Novel $novelId'}), headers: {'Content-Type': 'application/json'});
  });

  // 返回特定小说的章节
  router.get(BSNovelAPIConfig.getNovelChapterById, (Request request, String novelId, String chapterId) {
    // 这里可以根据 novelId 和 chapterId 返回特定章节的内容
    return Response.ok(jsonEncode({'novelId': novelId, 'chapterId': chapterId, 'content': 'Content of chapter $chapterId from novel $novelId'}), headers: {'Content-Type': 'application/json'});
  });

  // 添加小说
  router.post(BSNovelAPIConfig.addNovel, (Request request) async {
    final body = await request.readAsString();
    // 这里可以解析请求体，通常是 JSON 格式，并保存小说
    final Map<String, dynamic> novelData = jsonDecode(body);

    // 假设我们简单地返回添加的小说数据
    return Response.ok(jsonEncode({'message': 'Novel added successfully', 'novel': novelData}), headers: {'Content-Type': 'application/json'});
  });

  return router;
}

