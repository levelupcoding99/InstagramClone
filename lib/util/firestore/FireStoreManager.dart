import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram/data/ReelsData.dart';
import 'CollectionEnum.dart';

class FireStoreManager {
  static final FireStoreManager instance = FireStoreManager._internal();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FireStoreManager._internal();

  Future<List<ReelsData>> getReelsData() async {
    var collection = await fireStore
        .collection(CollectionEnum.ReelsInfo.name)
        .get();

    List<ReelsData> reels = collection.docs.map((doc) {
      return ReelsData.fromMap(doc.data());
    }).toList();
    return reels;
  }

  void clickedLike(String doc, int likeCount) {
    fireStore.collection(CollectionEnum.ReelsInfo.name).doc(doc).update({
      'likes': FieldValue.increment(likeCount),
    });
  }
}
