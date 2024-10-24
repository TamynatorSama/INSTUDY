import 'package:instudy/models/repository_result.dart';
import 'package:instudy/models/tags.dart';
import 'package:instudy/utils/network_request_helper/dio_base.dart';

class TagRepo {
  Future<RepositoryResult<List<Tags>?>>
      getTags({int page = 1, int limit = 10}) async {
    return await AppNetworkRequest()
        .makeRequest("secure/feeds/tags")
        .then((value) {
      if (value.isSuccessful) {
        List rawList = value.result["data"];
        // PaginationModel page = PaginationModel.fromJson(value.result["data"]);
        return RepositoryResult(
            message: value.result["message"],
            status: true,
            result: 
              rawList.map((e) => Tags.fromJson(e)).toList(),
             );
      }
      return RepositoryResult(
          message: value.message, status: false, result: null);
    });
  }

  
}
