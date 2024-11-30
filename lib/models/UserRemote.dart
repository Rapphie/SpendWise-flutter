class UserRemote {
  String nickname;
  String groupid;

  UserRemote({
    required this.nickname,
    required this.groupid,
  });

  UserRemote.fromJson(Map<String, Object?> json)
      : this(
            nickname: json['nickname']! as String,
            groupid: json['groupid']! as String);

  UserRemote copyWith({
    String? nickname,
    String? groupid,
  }) {
    return UserRemote(
        nickname: nickname ?? this.nickname, groupid: this.groupid);
  }

  Map<String, Object?> toJson() {
    return {
      'nickname': nickname,
      'groupid': groupid,
    };
  }
}
