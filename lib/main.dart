import 'package:flutter/material.dart';
import 'package:backend_service/server/server.dart';

import 'front/home_page.dart';

void main() async {
  // 启动后台服务
  await serverMain();

  // 启动前端 Flutter macOS 应用
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MacOS with Backend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter MacOS with Backend'),
    );
  }
}


