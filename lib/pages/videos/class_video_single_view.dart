import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:instudy/models/course_video.dart';
import 'package:instudy/pages/course_listing/course_holder.dart';
import 'package:instudy/pages/videos/widgets/transcript_viewer.dart';
import 'package:instudy/provider/course_video_listing_provider.dart';
import 'package:instudy/usables/expandable_scrollable_widget.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:instudy/utils/video_player.dart';
import 'package:provider/provider.dart';

class ClassVideoSingleView extends StatefulWidget {
  final CourseVideo course;
  const ClassVideoSingleView({super.key, required this.course});

  @override
  State<ClassVideoSingleView> createState() => _ClassVideoSingleViewState();
}

class _ClassVideoSingleViewState extends State<ClassVideoSingleView> {
  // late CachedVideoPlayerPlusController _controller;
  double position = 0;
  final GlobalKey _containerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.course.transcriptReady) {
        context
            .read<CourseVideoListingProvider>()
            .fetchTranscript(context, courseID: widget.course.id);
      }
      getposition();
    });
  }

  getposition() {
    RenderBox box =
        _containerKey.currentContext!.findRenderObject() as RenderBox;

    position = box.localToGlobal(Offset.zero).dy;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "INSTUDY",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 1,
        scrolledUnderElevation: 0,
        shadowColor: AppColors.accentColor,
      ),
      body: Consumer<CourseVideoListingProvider>(
        builder: (_, ref, __) {
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async =>
                    ref.fetchTranscript(context, courseID: widget.course.id),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(24),
                          InkWell(
                              // visualDensity: VisualDensity.compact,
                              // style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(1))),
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.arrow_back)),
                          const Gap(10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.course.course.title,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const Gap(5),
                              Expanded(
                                child: Text(
                                  "Full Class Video",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              )
                            ],
                          ),
                          const Gap(7),
                          Wrap(
                            spacing: 10,
                            children: [
                              videoInfo(context,
                                  icon: "assets/icons/small_user.svg",
                                  value: widget.course.course.instructor),
                              videoInfo(context,
                                  value: GetTimeAgo.parse(widget.course.createdAt)),
                            ],
                          ),
                          const Gap(20),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.textColorDark,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: MediaQuery.sizeOf(context).height * 0.3,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  color: AppColors.accentColor.withOpacity(0.3),
                                ),
                               
                              ),
                              // if(_controller.value.)
                            ],
                          ),
                          const Gap(20),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "Audio Transcript",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                          const Gap(13),
                          TextFormField(
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
                                hintText: "Search  Transcript",
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
                        ],
                      ),
                    ),
                    const Gap(10),
                    const Divider(),
                    const Gap(20),
                    Expanded(
                      child: !widget.course.transcriptReady &&
                              !ref.transcripts.containsKey(widget.course.id) &&
                              !ref.isLoadingTranscript
                          ? const ExpandableScrollableWidget(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Center(
                                child: Text(
                                  "Transcript for this video is still processing,\n check back later!",
                                  textAlign: TextAlign.center,
                                ),
                              ))
                          : TranscriptViewer(
                              course: widget.course,
                              controller: ref.controller,
                            ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: position,
                child: Container(
                                  key: _containerKey,
                                  width: double.maxFinite,
                                  height: MediaQuery.sizeOf(context).height * 0.3,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16)),
                                    
                                  ),
                                  child: VideoPlayer(
                                    transcripts: ref.transcripts[widget.course.id],
                                    videoUrl: widget.course.s3Link!,
                                  ),
                                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
