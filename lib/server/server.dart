import 'dart:convert';
import 'package:backend_service/server/config/server_config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'routers/novel_routes.dart';

Middleware createErrorHandlingMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        final response = await innerHandler(request);
        return response;
      } catch (e, stackTrace) {
        print('Error: $e\nStackTrace: $stackTrace');
        return Response.internalServerError(
          body: jsonEncode({
            'error': 'An unexpected error occurred.',
            'message': e.toString(), // 可以选择是否返回详细的错误信息
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  };
}


Future<void> serverMain() async {
  final router = Router();

  // 加载不同模块的路由
  router.mount(BSNovelAPIConfig().apiPrefix, createNovelRouter().call);

  // 创建服务器并添加错误处理的中间件
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(createErrorHandlingMiddleware()) // 添加错误处理中间件
      .addHandler(router.call);

  final server = await shelf_io.serve(handler, BSServerConfig.host, BSServerConfig.port);
  print('Server listening on port http://${BSServerConfig.host}:${BSServerConfig.port}');
}
