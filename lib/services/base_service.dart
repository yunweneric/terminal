import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:xoecollect/models/base/base_res_model.dart';
import 'package:xoecollect/shared/utils/local_storage.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';

// String baseUrl = 'http://google.com';

class BaseService {
  String baseUrl = 'http://44.215.178.10:3000';

  Future<AppBaseResponse> baseGet({required String urlPath, Map<String, dynamic>? queryParams, String? proposedUrl, bool? isSimpleHeaders = true}) async {
    // var url = Uri.http(proposedUrl ?? baseUrl, urlPath, queryParams);
    Uri url = Uri.parse(baseUrl + urlPath);

    var token = await LocalPreferences.getToken();

    try {
      var response = await http.get(
        url,
        headers: isSimpleHeaders == true ? {'accept': 'application/json'} : {'accept': 'application/json', 'authorization': "Bearer ${token}"},
      );
      // logI(["base get", response.body, url]);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return this.apiSuccess(message: jsonDecode(response.body)['message'] ?? "", data: jsonDecode(response.body));
      } else {
        if (jsonDecode(response.body)['message'].runtimeType != String) {
          return this.apiError(message: jsonDecode(response.body)['message'][0], data: jsonDecode(response.body));
        } else
          return this.apiError(message: jsonDecode(response.body)['message'], data: jsonDecode(response.body));
      }
    } catch (error) {
      logError("$urlPath Error: $error");
      return this.apiServerError();
    }
  }

  Future<AppBaseResponse> basePost({required Map<String, dynamic> data, required String urlPath, String? proposedUrl, bool? isSimpleHeaders, bool? encodeRequest}) async {
    logI(data);

    // var url = Uri.http(proposedUrl ?? json.decode(baseUrl), urlPath);
    Uri url = Uri.parse(baseUrl + urlPath);

    var token = await LocalPreferences.getToken();
    String string_res = jsonEncode(data);

    try {
      var response = await http.post(
        url,
        headers: isSimpleHeaders == true ? {'accept': 'application/json'} : {'accept': 'application/json', 'authorization': "Bearer ${token}"},
        body: encodeRequest == true ? string_res : data,
      );

      logI(["base post", response.body]);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return this.apiSuccess(message: jsonDecode(response.body)['message'] ?? "", data: jsonDecode(response.body));
      } else {
        if (jsonDecode(response.body)['message'].runtimeType != String) {
          return this.apiError(message: jsonDecode(response.body)['message'][0], data: jsonDecode(response.body));
        } else
          return this.apiError(message: jsonDecode(response.body)['message'], data: jsonDecode(response.body));
      }
    } catch (error) {
      logError(["base post error", error]);
      return this.apiServerError();
    }
  }

  Future<AppBaseResponse> baseDelete({required String urlPath, String? proposedUrl, bool? isSimpleHeaders, bool? encodeRequest}) async {
    // var url = Uri.http(proposedUrl ?? json.decode(baseUrl), urlPath);

    Uri url = Uri.parse(baseUrl + urlPath);

    var token = await LocalPreferences.getToken();
    try {
      var response = await http.delete(url, headers: {'accept': 'application/json', 'authorization': "Bearer ${token}"});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return this.apiSuccess(message: jsonDecode(response.body)['message'] ?? "", data: jsonDecode(response.body));
      } else {
        if (jsonDecode(response.body)['message'].runtimeType != String) {
          return this.apiError(message: jsonDecode(response.body)['message'][0], data: jsonDecode(response.body));
        } else
          return this.apiError(message: jsonDecode(response.body)['message'], data: jsonDecode(response.body));
      }
    } catch (error) {
      logError(["base post error", error]);
      return this.apiServerError();
    }
  }

  Future<AppBaseResponse> basePost2({required Map<String, dynamic> data, required String urlPath, String? proposedUrl, bool? isSimpleHeaders, bool? encodeRequest}) async {
    Uri url = Uri.parse(baseUrl + urlPath);

    var token = await LocalPreferences.getToken();
    var headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${token}'};
    try {
      var request = http.Request('POST', url);
      request.body = json.encode(data);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      final res = await response.stream.bytesToString();
      // logI(res);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return this.apiSuccess(message: jsonDecode(res)['message'] ?? "", data: jsonDecode(res));
      } else {
        print(response.reasonPhrase);
        return this.apiError(message: jsonDecode(res)['message'] ?? "", data: jsonDecode(res));
      }
    } catch (error) {
      logError(["base post error", error]);
      return this.apiServerError();
    }
  }

  Future<AppBaseResponse> basePut2({required Map<String, dynamic> data, required String urlPath, String? proposedUrl, bool? isSimpleHeaders}) async {
    Uri url = Uri.parse(baseUrl + urlPath);
    logI(url);
    var token = await LocalPreferences.getToken();
    var headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${token}'};
    try {
      var request = http.Request('PUT', url);
      request.body = json.encode(data);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      final res = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return this.apiSuccess(message: jsonDecode(res)['message'] ?? "", data: jsonDecode(res));
      } else {
        print(response.reasonPhrase);
        return this.apiError(message: jsonDecode(res)['message'] ?? "", data: jsonDecode(res));
      }
    } catch (error) {
      logError(["base post error", error]);
      return this.apiServerError();
    }
  }

  Future<AppBaseResponse> basePut({Map<String, dynamic>? data, required String urlPath, String? proposedUrl, bool? isSimpleHeaders}) async {
    Uri url = Uri.parse(baseUrl + urlPath);
    String? token = await LocalPreferences.getToken();
    logI(token);
    try {
      var response = await http.put(
        url,
        headers: isSimpleHeaders == true ? {'accept': 'application/json'} : {'accept': 'application/json', 'authorization': "Bearer ${token}"},
        body: data,
      );

      logI("base put : ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return this.apiSuccess(message: jsonDecode(response.body)['message'] ?? "", data: jsonDecode(response.body));
      } else {
        if (jsonDecode(response.body)['message'].runtimeType != String) {
          return this.apiError(message: jsonDecode(response.body)['message'][0], data: jsonDecode(response.body));
        } else
          return this.apiError(message: jsonDecode(response.body)['message'], data: jsonDecode(response.body));
      }
    } catch (error) {
      logError("$urlPath Error: $error");
      return this.apiServerError();
    }
  }

  Future<AppBaseResponse> uploadImage(File file, String urlPath) async {
    Uri url = Uri.parse(baseUrl + urlPath);
    var token = await LocalPreferences.getToken();
    try {
      var request = http.MultipartRequest('POST', url);
      Map<String, String> headers = {'accept': 'application/json', 'authorization': "Bearer ${token}"};
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.headers.addAll(headers);
      var response = await request.send();
      var res = await http.Response.fromStream(response);
      if (res.statusCode == 200 || res.statusCode == 201) {
        var resData = res.body;
        return apiSuccess(message: "File successfully uploaded", data: json.decode(resData));
      } else {
        logError(["Error uploading image", res.body, res.statusCode]);
        return apiError(message: "There was an error uploading file\nPlease try again later");
      }
    } catch (e) {
      logError(["Server Error uploading image", e]);
      return apiServerError();
    }
  }

  Future<AppBaseResponse> uploadMultiple(List<File> files, String urlPath) async {
    List<String> links = [];

    try {
      for (var file in files) {
        AppBaseResponse res = await uploadImage(file, urlPath);
        // logI(["uploadImage loop", res.toJson()]);
        if (res.statusCode == 200) {
          links.add(res.data['data']['link']);
        } else
          return res;
      }

      return apiSuccess(message: "Files successfully uploaded!", data: {"data": links});
    } catch (e) {
      logError("Error uploadMultiple image $e");
      return apiServerError();
    }
  }

  AppBaseResponse apiSuccess({required String message, required Map<String, dynamic> data}) {
    return AppBaseResponse(statusCode: 200, message: message, data: data);
  }

  AppBaseResponse apiError({required String message, Map<String, dynamic>? data}) {
    return AppBaseResponse(statusCode: 400, message: message, data: data ?? {});
  }

  AppBaseResponse apiServerError() {
    return AppBaseResponse(
      statusCode: 500,
      message: "There was an error processing the request. Please verify your internet connection and try again",
      data: {},
    );
  }
}
