import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ResultView extends StatefulWidget {
  final String url;
  ResultView(this.url);

  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  String path = 'https://example.com/frame.php?path=';
  double progress = 0;

  @override
  void initState() {
    super.initState();
    path += widget.url;
    print(path);

    // Example of listening to loading events
    flutterWebviewPlugin.onProgressChanged.listen((progress) {
      setState(() {
        this.progress = progress;
      });
    });
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: Container(
            child: Column(children: <Widget>[
          if (progress < 1.0) LinearProgressIndicator(value: progress),
          Expanded(
              child: Container(
                  margin: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                  child: WebviewScaffold(
                    appBar: AppBar(
                      title: Text("BPS PLAY SCHOOL"),
                    ),
                    url: path,
                    scrollBar: true,
                    withZoom: true,
                    withLocalStorage: true,
                    hidden: true,
                    allowFileURLs: true,
                    withJavascript: true,
                    initialChild: Container(
                      color: Colors.white,
                      child: const Center(
                        child: Text(
                          'Wait .....\n Checking Internet Connection',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                    ),
                  ))),
        ])));
  }
}
