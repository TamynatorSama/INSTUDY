import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/pages/course_listing/widgets/content_note.dart';
import 'package:instudy/pages/course_listing/widgets/content_options.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CourseContentHolder extends StatefulWidget {
  final int value;
  const CourseContentHolder({super.key, required this.value});

  @override
  State<CourseContentHolder> createState() => _CourseContentHolderState();
}

class _CourseContentHolderState extends State<CourseContentHolder> {
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: ValueKey("${widget.value}"),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                        ),
                        const Gap(6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "MET 101",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const Gap(3),
                                  Expanded(
                                    child: Text(
                                      "Hardness of Materials",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  )
                                ],
                              ),
                              const Gap(5),
                              Wrap(
                                spacing: 10,
                                children: [
                                  videoInfo(context,
                                      icon: "assets/icons/small_user.svg",
                                      value: "Prof. john"),
                                  videoInfo(context,
                                      icon:
                                          "assets/icons/small_video_camera.svg",
                                      value: "1 of 5"),
                                  videoInfo(context, value: "5 hours ago"),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  
                  IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: ()=>openMoreOptions(context),
                              icon: SvgPicture.asset("assets/icons/ellipse.svg")),
                  
                ],
              ),
            ),
            const Gap(12),
            Container(
              width: double.maxFinite,
              color: AppColors.accentColor,
              height: MediaQuery.sizeOf(context).height * 0.4,
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        children: [
                          IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () =>showContentNotes(context),
                              icon: SvgPicture.asset(
                                "assets/icons/note.svg",
                                width: 24,
                              )),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              "assets/icons/download.svg",
                              width: 24,
                            ),
                          ),
                          IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                "assets/icons/bookmark.svg",
                                width: 24,
                              )),
                        ],
                      ),
                      TextButton(
                        style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(1))),
                        onPressed: (){},
                        child: Text(
                                          "? Ask a Question",
                                          style:
                                              Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 8),
                                        ),
                      ),
                      
                    ],
                  ),
                  const Gap(13),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/icons/cc.svg"),
                      const Gap(4),
                      const Text("Today we are going to learn about the hardness of ")
                    ],
                  ),
                  const Gap(4),
                  Text("...more",style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 12,color: AppColors.textColorDark2),)
                ],
              ),
            ),
            const Gap(48),
          ],
        ),
        onVisibilityChanged: (info) {
          print(info);
        });
  }
}

Widget videoInfo(BuildContext context,
        {String? icon, required String value}) =>
    IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            SvgPicture.asset(icon),
            const Gap(5),
          ],
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textColorDark2),
          )
        ],
      ),
    );
