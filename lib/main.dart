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
  final ScrollController _scrollController = ScrollController();
  List<String> items = [
    'https://vt.tumblr.com/tumblr_o600t8hzf51qcbnq0_480.mp4',
    'https://vt.tumblr.com/tumblr_o600t8hzf51qcbnq0_480.mp4',
    'https://vt.tumblr.com/tumblr_o600t8hzf51qcbnq0_480.mp4',
    'https://vt.tumblr.com/tumblr_o600t8hzf51qcbnq0_480.mp4',
    'https://vt.tumblr.com/tumblr_o600t8hzf51qcbnq0_480.mp4',
    'https://vt.tumblr.com/tumblr_o600t8hzf51qcbnq0_480.mp4',
  ];

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        // 끝에 도달했을 때 실행할 동작 (예: 데이터 더 불러오기)
        print("리스트 끝에 도달했습니다.");
        _loadMoreData();
      }
    });
    super.initState();
  }

  void _loadMoreData() {
    // 데이터 추가 로직
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: PageController(initialPage: 0),
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return VideoPlayerWidget(
            key: ValueKey(items[index]),
            videoController: CustomVideoController(videoUrl: items[index]),
          );
          // );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        height: 50,
        child: IconButton(
          icon: Icon(Icons.slideshow),
          color: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
