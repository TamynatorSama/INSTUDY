import 'package:instudy/models/course_listing_model.dart';
import 'package:instudy/models/pagination_model.dart';
import 'package:instudy/models/repository_result.dart';
import 'package:instudy/utils/network_request_helper/dio_base.dart';

class DashboardRepo {
  Future<
          RepositoryResult<
              ({List<CourseListingModel> videos, PaginationModel pagination})?>>
      getDashboardCourseVideoList({int page = 1, int limit = 10}) async {
    return await AppNetworkRequest()
        .makeRequest("secure/feeds?page=$page&limit=$limit")
        .then((value) {
      if (value.isSuccessful) {
        List rawList = value.result["data"]["info"];
        PaginationModel page = PaginationModel.fromJson(value.result["data"]);
        return RepositoryResult(
            message: value.result["message"],
            status: true,
            result: (
              videos:
                  rawList.map((e) => CourseListingModel.fromJson(e)).toList(),
              pagination: page
            ));
      }
      return RepositoryResult(
          message: value.message, status: false, result: null);
    });
  }
}
