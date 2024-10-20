import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/pages/bookmark/bookmark.dart';
import 'package:instudy/pages/course_listing/course_listing.dart';
import 'package:instudy/pages/profile/profile_page.dart';
import 'package:instudy/pages/search/search_page.dart';
import 'package:instudy/pages/videos/class_video.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:instudy/utils/navigator_controller.dart';

class RoutingPage extends StatelessWidget {
  const RoutingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: navController,
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
        
        title: Text(
          "INSTUDY",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 1,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: AppColors.accentColor,
        actions: [
          SvgPicture.asset("assets/icons/notification.svg"),
          const Gap(20),
        ],
      ),
            body: const [CourseContentListing(),SearchPage(),BookmarkPage(),ClassVideoPage(),ProfilePage()][navController.selectedIndex],
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                  top: 20, bottom: MediaQuery.paddingOf(context).bottom + 20,right: 20,left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _bottomIconBuilder(
                      onChange: () => navController.updateIndex(0),
                      isSelected: navController.selectedIndex == 0,
                      selectedIcon: "assets/icons/black_home.svg",
                      defaultIcon: "assets/icons/home.svg"),
                  _bottomIconBuilder(
                      onChange: () => navController.updateIndex(1),
                      isSelected: navController.selectedIndex == 1,
                      selectedIcon: "assets/icons/black_search.svg",
                      defaultIcon: "assets/icons/search.svg"),
                  _bottomIconBuilder(
                      onChange: () => navController.updateIndex(2),
                      isSelected: navController.selectedIndex == 2,
                      selectedIcon: "assets/icons/black_bookmark.svg",
                      defaultIcon: "assets/icons/book_mark_bottom.svg"),
                  _bottomIconBuilder(
                      onChange: () => navController.updateIndex(3),
                      isSelected: navController.selectedIndex == 3,
                      selectedIcon: "assets/icons/black_play.svg",
                      defaultIcon: "assets/icons/play.svg"),
                  _bottomIconBuilder(
                      onChange: () => navController.updateIndex(4),
                      isSelected: navController.selectedIndex == 4,
                      selectedIcon: "assets/icons/black_profile.svg",
                      defaultIcon: "assets/icons/user.svg"),
                ],
              ),
            ),
          );
        });
  }
}

Widget _bottomIconBuilder({
  bool isSelected = false,
  required String selectedIcon,
  required String defaultIcon,
  required Function() onChange,
}) =>
    InkWell(
      onTap: onChange,
      child: AnimatedSwitcher(
        duration: const Duration(
          milliseconds: 400,
        ),
        transitionBuilder: (child, animation) {
          // print(animation.status.);
          return ScaleTransition(
        scale: animation,
        child: child,
       );
   
        },
        child: isSelected
            ? SvgPicture.asset(selectedIcon)
            : SvgPicture.asset(defaultIcon),
      ),
    );
