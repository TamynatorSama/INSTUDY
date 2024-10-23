import 'dart:async';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:instudy/models/course_listing_model.dart';
import 'package:instudy/pages/course_listing/widgets/content_note.dart';
import 'package:instudy/pages/course_listing/widgets/content_options.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CourseContentHolder extends StatefulWidget {
  final int? value;
  final CourseListingModel? video;
  const CourseContentHolder({super.key, this.value, this.video});

  @override
  State<CourseContentHolder> createState() => _CourseContentHolderState();
}

class _CourseContentHolderState extends State<CourseContentHolder> {
  late CachedVideoPlayerPlusController _controller;
  bool openOpacity = false;
  double visibleFraction = 0;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    if (widget.video != null) {
      _controller = CachedVideoPlayerPlusController.networkUrl(
          Uri.parse(widget.video!.video.s3Link!))
        ..initialize().then((_) {
          _controller
              .seekTo(Duration(seconds: widget.video!.startTime.toInt()));
          if (mounted) {
            setState(() {});
          }
        })
        ..addListener((replay));
    }
  }

  replay() {
    if (_controller.value.position.inSeconds >= widget.video!.endTime.toInt()) {
      _controller.seekTo(Duration(seconds: widget.video!.startTime.toInt()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: ValueKey("${widget.value ?? widget.video?.id}"),
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
                                    widget.video?.course.name ?? "MET 101",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const Gap(3),
                                  Expanded(
                                    child: Text(
                                      widget.video?.course.title ??
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
                                      value: widget.video?.course.instructor ??
                                          "Prof. john"),
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
                      onPressed: () => openMoreOptions(context),
                      icon: SvgPicture.asset("assets/icons/ellipse.svg")),
                ],
              ),
            ),
            const Gap(12),
            widget.video ==null?Container(
                      width: double.maxFinite,
                      color: AppColors.accentColor,
                      height: MediaQuery.sizeOf(context).height * 0.4,):
            AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return GestureDetector(
                    onTap: () {
                      if (visibleFraction < 0.7) {
                        return;
                      }
                      if (isPaused) {
                        _controller.play();
                      } else {
                        _controller.pause();
                      }
                      isPaused = !isPaused;
                      openOpacity = true;
                      setState(() {});
                      Timer(const Duration(milliseconds: 400), () {
                        print("test");
                        openOpacity = false;
                        setState(() {});
                      });
                    },
                    child: Container(
                      width: double.maxFinite,
                      color: AppColors.accentColor,
                      height: MediaQuery.sizeOf(context).height * 0.4,
                      child: Stack(
                        children: [
                           CachedVideoPlayerPlus(_controller),
                              
                          Align(
                              alignment: Alignment.center,
                              child: AnimatedOpacity(
                                opacity: openOpacity ? 1 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: AnimatedScale(
                                  scale: openOpacity ? 2 : 1,
                                  curve: Curves.easeInSine,
                                  duration: const Duration(milliseconds: 400),
                                  child: SvgPicture.string(isPaused
                                      ? '''<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><g fill="none" fill-rule="evenodd"><path d="m12.593 23.258l-.011.002l-.071.035l-.02.004l-.014-.004l-.071-.035q-.016-.005-.024.005l-.004.01l-.017.428l.005.02l.01.013l.104.074l.015.004l.012-.004l.104-.074l.012-.016l.004-.017l-.017-.427q-.004-.016-.017-.018m.265-.113l-.013.002l-.185.093l-.01.01l-.003.011l.018.43l.005.012l.008.007l.201.093q.019.005.029-.008l.004-.014l-.034-.614q-.005-.018-.02-.022m-.715.002a.02.02 0 0 0-.027.006l-.006.014l-.034.614q.001.018.017.024l.015-.002l.201-.093l.01-.008l.004-.011l.017-.43l-.003-.012l-.01-.01z"/><path fill="white" d="M5.669 4.76a1.47 1.47 0 0 1 2.04-1.177c1.062.454 3.442 1.533 6.462 3.276c3.021 1.744 5.146 3.267 6.069 3.958c.788.591.79 1.763.001 2.356c-.914.687-3.013 2.19-6.07 3.956c-3.06 1.766-5.412 2.832-6.464 3.28c-.906.387-1.92-.2-2.038-1.177c-.138-1.142-.396-3.735-.396-7.237c0-3.5.257-6.092.396-7.235"/></g></svg>'''
                                      : '''<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="white" d="M2 6c0-1.886 0-2.828.586-3.414S4.114 2 6 2s2.828 0 3.414.586S10 4.114 10 6v12c0 1.886 0 2.828-.586 3.414S7.886 22 6 22s-2.828 0-3.414-.586S2 19.886 2 18zm12 0c0-1.886 0-2.828.586-3.414S16.114 2 18 2s2.828 0 3.414.586S22 4.114 22 6v12c0 1.886 0 2.828-.586 3.414S19.886 22 18 22s-2.828 0-3.414-.586S14 19.886 14 18z"/></svg>'''),
                                ),
                              )),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Builder(
                                builder: (context) {
                                  String? trans = widget.video?.transcript.where((e)=>_controller.value.position.inSeconds >= e.startTime.toInt() && _controller.value.position.inSeconds <= e.endTime.toInt()).firstOrNull?.transcript;
                                  return trans ==null?const Offstage(): Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: ShapeDecoration(
                                      color: Colors.black.withOpacity(0.8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                      child: Text(trans,textAlign: TextAlign.center,style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 11,color: Colors.white),),
                                  );
                                }
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                }),
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
                              onPressed: () => showContentNotes(context),
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
                        style: const ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.all(1))),
                        onPressed: () {},
                        child: Text(
                          "? Ask a Question",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 8),
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
                      const Text(
                          "Today we are going to learn about the hardness of ")
                    ],
                  ),
                  const Gap(4),
                  Text(
                    "...more",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 12, color: AppColors.textColorDark2),
                  )
                ],
              ),
            ),
            const Gap(48),
          ],
        ),
        onVisibilityChanged: (info) {
          visibleFraction = info.visibleFraction;
          if (info.visibleFraction >= 0.7) {
            _controller.play();
          } else {
            _controller.pause();
          }
        });
  }
}

Widget videoInfo(BuildContext context, {String? icon, required String value}) =>
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
