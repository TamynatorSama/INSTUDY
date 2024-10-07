import 'package:flutter/material.dart';
import 'package:instudy/pages/bookmark/bookmark.dart';
import 'package:instudy/pages/profile/profile_page.dart';
import 'package:instudy/routing_page.dart';
import 'package:instudy/utils/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RoutingPage(),
    );
  }
}
