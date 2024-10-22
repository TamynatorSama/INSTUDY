import 'dart:async';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gap/gap.dart';
import 'package:instudy/models/course_video.dart';
import 'package:instudy/models/video_transcript.dart';
import 'package:instudy/provider/course_video_listing_provider.dart';
import 'package:instudy/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TranscriptViewer extends StatefulWidget {
  final CourseVideo course;
  final CachedVideoPlayerPlusController? controller;
  const TranscriptViewer(
      {super.key, required this.course, required this.controller});

  @override
  State<TranscriptViewer> createState() => _TranscriptViewerState();
}

class _TranscriptViewerState extends State<TranscriptViewer>
    with TickerProviderStateMixin {
  Map<double, TimeFrameInfo> timeFrame = {};
  late ScrollController _scrollController;
  bool goOffStage = false;
  int presentIndex = 0;
  late Timer _newTimer;

  // final ScrollController _minorScrollController = ScrollController();

  @override
  initState() {
    _scrollController = ScrollController();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _newTimer = Timer.periodic(const Duration(seconds: 1), (ticker) {
        Future.delayed(const Duration(seconds: 1), () {
          goOffStage = true;
          if (mounted) {
            setState(() {});
          }
        });
      });
    });
    super.initState();
  }

  moveToTranscript(Duration position) {
    if (_scrollController.hasClients) {
      double positionString = position.inSeconds.toDouble();

      double? frameInfo = timeFrame.values
          .where((e) =>
              (positionString >= e.startTime && positionString < e.endTime))
          .lastOrNull
          ?.endTime;

      if (frameInfo != null) {
        TimeFrameInfo info = timeFrame[frameInfo]!;

        if (info.index == presentIndex) return;
        presentIndex = info.index;
        Future.delayed(Duration.zero,() {
          if(mounted){
            setState(() {});
          }
        });

        double test = timeFrame.values
            .where((e) => e.endTime < info.endTime)
            .fold(0.0, (prev, nxt) => prev + ((nxt.size?.height ?? 0) + 30/2));
        _scrollController.animateTo(test,
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      }
    }
  }

  updateSize(int index, TimeFrameInfo info) {
    if (info.size == null) return;
    timeFrame[info.endTime] = info;
  }

  @override
  void dispose() {
    _newTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseVideoListingProvider>(
      builder: (_, ref, __) {
        return AnimatedBuilder(
            animation: widget.controller!,
            builder: (context, _) {
              moveToTranscript(
                  widget.controller?.value.position ?? Duration.zero);
              return Scrollbar(
                  child: Stack(
                    children: [
                      Offstage(
                      offstage: goOffStage,
                      child: Opacity(
                        opacity: 0,
                        child: Column(
                          children: List.generate(
                              ref.transcripts[widget.course.id]?.transcripts
                                      .length ??
                                  0, (index) {
                            TimedTranscript transcript = ref
                                .transcripts[widget.course.id]!
                                .transcripts[index];
                            return TranscriptHolder(
                                getSize: (size) => updateSize(
                                    index,
                                    TimeFrameInfo(
                                        endTime: transcript.endTime,
                                        index: index,
                                        size: size,
                                        startTime: transcript.startTime)),
                                transcript: transcript,
                                isShowing: index == 0);
                          }),
                        ),
                      ),
                    ),
                    
                      Skeletonizer(
                                      enabled: ref.isLoadingTranscript,
                                      child: ListView.separated(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.paddingOf(context).bottom + 10),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: ref.isLoadingTranscript?(context,index)=>_buildTranscripts(context,timeStamp: index+10,isShowing: index==0,text:"Transcript is loading"): (context, index) {
                          TimedTranscript transcript = ref
                              .transcripts[widget.course.id]!
                              .transcripts[index];
                          return TranscriptHolder(
                              getSize: (size) => updateSize(
                                  index,
                                  TimeFrameInfo(
                                      endTime: transcript.endTime,
                                      index: index,
                                      size: size,
                                      startTime: transcript.startTime)),
                              transcript: transcript,
                              isShowing: index == presentIndex);
                        },
                        separatorBuilder: (context, index) => const Gap(15),
                        itemCount: ref.isLoadingTranscript ?2:ref.transcripts[widget.course.id]
                                ?.transcripts.length ??
                            0),
                                    ),
                    ],
                  ));
            });
      },
    );
  }
}

Widget _buildTranscripts(BuildContext context,
        {required int timeStamp,
        required String text,
        bool isShowing = false}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            constructTimer(timeStamp),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const Gap(8),
          Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: AppColors.accentColor),
                    borderRadius: BorderRadius.circular(14)),
                color: isShowing ? const Color(0xffFAFAFA) : Colors.white),
            child: LayoutBuilder(
                builder: (context, constraints) => ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isShowing ? null : AppColors.textColorDark2),
                      ),
                    )),
          ),
        ],
      ),
    );

String constructTimer(int counter) {
  int hours = (counter / 3600).floor();
  int minutes = ((counter % 3600) / 60).floor();
  int secs = counter % 60;

  return "${hours <= 0 ? "" : hours.toString().padLeft(2, '0')}${hours <= 0 ? "" : ":"}${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
}

class TranscriptHolder extends StatefulWidget {
  final Function(Size? size)? getSize;
  final bool isShowing;
  final TimedTranscript transcript;
  const TranscriptHolder(
      {super.key,
      required this.getSize,
      required this.transcript,
      required this.isShowing});

  @override
  State<TranscriptHolder> createState() => _TranscriptHolderState();
}

class _TranscriptHolderState extends State<TranscriptHolder> {
  GlobalKey key = GlobalKey();
  @override
  initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) => getSize());
    super.initState();
  }

  getSize() {
    if (mounted) {
      RenderBox? box = (key.currentContext?.findRenderObject() as RenderBox?);
      widget.getSize?.call(box?.size);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            constructTimer(widget.transcript.startTime.toInt()),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const Gap(8),
          Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: AppColors.accentColor),
                    borderRadius: BorderRadius.circular(14)),
                color:
                    widget.isShowing ? const Color(0xffFAFAFA) : Colors.white),
            child: LayoutBuilder(
                builder: (context, constraints) => ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
                      child: Text(
                        widget.transcript.transcript,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: widget.isShowing
                                ? null
                                : AppColors.textColorDark2),
                      ),
                    )),
          ),
        ],
      ),
    );
  }
}

class TimeFrameInfo {
  final double startTime;
  final int index;
  final double endTime;
  final Size? size;

  TimeFrameInfo(
      {required this.endTime,
      required this.index,
      this.size,
      required this.startTime});

  @override
  bool operator ==(Object other) =>
      other is TimeFrameInfo &&
      startTime == other.startTime &&
      index == other.index &&
      endTime == other.endTime;

  @override
  int get hashCode => Object.hashAll([startTime, endTime, index]);
}
