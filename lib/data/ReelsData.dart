class ReelsData {
  String id;
  String userId;
  String contents;
  String video;
  String nickname;
  int likes;
  int chatCount;
  int rePost;
  int dm;

  ReelsData({
    required this.id,
    required this.userId,
    required this.contents,
    required this.video,
    required this.nickname,
    required this.likes,
    required this.chatCount,
    required this.rePost,
    required this.dm,
  });

  ReelsData copyWith({
    String? id,
    String? userId,
    String? contents,
    String? video,
    String? nickname,
    int? likes,
    int? chatCount,
    int? rePost,
    int? dm,
  }) {
    return ReelsData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      contents: contents ?? this.contents,
      video: video ?? this.video,
      nickname: nickname ?? this.nickname,
      likes: likes ?? this.likes,
      chatCount: chatCount ?? this.chatCount,
      rePost: rePost ?? this.rePost,
      dm: dm ?? this.dm,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'userId': this.userId,
      'contents': this.contents,
      'video': this.video,
      'nickname': this.nickname,
      'likes': this.likes,
      'chatCount': this.chatCount,
      'rePost': this.rePost,
      'dm': this.dm,
    };
  }

  factory ReelsData.fromMap(Map<String, dynamic> map) {
    return ReelsData(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      contents: map['contents'] as String? ?? '',
      video: map['video'] as String? ?? '',
      nickname: map['nickname'] as String? ?? '',
      likes: map['likes'] as int? ?? 0,
      chatCount: map['chatCount'] as int? ?? 0,
      rePost: map['rePost'] as int? ?? 0,
      dm: map['dm'] as int? ?? 0,
    );
  }
}
