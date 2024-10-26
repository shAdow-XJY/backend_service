abstract class BSBaseAPIConfig {
  // API 前缀
  String get apiPrefix;

  // GET 请求的 API 列表
  List<String> get getAPIList;

  // POST 请求的 API 列表
  List<String> get postAPIList;

  // 获取 API 路径的方法
  String getApiPath(String path) => '$apiPrefix$path';
}