import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:instudy/repo/auth_repo.dart';
import 'package:instudy/utils/enums.dart';
import 'package:instudy/utils/loader_controller.dart';
import 'package:instudy/utils/network_request_helper/interceptor/token_interceptor.dart';
import 'package:instudy/utils/network_request_helper/request_model.dart';

// final Provider<AppNetworkRequest> networkProvider =
//     Provider((ref) => AppNetworkRequest());

class AppNetworkRequest {
  static late Dio _dioClient;
  // late ProviderRef<AppNetworkRequest> ref;

  AppNetworkRequest._internal();
  static final AppNetworkRequest _inst = AppNetworkRequest._internal();
  factory AppNetworkRequest() {
    return _inst;
  }

  // AppNetworkRequest._sharedInstance();
  // static final AppNetworkRequest _shared = AppNetworkRequest._sharedInstance();
  // factory AppNetworkRequest.instance() = _shared;
  // AppNetworkRequest._sharedInstance();
  static const String _baseUrl = "http://51.20.109.163:6004/api/v1/";

  // AppNetworkRequest({required this.ref});

  static void init() {
    _dioClient = Dio(BaseOptions(
      baseUrl: _baseUrl,
    ));
    _dioClient.options.headers = {"Content-Type": "application/json"};
  }

  Future<AppHttpResponse> makeRequest(String url,
      {HttpRequestType requestType = HttpRequestType.get,
      Map<String, dynamic>? payload,
      bool showLoader = true,
      String? baseUrl}) async {
    if (!_dioClient.interceptors.any((e) => e is TokenInterceptor) &&
        AuthRepo.token != null) {
      _dioClient.interceptors.add(TokenInterceptor(AuthRepo.token ?? ""));
    }
    // context.read();
    // if (showLoader) {
    loaderController.updateState(isLoading: showLoader);
    // ref.read(appState).updateLoadingState(true);
    // }
    AppHttpResponse response;
    // appState.read().updateLoadingState();
    if (baseUrl != null) {
      _dioClient.options.baseUrl = baseUrl;
    }
    try {
      switch (requestType) {
        case HttpRequestType.get:
          response = await _getRequest(url, payload: payload);

        case HttpRequestType.post:
        case HttpRequestType.put:
          response =
              await _postRequest(url, payload!, requestType: requestType);
        default:
          response = await _getRequest(url);
      }
      loaderController.updateState(isLoading: false);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
    loaderController.updateState(isLoading: false);
    return ErrorResponse(
        result: {}, message: "error communicating with backend");
  }

  Future<AppHttpResponse> _getRequest(String url,
      {Map<String, dynamic>? payload}) async {
    try {
      final response = await _dioClient.get(url, data: payload);
      print(response.data);
      return SuccessResponse(
          result: response.data,
          message: response.statusMessage ?? "Request successful");
    } on DioException catch (e) {
      print(e.response?.data);
      return ErrorResponse(
          result: {},
          message: e.response?.data["message"] ?? "Failed to process request");
    } on SocketException catch (e) {
      return ErrorResponse(result: {}, message: e.message);
    } catch (e) {
      return ErrorResponse(result: {}, message: "Failed to process request");
    }
  }

  Future<AppHttpResponse> _postRequest(String url, Map<String, dynamic> data,
      {HttpRequestType requestType = HttpRequestType.post}) async {
    try {
      final response = await (requestType == HttpRequestType.post
          ? _dioClient.post(url, data: data)
          : _dioClient.put(url, data: data));
      print(response.data);
      if (response.data["status"] == false) {
        return ErrorResponse(result: {}, message: response.data["message"]);
      }
      return SuccessResponse(
          result: response.data,
          message: response.data["message"] ?? "Request successful");
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.response?.statusMessage);
      }

      return ErrorResponse(
          result: {},
          message: e.response?.data["message"] ?? "Failed to process request");
    } on SocketException catch (e) {
      return ErrorResponse(result: {}, message: e.message);
    } catch (e) {
      return ErrorResponse(result: {}, message: "Failed to process request");
    }
  }
}
