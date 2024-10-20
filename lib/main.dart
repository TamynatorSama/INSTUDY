import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instudy/pages/splash_screen.dart';
import 'package:instudy/provider/course_provider.dart';
import 'package:instudy/repo/auth_repo.dart';
import 'package:instudy/utils/app_theme.dart';
import 'package:instudy/utils/local_storage.dart';
import 'package:provider/provider.dart';
import 'package:instudy/utils/network_request_helper/dio_base.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  Storage.initStorage();
  AuthRepo.initApp();
  AppNetworkRequest.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (context) => CourseProvider(),
        
      ),
  ],child: const MainApp(),));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen()
      // home: const RoutingPage(),
    );
  }
}
