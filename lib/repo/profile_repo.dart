import 'package:instudy/models/profile.dart';
import 'package:instudy/models/repository_result.dart';
import 'package:instudy/utils/network_request_helper/dio_base.dart';

class ProfileRepo {
  Future<RepositoryResult<Profile?>> getProfile() async {
    return await AppNetworkRequest()
        .makeRequest("/secure/profile")
        .then((value) {
      if (value.isSuccessful) {
        return RepositoryResult(
            message: value.message, status: true, result: Profile.fromJson(value.result["data"]));
      }
      return RepositoryResult(
            message: value.message, status: false, result: null);
    });
  }
}
