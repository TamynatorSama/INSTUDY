// import 'dart:math';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:instudy/models/course_video.dart';
import 'package:instudy/models/pagination_model.dart';
import 'package:instudy/models/video_transcript.dart';
import 'package:instudy/repo/course_video_repo.dart';
import 'package:instudy/utils/feedback_snackbar.dart';
// import 'package:instudy/utils/video_player.dart';

class CourseVideoListingProvider extends ChangeNotifier {
  bool isLoading = false;
  bool hasLoaded = false;
  bool isPaginating = false;
  bool isLoadingTranscript = false;
  Map<String, VideoTranscript> transcripts = {};
  Set<CourseVideo> videos = {};
  PaginationModel? pagination;
  CachedVideoPlayerPlusController? controller;
  OverlayEntry? entry;
  bool landScape = false;
  bool done = true;

  final CourseVideoRepo _repo = CourseVideoRepo();

  Future<void> fetchCourseVideos(
      {bool isRefresh = true, BuildContext? context}) async {
    if (isLoading || isPaginating) {
      return;
    }
    int page = 0;

    if (pagination == null || isRefresh) {
      page = 1;
    } else {
      page = pagination!.currentPage + 1;
    }
    if (pagination != null && !isRefresh) {
      if (pagination!.currentPage == pagination!.totalPages) {
        return;
      }
    }
    if (isRefresh) {
      isLoading = true;
    } else {
      isPaginating = true;
    }
    notifyListeners();
    await _repo.getCourseVideoList(page: page).then((value) {
      isPaginating = false;
      isLoading = false;
      hasLoaded = true;
      notifyListeners();

      if (value.status) {
        videos = isRefresh
            ? value.result!.videos.toSet()
            : {...videos, ...value.result!.videos};
        pagination = value.result!.pagination;
        notifyListeners();
      } else {
        if (context != null) {
          showFeedbackSnackbar(context, message: value.message);
        }
      }
    });
  }

  Future setLandscape(BuildContext context) async {
    // landScape = !landScape;
    // if(context.mounted){
    //   notifyListeners();
    // }
    // if (landScape) {
    //   entry = OverlayEntry(
    //       builder: (context) => const Material(
    //             child: VideoPlayer(),
                
    //           ));
    //   Overlay.of(context).insert(entry!);
    // } else {
    //   entry?.remove();
    // }
    // done = !landScape;
  }

  Future fetchTranscript(BuildContext context,
      {required String courseID}) async {
    isLoadingTranscript = true;
    notifyListeners();
    if (transcripts.containsKey(courseID)) {
      isLoadingTranscript = false;
      notifyListeners();
      return;
    }

    CourseVideoRepo().getTranscripts(courseID: courseID).then((val) {
      isLoadingTranscript = false;
      notifyListeners();
      if (val.status) {
        transcripts[courseID] = val.result!;
      } else {
        showFeedbackSnackbar(context, message: val.message);
      }
    });
  }
}
