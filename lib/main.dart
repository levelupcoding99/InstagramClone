import 'package:flutter/material.dart';
import 'package:flutter_instagram/widgets/video/CustomVideoController.dart';
import 'package:flutter_instagram/widgets/video/VideoPlayerWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Reels());
  }
}

class Reels extends StatefulWidget {
  @override
  State<Reels> createState() {
    return _Reels();
  }
}

class _Reels extends State<Reels> {
  late CustomVideoController _controller;

  @override
  void initState() {
    _controller = CustomVideoController(
      videoUrl: 'https://vt.tumblr.com/tumblr_o600t8hzf51qcbnq0_480.mp4',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoPlayerWidget(videoController: _controller),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: IconButton(
          icon: Icon(Icons.slideshow),
          color: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
