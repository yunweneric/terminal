import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:terminal/models/base/base_res_model.dart';
import 'package:terminal/shared/utils/local_storage.dart';
import 'package:terminal/shared/utils/logger_util.dart';

String baseUrl = "";

class BaseService {
  Future<BaseResponse> baseGet({required String urlPath, Map<String, dynamic>? queryParams, String? proposedUrl}) async {
    var url = Uri.https(proposedUrl ?? baseUrl, urlPath, queryParams);
    try {
      var response = await http.get(url, headers: {'accept': 'application/json'});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return this.apiSuccess(message: jsonDecode(response.body)['message'] ?? "", data: jsonDecode(response.body));
      } else {
        return this.apiError(message: jsonDecode(response.body)['message'] ?? "", data: jsonDecode(response.body));
      }
    } catch (error) {
      logError("$urlPath Error: $error");
      return this.apiServerError();
    }
  }

  Future<BaseResponse> basePost({required Map<String, dynamic> data, required String urlPath, String? proposedUrl, bool? isSimpleHeaders}) async {
    var url = Uri.https(proposedUrl ?? baseUrl, urlPath);
    var token = await LocalPrefs.getToken();
    try {
      var response = await http.post(
        url,
        headers: isSimpleHeaders == true ? {'accept': 'application/json'} : {'accept': 'application/json', 'authorization': "Bearer ${token}"},
        body: data,
      );
      print("basePost 2 : ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return this.apiSuccess(message: jsonDecode(response.body)['message'] ?? "", data: jsonDecode(response.body));
      } else {
        return this.apiError(message: jsonDecode(response.body)['message'], data: jsonDecode(response.body));
      }
    } catch (error) {
      logError("$urlPath Error: $error");
      return this.apiServerError();
    }
  }

  BaseResponse apiSuccess({required String message, required Map<String, dynamic> data}) {
    return BaseResponse(statusCode: 200, message: message, data: data);
  }

  BaseResponse apiError({required String message, Map<String, dynamic>? data}) {
    return BaseResponse(statusCode: 400, message: message, data: data ?? {});
  }

  BaseResponse apiServerError() {
    return BaseResponse(
      statusCode: 500,
      message: "There was an error processing the request. Please verify your internet connection and try again",
      data: {},
    );
  }
}
