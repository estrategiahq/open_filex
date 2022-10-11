import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _openResult = 'Unknown';

  Future<String> download(String url, String filename) async {
    HttpClient httpClient = new HttpClient();
    
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file;
      file = File("$dir/$filename");
      await file.writeAsBytes(bytes);
      return file.absolute.path;
    }
    throw Exception("Error downloading file");
  }

  Future<void> openFile() async {
    final filePath = await download('https://www.africau.edu/images/default/sample.pdf', 'sample.pdf');

    OpenFilex.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('open result: $_openResult\n'),
              TextButton(
                child: Text('Tap to open file'),
                onPressed: openFile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
