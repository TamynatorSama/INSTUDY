import 'package:flutter/material.dart';
import 'package:instudy/pages/course_listing/course_holder.dart';

class CourseContentListing extends StatelessWidget {
  const CourseContentListing({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 2,
        padding: const EdgeInsets.only(top: 24),
        itemBuilder: (context, index) => CourseContentHolder(
              value: index,
            ));
  }
}
