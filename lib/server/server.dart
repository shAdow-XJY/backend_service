import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> serverMain() async {
  final router = Router();

  router.get('/api/resource/<id>', (Request request, String id) {
    // 返回 JSON 格式的数据
    final resource = {'id': id, 'name': 'Resource $id'};
    return Response.ok(jsonEncode(resource), headers: {'Content-Type': 'application/json'});
  });

  router.get('/<file|.*>', (Request request) {
    // 返回普通文本
    return Response.ok('789', headers: {'Content-Type': 'text/plain'});
  });

  // 创建服务器
  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(router);

  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Server listening on port http://localhost:${server.port}');
}
