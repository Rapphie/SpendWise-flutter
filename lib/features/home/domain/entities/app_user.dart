import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String name;
  final List<String> groups;
  final Timestamp? createdOn;
  final Timestamp? updatedOn;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.groups,
    this.createdOn,
    this.updatedOn,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'groups': groups,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      name: jsonUser['name'],
      groups: List<String>.from(jsonUser['groups']),
      createdOn: jsonUser['createdOn'],
      updatedOn: jsonUser['updatedOn'],
    );
  }
}
