import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instudy/pages/auth/auth_page.dart';
import 'package:instudy/provider/course_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double height = 0;
  bool animateLogo = false;
  bool showContainer = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().fetchCourses();
      // Provider.of<CourseProvider>(context, listen: false).fetchCourses();
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          height = MediaQuery.sizeOf(context).height;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.scale(
              scale: 3,
              child: AnimatedContainer(
                  height: height,
                  onEnd: () {
                    showContainer = true;
                    setState(() {});
                    Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        animateLogo = true;
                      });
                    });
                  },
                  curve: Curves.easeInSine,
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                    color: Colors.black,
                  ),
                  duration: const Duration(milliseconds: 500)),
            ),
          ),
          Visibility(
            visible: showContainer,
            child: AnimatedSlide(
                offset: Offset(0, animateLogo ? 0 : 1.3),
                curve: Curves.elasticOut,
                onEnd: () {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>const AuthPage()));
                  });
                },
                duration: const Duration(milliseconds: 1500),
                child: Hero(
                    tag: "logo",
                    child: SvgPicture.asset("assets/icons/logo.svg"))),
          ),
          Visibility(
            visible: showContainer,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.38,
                width: double.maxFinite,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
