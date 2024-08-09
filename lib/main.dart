import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

final _listviewScrollController = ScrollController();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 43, 118, 216)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'เพิ่มรายชื่อนักศึกษา'),
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
  final List<String> _items = [];
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _studentNameController = TextEditingController();

  void _addItem() {
    setState(() {
      String id = _studentIdController.text;
      String name = _studentNameController.text;
      if (id.isNotEmpty && name.isNotEmpty) {
        _items.add('$id $name');
        _studentIdController.clear();
        _studentNameController.clear();
        _listviewScrollController.animateTo(
            _listviewScrollController.position.maxScrollExtent + 30,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500));
        saveFile();
      }
    });
  }

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/demoText.txt';

    return filePath;
  }

  void saveFile() async {
    File file = File(await getFilePath());

    // เขียนข้อมูลรายการนักศึกษาลงในไฟล์
    String data = _items.join('\n');
    await file.writeAsString(data);

    print('File saved successfully at ${file.path}');
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              controller: _listviewScrollController,
              itemCount: _items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    _items[index],
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.cancel,
                      size: 20,
                    ),
                    onPressed: () => _removeItem(index),
                    color: Colors.black,
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  color: Colors.grey,
                  thickness: 1,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'รหัสนักศึกษา',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _studentNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ชื่อ นามสกุล',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'เพิ่มรายการ',
        child: const Icon(Icons.add),
      ),
    );
  }
}
