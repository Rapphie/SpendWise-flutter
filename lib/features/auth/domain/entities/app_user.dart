class AppUser {
  final String uid;
  final String email;
  final String name;
  
  final List<String> groups;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.groups,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'groups': groups,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      name: jsonUser['name'],
      groups: jsonUser['groups'],
    );
  }
}
