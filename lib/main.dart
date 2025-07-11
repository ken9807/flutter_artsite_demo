import 'package:flutter/material.dart';
import 'services/sqlite_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Demo',
      home: const SQLiteDemoPage(),
    );
  }
}

class SQLiteDemoPage extends StatefulWidget {
  const SQLiteDemoPage({super.key});

  @override
  State<SQLiteDemoPage> createState() => _SQLiteDemoPageState();
}

class _SQLiteDemoPageState extends State<SQLiteDemoPage> {
  String _output = '尚未查詢';

  Future<void> _runDemo() async {
    final sqlite = SQLiteService();
    await sqlite.insertOrUpdate('theme', 'dark');
    final value = await sqlite.getValue('theme');
    setState(() {
      _output = value ?? '找不到資料';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SQLite 測試')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_output),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _runDemo,
              child: const Text('讀取 SQLite'),
            ),
          ],
        ),
      ),
    );
  }
}