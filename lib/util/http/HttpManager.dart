import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import '../String/RandomUUID.dart';

class HttpManager {
  static final HttpManager instance = HttpManager._internal();
  final dio = Dio();
  bool _isPicking = false;

  HttpManager._internal();

  Future<void> postData() async {
    try {
      final response = await dio.post(
        "https://orange-violet-79d6.levelupcoding12.workers.dev/uploads/reels",
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {'userId': 'sf90s-sdf87-we76s', "contentType": "video/mp4"},
      );
      print(response.data);
      await putRequest(url: response.data["uploadUrl"]);
      await postToFirebase();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> uploadFile(String filePath) async {
    final file = await MultipartFile.fromFile(filePath);
    final formData = FormData.fromMap({'file': file});

    final response = await dio.post(
      'https://example.com/upload',
      data: formData,
    );
    print('File uploaded: ${response.statusCode}');
  }

  // PUT 요청
  Future<void> putRequest({required String url}) async {
    if (_isPicking) return;
    _isPicking = true;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withData: false, // 웹에서는 데이터를 바이트로 가져와야 함
      );

      // ByteData byteData = await rootBundle.load('IMG_3297.mp4');
      // 2. ByteData를 Uint8List(bytes)로 변환
      // Uint8List bytes = byteData.buffer.asUint8List();
      if (result != null) {
        final filePath = result.files.single.path.toString();
        File file = File(filePath);
        Uint8List fileBytes = await file.readAsBytes();

        final response = await dio.put(
          url,
          data: fileBytes,
          options: Options(headers: {"Content-Type": "video/mp4"}),
          onSendProgress: (sent, total) {
            print("업로드 중: ${(sent / total * 100).toStringAsFixed(0)}%");
          },
        );
        print('응답 데이터: ${response.toString()}');
        print('응답 데이터: ${response.statusCode}');
      } else {
        print('result none');
      }
    } catch (e) {
      print('에러: $e');
    } finally {
      // 작업이 끝나면 다시 false로 변경
      _isPicking = false;
    }
  }

  Future<void> postToFirebase() async {
    try {
      final response = await dio.post(
        "https://orange-violet-79d6.levelupcoding12.workers.dev/uploads/reels/complete",
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'reelId': RandomUUID().getReelsId(),
          'userId': 'sf90s-sdf87-we76s',
          'nickname': 'dodo',
          'contents': 'cocoding',
        },
      );
      print(response.data);
      print('응답 데이터3: ${response.toString()}');
      print('응답 데이터3: ${response.statusCode}');
    } catch (e) {
      print('Error end: ${e}');
    }
  }
}
