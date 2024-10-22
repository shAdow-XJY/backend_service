import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:backend_service/server/server.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Web with Dart Backend'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchDataFromBackend();
  }

  Future<void> _fetchDataFromBackend() async {
    try {
      // 发起 HTTP 请求获取后端的数据
      final response = await http.get(Uri.parse('http://localhost:8080/api/resource/789'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('data: $data');
        setState(() {
          _message = data['id'];
          print(_message);
        });
      } else {
        setState(() {
          _message = 'Error: ${response.statusCode}';
          print(_message);
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Failed to connect to backend: $e';
        print(_message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Response from backend:'),
            Text(
              _message,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
