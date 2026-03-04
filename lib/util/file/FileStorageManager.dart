import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileStorageManager {
  static final FileStorageManager _instance = FileStorageManager._internal();

  factory FileStorageManager() => _instance;

  FileStorageManager._internal();

  //   Future<String> getDirectoryPath() async {
  //     switch(type) {
  //       case StorageTypeEnum.cache: getApplicationDocumentsDirectory();
  //       case StorageTypeEnum.temp: getApplicationSupportDirectory()
  //     }
  //   }
  //   Future<String> getFilePath(StorageTypeEnum type, String fileName) async {
  //
  // }
  //
  //   Future<bool> isFileExist(StorageTypeEnum type, String fileName) {}
  // }
}
