import 'package:flutter/material.dart';
import 'package:instudy/models/course_listing_model.dart';
import 'package:instudy/models/pagination_model.dart';
import 'package:instudy/repo/dashboard_repo.dart';
import 'package:instudy/utils/feedback_snackbar.dart';
// import 'package:instudy/utils/video_player.dart';

class DashboardProvider extends ChangeNotifier {
  bool isLoading = false;
  bool hasLoaded = false;
  bool isPaginating = false;
  Set<CourseListingModel> videos = {};
  PaginationModel? pagination;

  final DashboardRepo _repo = DashboardRepo();

  Future<void> fetchCourseListing(
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
    await _repo.getDashboardCourseVideoList(page: page).then((value) {
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
}
