import 'package:flutter/material.dart';
import 'package:instudy/pages/videos/class_video.dart';
import 'package:instudy/pages/videos/class_video_single_view.dart';
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
      home: const ClassVideoSingleView(),
    );
  }
}
