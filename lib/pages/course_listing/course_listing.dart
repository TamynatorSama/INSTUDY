import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/pages/course_listing/course_holder.dart';
import 'package:instudy/utils/app_colors.dart';

class CourseContentListing extends StatelessWidget {
  const CourseContentListing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("INSTUDY",style: Theme.of(context).textTheme.titleLarge,),
      actions: [
        SvgPicture.asset("assets/icons/notification.svg"),
        const Gap(24),
      ],
      elevation: 1,
      scrolledUnderElevation: 0,
      shadowColor: AppColors.accentColor,
      ),
      body: ListView.builder(
        itemCount: 2,
        padding: const EdgeInsets.only(top: 24),
        itemBuilder: (context,index)=> CourseContentHolder(value: index,)),
    );
  }
}