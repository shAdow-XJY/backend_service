import 'dart:convert';
import 'package:backend_service/server/config/server_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../server/common/base_api_config.dart';
import '../server/routers/novel_routes.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _url = '';
  String _requestBody = '';
  String _responseMessage = 'Response will appear here...';

  final List<BSBaseAPIConfig> _apiConfigList = [
    BSNovelAPIConfig(),
    // 可以添加更多 API 配置
  ];

  Future<void> _fetchApiResponse(String endpoint, {String method = 'GET'}) async {
    try {
      final uri = Uri.parse('http://${BSServerConfig.host}:${BSServerConfig.port}$endpoint');
      http.Response response;

      if (method == 'GET') {
        response = await http.get(uri);
      } else if (method == 'POST') {
        response = await http.post(uri, body: jsonEncode(jsonDecode(_requestBody)));
      } else {
        throw Exception('Unsupported method: $method');
      }

      if (response.statusCode == 200) {
        setState(() {
          _responseMessage = jsonEncode(jsonDecode(response.body));
        });
      } else {
        setState(() {
          _responseMessage = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Failed to connect: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
        leading: ClipOval(
          child: Image.asset(
            'assets/images/avatar.png',
            width: 24,
            height: 24,
            fit: BoxFit.cover, // 适应图像填充
          ),
        ),
        actions: [
          // 右边图标
          IconButton(
            icon: const ImageIcon(AssetImage('assets/images/GitHub.png')),
            onPressed: () {
              launchUrl(Uri.parse('https://github.com/shAdow-XJY/backend_service'));
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: _apiConfigList.map((apiConfig) {
                  return ExpansionTile(
                    title: Text(apiConfig.apiPrefix, style: const TextStyle(fontWeight: FontWeight.bold)),
                    children: [
                      ExpansionTile(
                        title: const Text('GET APIs', style: TextStyle(color: Colors.blue)),
                        children: apiConfig.getAPIList.map((api) {
                          return ListTile(
                            title: Text(api),
                            onTap: () {
                              setState(() {
                                _url = apiConfig.apiPrefix + api;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      ExpansionTile(
                        title: const Text('POST APIs', style: TextStyle(color: Colors.red)),
                        children: apiConfig.postAPIList.map((api) {
                          return ListTile(
                            title: Text(api),
                            onTap: () {
                              setState(() {
                                _url = apiConfig.apiPrefix + api;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const VerticalDivider(width: 1, color: Colors.grey), // 分割线
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'URL'),
                    controller: TextEditingController(text: _url),
                    onChanged: (value) {
                        _url = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Request Body (for POST)'),
                    controller: TextEditingController(text: _requestBody),
                    onChanged: (value) {
                        _requestBody = value;
                    },
                    maxLines: 5,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _fetchApiResponse(_url, method: 'GET'),
                    child: const Text('GET'),
                  ),
                  ElevatedButton(
                    onPressed: () => _fetchApiResponse(_url, method: 'POST'),
                    child: const Text('POST'),
                  ),
                  const SizedBox(height: 10),
                  Text('Response:'),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(_responseMessage),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
