import 'package:instudy/models/course_video.dart';
import 'package:instudy/models/pagination_model.dart';
import 'package:instudy/models/repository_result.dart';
import 'package:instudy/models/video_transcript.dart';
import 'package:instudy/utils/network_request_helper/dio_base.dart';

class CourseVideoRepo {
  Future<
          RepositoryResult<
              ({List<CourseVideo> videos, PaginationModel pagination})?>>
      getCourseVideoList({int page = 1, int limit = 10}) async {
    return await AppNetworkRequest()
        .makeRequest("secure/video/lectures?page=$page&limit=$limit")
        .then((value) {
      if (value.isSuccessful) {
        List rawList = value.result["data"]["info"];
        PaginationModel page = PaginationModel.fromJson(value.result["data"]);
        return RepositoryResult(
            message: value.result["message"],
            status: true,
            result: (
              videos: rawList.map((e) => CourseVideo.fromJson(e)).toList(),
              pagination: page
            ));
      }
      return RepositoryResult(
          message: value.message, status: false, result: null);
    });
  }

  Future<RepositoryResult<VideoTranscript?>> getTranscripts(
      {required String courseID}) async {
    return await AppNetworkRequest()
        .makeRequest("secure/video/transcript/$courseID")
        .then((value) {
      if (value.isSuccessful) {
        return RepositoryResult(
            message: value.message,
            status: true,
            result: VideoTranscript.fromJson(value.result["data"]));
      }
      return RepositoryResult(
          message: value.message, status: false, result: null);
    });
  }
}
