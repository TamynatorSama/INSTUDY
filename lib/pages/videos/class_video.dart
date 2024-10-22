import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:instudy/models/course_video.dart';
import 'package:instudy/pages/course_listing/course_holder.dart';
import 'package:instudy/pages/videos/class_video_single_view.dart';
import 'package:instudy/provider/course_video_listing_provider.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ClassVideoPage extends StatefulWidget {
  const ClassVideoPage({super.key});

  @override
  State<ClassVideoPage> createState() => _ClassVideoPageState();
}

class _ClassVideoPageState extends State<ClassVideoPage> {
  @override
  void initState() {
    listController = ScrollController()..addListener(paginationTrigger);
    SchedulerBinding.instance.addPostFrameCallback(
        (_) => context.read<CourseVideoListingProvider>().fetchCourseVideos());
    super.initState();
  }

  late ScrollController listController;

  paginationTrigger() async {
    if (listController.offset >= listController.position.maxScrollExtent - 50) {
      CourseVideoListingProvider provide = context.read();
      if (!provide.isPaginating || !provide.isLoading) {
        await provide.fetchCourseVideos(isRefresh: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseVideoListingProvider>(
      builder: (_, provider, p) {
        return Column(
          children: [
            const Gap(24),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            filled: true,
                            prefixIcon: IntrinsicWidth(
                              child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: SvgPicture.asset(
                                    "assets/icons/search_large.svg",
                                    width: 24,
                                  )),
                            ),
                            hintText: "Search  with keyword",
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                            // fillColor: Colors.blueAccent,
                            fillColor: const Color(0xffFAFAFA),
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(44)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(44)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(44)),
                            errorBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(44)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(44))),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    const Gap(10),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.pop(context),
                      icon: SvgPicture.asset(
                        "assets/icons/tune.svg",
                        width: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(31),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "RECENT CLASS VIDEOS".toUpperCase(),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 10, color: AppColors.textColorDark2),
                    ),
                    Text(
                      "${provider.videos.length} Class Video${provider.videos.length>1?'s':''}",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 10, color: AppColors.textColorDark2),
                    ),
                  ],
                ),
              ),
              const Gap(18),
              const Divider(),
              const Gap(18),
            ]),
            Expanded(
                child: Skeletonizer(
              enabled: (provider.isLoading || !provider.hasLoaded) && provider.videos.isEmpty,
              child: ListView.separated(
                  controller: listController,
                  itemCount: (provider.isLoading || !provider.hasLoaded) && provider.videos.isEmpty ? 2 : provider.videos.length,
                  separatorBuilder: (context, index) => const Column(
                        children: [ Gap(24), Divider(), Gap(24)],
                      ),
                  itemBuilder: (context, index) => (provider.isLoading || !provider.hasLoaded) && provider.videos.isEmpty
                      ? const CourseVideoHolder()
                      : CourseVideoHolder(course: provider.videos.elementAt(index))),
            )),
          ],
        );
      },
    );
  }
}

class CourseVideoHolder extends StatefulWidget {
  final CourseVideo? course;
  const CourseVideoHolder({super.key, this.course});

  @override
  State<CourseVideoHolder> createState() => _CourseVideoHolderState();
}

class _CourseVideoHolderState extends State<CourseVideoHolder> {
  Uint8List? thumbnail;

  @override
  initState() {
    super.initState();
    try {
      SchedulerBinding.instance.addPostFrameCallback((_) => getThumbNail());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  getThumbNail() async {
    if (widget.course != null) {
      thumbnail = await Future.sync(() => widget.course!.getThumbnail(null))
          .then((val) {
        if(mounted){
          setState(() {});
        }
        return val;
      });
      // thumbnail = await compute(widget.course!.getThumbnail, "value");
      // print(thumbnail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.course ==null?null: () =>  Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ClassVideoSingleView(course:widget.course!,))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: thumbnail != null
                      ? DecorationImage(
                          image: MemoryImage(thumbnail!), fit: BoxFit.cover)
                      : null,
                  color: AppColors.accentColor),
            ),
            const Gap(13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.course?.course.name ?? "MET 101",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 10, color: AppColors.textColorDark2),
                  ),
                  const Gap(4),
                  Text(
                    widget.course?.course.title ?? "Hardness of Materials",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const Gap(4),
                  Text(
                    "Full Class Video",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 10, color: AppColors.textColorDark2),
                  ),
                  const Gap(16),
                  Wrap(
                    spacing: 10,
                    children: [
                      videoInfo(context,
                          icon: "assets/icons/small_user.svg",
                          value:
                              widget.course?.course.instructor ?? "Prof. john"),
                      // videoInfo(context,
                      //     icon: "assets/icons/small_video_camera.svg",
                      //     value: "1 of 5"),
                      videoInfo(context,
                          value: GetTimeAgo.parse(
                              widget.course?.createdAt ?? DateTime.now())),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Widget _buildClassVideoHolder(BuildContext context, {CourseVideo? course}) {
  
//   return InkWell(
//     onTap: () async {
//       print(await course?.getThumbnail.call(null));
//     },
//     // onTap: () => Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //         builder: (context) => const ClassVideoSingleView())),
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Row(
//         children: [
//           Container(
//             height: 100,
//             width: 100,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 image:thumbnail !=null?  DecorationImage(image: MemoryImage(thumbnail)):,
//                 color: AppColors.accentColor),
//           ),
//           const Gap(13),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   course?.course.name ?? "MET 101",
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleSmall
//                       ?.copyWith(fontSize: 10, color: AppColors.textColorDark2),
//                 ),
//                 const Gap(4),
//                 Text(
//                   course?.course.title ?? "Hardness of Materials",
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.displayMedium,
//                 ),
//                 const Gap(4),
//                 Text(
//                   "Full Class Video",
//                   style: Theme.of(context)
//                       .textTheme
//                       .displayMedium
//                       ?.copyWith(fontSize: 10, color: AppColors.textColorDark2),
//                 ),
//                 const Gap(16),
//                 Wrap(
//                   spacing: 10,
//                   children: [
//                     videoInfo(context,
//                         icon: "assets/icons/small_user.svg",
//                         value: course?.course.instructor ?? "Prof. john"),
//                     // videoInfo(context,
//                     //     icon: "assets/icons/small_video_camera.svg",
//                     //     value: "1 of 5"),
//                     videoInfo(context,
//                         value: GetTimeAgo.parse(
//                             course?.createdAt ?? DateTime.now())),
//                   ],
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     ),
//   );

// }
