import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Babywatcher',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _videoUrl = 'http://192.168.0.141:5000/video_feed';
  VideoPlayerController _controller;
  final _webview = new FlutterWebviewPlugin();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = new VideoPlayerController(_videoUrl)
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Babywatcher'),
      ),
      body: new Center(
          child: new Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new AspectRatio(
              aspectRatio: 1280 / 720,
              child: new VideoPlayer(_controller),
            ),
          ),
          new IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                _webview.launch(
                  _videoUrl,
                  rect: new Rect.fromLTWH(
                      0.0,
                      0.0,
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height/2),
                );
              }),
        ],
      )),
      floatingActionButton: new FloatingActionButton(
        onPressed:
            _controller.value.isPlaying ? _controller.pause : _controller.play,
        child: new Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
