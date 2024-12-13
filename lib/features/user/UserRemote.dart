import 'package:cloud_firestore/cloud_firestore.dart';

class UserRemote {
  String nickname;
  Timestamp createdOn;
  Timestamp updatedOn;
  List<String> groups;

  UserRemote({
    this.nickname = 'User',
    required this.createdOn,
    required this.updatedOn,
    required this.groups,
  });

  UserRemote.fromJson(Map<String, Object?> json)
      : this(
          nickname: json['nickname'] as String,
          createdOn: json['createdOn']! as Timestamp,
          updatedOn: json['updatedOn']! as Timestamp,
          groups: List.from(json['groups']! as List<dynamic>),
        );

  UserRemote copyWith({
    String? nickname,
    Timestamp? createdOn,
    Timestamp? updatedOn,
    List<String>? groups,
  }) {
    return UserRemote(
        nickname: nickname ?? this.nickname,
        createdOn: createdOn ?? this.createdOn,
        updatedOn: createdOn ?? this.createdOn,
        groups: groups ?? this.groups);
  }

  Map<String, Object?> toJson() {
    return {
      'nickname': nickname,
      'createdOn': createdOn,
      'updatedOn': createdOn,
      'groups': groups,
    };
  }
}
