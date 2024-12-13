import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/app.dart';
import 'firebase_options.dart';
import 'package:spend_wise/features/group/presentation/pages/group_page.dart';
import 'package:spend_wise/features/group/presentation/pages/create_group_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/groups': (context) => GroupPage(),
        '/create_group': (context) => CreateGroupPage(),
      },
    );
  }
}
