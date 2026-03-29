import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_instagram/stateManager/LikeChangeNotifier.dart';
import 'package:flutter_instagram/util/firestore/FireStoreManager.dart';
import 'package:flutter_instagram/util/http/HttpManager.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_instagram/data/ReelsData.dart';
import 'package:flutter_instagram/widgets/video/VideoPlayerWidget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
  final PageController _pageController = PageController(initialPage: 0);
  final LikeChangeNotifier _likeChangeNotifier = LikeChangeNotifier();
  late List<ReelsData> _reelsData = [
    ReelsData(
      id: '',
      userId: '',
      contents: '',
      video: '',
      nickname: '',
      likes: 0,
      chatCount: 0,
      rePost: 0,
      dm: 0,
    ),
  ];

  @override
  void initState() {
    _loadMoreData();
    _pageController.addListener(() {
      //_pageController.page
      if (_pageController.position.pixels >=
              _pageController.position.maxScrollExtent &&
          !_pageController.position.outOfRange) {
        // 끝에 도달했을 때 실행할 동작 (예: 데이터 더 불러오기)
        print("리스트 끝에 도달했습니다.");
        _loadMoreData();
      }
    });
    super.initState();
  }

  void _loadMoreData() {
    Future<List<ReelsData>> futureReelsData = FireStoreManager.instance
        .getReelsData();

    futureReelsData
        .then((val) {
          setState(() {
            _reelsData = val;

            // for (data in val.)
          });
        })
        .catchError((error) {
          print('error: $error');
        });
  }

  @override
  void dispose() {
    _pageController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ChangeNotifierProvider(
        create: (context) => _likeChangeNotifier,
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: _reelsData.length,
          itemBuilder: (context, index) {
            return VideoPlayerWidget(
              key: ValueKey(_reelsData[index]),
              reelsData: _reelsData[index],
            );
            // );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        height: 50,
        child: IconButton(
          icon: Icon(Icons.slideshow),
          color: Colors.white,
          onPressed: () {
            HttpManager.instance.postData();
          },
        ),
      ),
    );
  }
}
