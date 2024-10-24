import 'package:flutter/material.dart';
import 'package:instudy/models/bookmark_model.dart';
import 'package:instudy/models/pagination_model.dart';
import 'package:instudy/models/tags.dart';
import 'package:instudy/repo/book_mark_repo.dart';
import 'package:instudy/repo/dashboard_repo.dart';
import 'package:instudy/repo/tag_repo.dart';
import 'package:instudy/utils/feedback_snackbar.dart';

class BookmarkTagProvider extends ChangeNotifier {
  PaginationModel? bookMarkPagination;
  List<Tags> tags = [];
  List<Bookmark> bookMarks = [];
  bool isLoadingBookmark = false;
  bool isLoadingTags = false;
  bool hasLoadedBookmark = false;
  bool hasLoadedTags = false;
  bool isPaginating = false;

  final BookMarkRepo _markRepo = BookMarkRepo();
  final TagRepo _tagRepo = TagRepo();

  Future<void> fetchBookMarks(
      {bool isRefresh = true, BuildContext? context}) async {
    if (isLoadingBookmark || isPaginating) {
      return;
    }
    int page = 0;

    if (bookMarkPagination == null || isRefresh) {
      page = 1;
    } else {
      page = bookMarkPagination!.currentPage + 1;
    }
    if (bookMarkPagination != null && !isRefresh) {
      if (bookMarkPagination!.currentPage == bookMarkPagination!.totalPages) {
        return;
      }
    }
    if (isRefresh) {
      isLoadingBookmark = true;
    } else {
      isPaginating = true;
    }
    notifyListeners();
    await _markRepo.getBookMarks(page: page).then((value) {
      isPaginating = false;
      isLoadingBookmark = false;
      hasLoadedBookmark = true;
      notifyListeners();

      if (value.status) {
        bookMarks = isRefresh
            ? value.result!.bookmarks
            : [...bookMarks, ...value.result!.bookmarks];
        bookMarkPagination = value.result!.pagination;
        notifyListeners();
      } else {
        if (context != null) {
          showFeedbackSnackbar(context, message: value.message);
        }
      }
    });
  }

  Future fetchTags(
    BuildContext context,
  ) async {
    isLoadingTags = true;
    notifyListeners();

    _tagRepo.getTags().then((val) {
      hasLoadedTags = true;
      isLoadingTags = false;
      notifyListeners();
      if (val.status) {
        tags = val.result!;
        notifyListeners();
      } else {
        showFeedbackSnackbar(context, message: val.message);
      }
    });
  }

  Future<bool> addTag(BuildContext context,
      {required String feedID, required String tag}) async {
    return await DashboardRepo().addTag(feedID: feedID, tag: tag).then((val) {
      if (!val.status) {
        showFeedbackSnackbar(context, message: val.message);
      }
      return val.status;
    });
  }
}
