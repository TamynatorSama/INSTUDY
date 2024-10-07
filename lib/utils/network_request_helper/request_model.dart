class AppHttpResponse {
  late Map<String, dynamic> result;
  final String message;
  final bool isSuccessful;

  AppHttpResponse({required this.message,required this.isSuccessful, required this.result});
}

class SuccessResponse<T> extends AppHttpResponse {
  T? data;

  SuccessResponse(
      {this.data,super.message = "", super.isSuccessful = true, required super.result});

  SuccessResponse withConverter(HttpResponseConverter converter) {
    return SuccessResponse(data: converter(super.result), result: result,message:message);
  }
}
class ErrorResponse extends AppHttpResponse {
  

  ErrorResponse(
      {super.message = "", super.isSuccessful = false, required super.result});

  // ErrorResponse withConverter(HttpResponseConverter converter) {
  //   return ErrorResponse( result: result,message:message);
  // }
}


typedef HttpResponseConverter<T> = T Function(Map<String, dynamic> json);
