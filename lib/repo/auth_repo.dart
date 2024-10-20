import 'package:instudy/models/courses_model.dart';
import 'package:instudy/models/repository_result.dart';
import 'package:instudy/utils/enums.dart';
import 'package:instudy/utils/local_storage.dart';
import 'package:instudy/utils/network_request_helper/dio_base.dart';

class AuthRepo {
  static String? _token;
  static String? _email;

  static initApp() async {
    _token = await Storage.storage.read(key: "token");
    _email = await Storage.storage.read(key: "email");
  }

  set token(String? token) {
    _token = token;
    Storage.storage.write(key: "token", value: token);
  }

  String? get token {
    return _token;
  }

  set email(String? email) {
    _email = email;
    Storage.storage.write(key: "email", value: email);
  }

  String? get email {
    return _email;
  }

  Future<RepositoryResult<bool>> validateUser({required String email}) async {
    return await AppNetworkRequest().makeRequest("validate-user",
        requestType: HttpRequestType.post,
        payload: {"email": email}).then((val) {
      if (val.isSuccessful) {
        return RepositoryResult(
            message: val.result["message"] ?? "Success",
            status: true,
            result: val.result["data"]["user_exist"]);
      }
      return RepositoryResult(
          message: val.result["message"] ?? "Failure",
          status: false,
          result: false);
    });
  }

  Future<RepositoryResult> signUp(
      {required String email, required List<String> courses}) async {
    return await AppNetworkRequest()
        .makeRequest("login", requestType: HttpRequestType.post, payload: {
      "email": email,
      "courses": courses.map((e) => {"course_id": e}).toList()
    }).then((val) {
      if (val.isSuccessful) {
        email = val.result["data"]["email"];
        token = val.result["data"]["token"];
        return RepositoryResult(
            message: val.result["message"] ?? "Success",
            status: true,
            result: false);
      }
      return RepositoryResult(
          message: val.result["message"] ?? "An Error Occurred",
          status: false,
          result: false);
    });
  }

  Future<RepositoryResult<(List<Course>, List<String>)?>> getCourses() async {
    return await AppNetworkRequest().makeRequest("secure/course").then((val) {
      if (val.isSuccessful) {
        List courses = val.result["data"]["courses"];
        return RepositoryResult(
            message: "courses retrieved successfully",
            status: true,
            result: (
              courses.map((e) => Course.fromJson(e)).toList(),
              List<String>.from(val.result["data"]["semester"])
            ));
      }
      print(val.message);
      return RepositoryResult(
          message: val.message, status: false, result: null);
    });
  }
}
