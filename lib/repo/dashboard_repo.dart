import 'package:instudy/models/course_listing_model.dart';
import 'package:instudy/models/pagination_model.dart';
import 'package:instudy/models/quiz.dart';
import 'package:instudy/models/repository_result.dart';
import 'package:instudy/utils/enums.dart';
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

  Future<RepositoryResult> addNote(
      {required String feedID, required String note}) async {
    return await AppNetworkRequest().makeRequest(
        "secure/feeds/add-note/$feedID",
        requestType: HttpRequestType.post,
        payload: {"note": note}).then((value) {
      return RepositoryResult(
          message: value.result["message"] ?? "",
          status: value.isSuccessful,
          result: null);
    });
  }

  Future<RepositoryResult<Quiz?>> generateQuiz(
      {required String feedID}) async {
    return await AppNetworkRequest().makeRequest(
        "secure/feeds/generate-quiz/$feedID").then((value) {
          if(value.isSuccessful){
            return RepositoryResult(
          message: value.result["message"] ?? "",
          status:true,
          result: Quiz.fromJson(value.result["data"]));
          }
      return RepositoryResult(
          message: value.result["message"] ?? "",
          status: value.isSuccessful,
          result: null);
    });
  }

  Future<RepositoryResult> addTag(
      {required String feedID, required String tag}) async {
    return await AppNetworkRequest().makeRequest(
        "secure/feeds/add-tag/$feedID",
        requestType: HttpRequestType.post,
        payload: {"tag": tag}).then((value) {
      return RepositoryResult(
          message: value.result["message"] ?? "",
          status: value.isSuccessful,
          result: null);
    });
  }



  Future<RepositoryResult> addBookmark(
      {required String feedID, required bool status}) async {
    return await AppNetworkRequest().makeRequest(
        "secure/feeds/add-bookmark/$feedID",
        requestType: HttpRequestType.post,
        payload: {"status": status ?1:0}).then((value) {
      return RepositoryResult(
          message: value.result["message"] ?? "",
          status: value.isSuccessful,
          result: null);
    });
  }

  
}
