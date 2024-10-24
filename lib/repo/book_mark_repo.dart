import 'package:instudy/models/bookmark_model.dart';
import 'package:instudy/models/pagination_model.dart';
import 'package:instudy/models/repository_result.dart';
import 'package:instudy/utils/network_request_helper/dio_base.dart';

class BookMarkRepo {
  Future<
          RepositoryResult<
              ({List<Bookmark> bookmarks, PaginationModel pagination})?>>
      getBookMarks({int page = 1, int limit = 10}) async {
    return await AppNetworkRequest()
        .makeRequest("secure/feeds/bookmarks?page=$page&limit=$limit")
        .then((value) {
      if (value.isSuccessful) {
        List rawList = value.result["data"]["info"];
        PaginationModel page = PaginationModel.fromJson(value.result["data"]);
        return RepositoryResult(
            message: value.result["message"],
            status: true,
            result: (
              bookmarks: rawList.map((e) => Bookmark.fromJson(e)).toList(),
              pagination: page
            ));
      }
      return RepositoryResult(
          message: value.message, status: false, result: null);
    });
  }
}
