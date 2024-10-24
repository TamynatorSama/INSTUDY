import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:instudy/pages/course_listing/course_holder.dart';
import 'package:instudy/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CourseContentListing extends StatefulWidget {
  const CourseContentListing({super.key});

  @override
  State<CourseContentListing> createState() => _CourseContentListingState();
}

class _CourseContentListingState extends State<CourseContentListing> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (context.read<DashboardProvider>().videos.isEmpty) {
        context.read<DashboardProvider>().fetchCourseListing();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (_, ref, __) {
        return RefreshIndicator(
          onRefresh: ()=>context.read<DashboardProvider>().fetchCourseListing(),
          child: Skeletonizer(
            enabled: ref.isLoading,
            child: ListView.builder(
                itemCount: ref.isLoading ? 1 : ref.videos.length,
                padding: const EdgeInsets.only(top: 24),
                itemBuilder: (context, index) => ref.isLoading
                    ? CourseContentHolder(
                        value: index,
                      )
                    : CourseContentHolder(
                        video: ref.videos.elementAt(index),
                      )),
          ),
        );
      },
    );
  }
}
