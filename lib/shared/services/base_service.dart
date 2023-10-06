import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xoecollect/config/app_config.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:http/http.dart' as http;

// String baseUrl = 'http://google.com';

class BaseService {
  // String baseUrl = 'http://44.215.178.10:3000';
  String baseSMSUrl = 'https://api.avlytext.com/v1';
  final metadata = SettableMetadata(contentType: "image/jpeg");

  Future<String?> getBaseSMSURL() async {
    String? apiKey = await dotenv.env['BASESMS_API_KEY'];
    return apiKey == null ? null : '/sms?api_key=${apiKey}';
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

  Future<AppBaseResponse> baseGet({
    required String collectionRef,
    bool? innerCollection,
    String? innerId,
  }) async {
    var ref = await AppConfig.getCollection(collectionRef);
    if (innerCollection == true) {
      ref = ref.doc(innerId).collection(collectionRef);
    }
    try {
      QuerySnapshot<Map<String, dynamic>> res = await ref.get();
      List<Map<String, dynamic>> data = res.docs.map((e) => e.data()).toList();
      return apiSuccess(message: "Data found successfully", data: {'data': data});
    } catch (e) {
      return apiServerError();
    }
  }

  Future<AppBaseResponse> baseFind({
    required String collectionRef,
    bool? innerCollection,
    String? innerId,
    required String value,
    required String field,
    String? name,
  }) async {
    var ref = await AppConfig.getCollection(collectionRef);
    if (innerCollection == true) {
      ref = ref.doc(innerId).collection(collectionRef);
    }
    try {
      QuerySnapshot<Map<String, dynamic>> res = await ref.where(field, isEqualTo: value).get();
      List<Map<String, dynamic>> data = res.docs.map((e) => e.data()).toList();
      if (data.length > 0) return apiSuccess(message: name == null ? "Data found successfully" : "$name found successfully!", data: data.first);
      return apiSuccess(message: name == null ? "No item found!" : "No ${name} found!", data: {});
    } catch (e) {
      return apiServerError();
    }
  }

  Future<AppBaseResponse> baseQuery({
    String? name,
    required QuerySnapshot<Map<String, dynamic>> query,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>> res = await query;
      List<Map<String, dynamic>> data = res.docs.map((e) => e.data()).toList();
      if (data.length > 0)
        return apiSuccess(
          message: name == null ? "Data found successfully" : "$name found successfully!",
          data: {"data": data},
        );
      return apiSuccess(message: name == null ? "No item found!" : "No ${name} found!", data: {});
    } catch (e) {
      return apiServerError();
    }
  }

  Future<AppBaseResponse> baseAdd({
    required Map<String, dynamic> data,
    required String collectionRef,
    bool? innerCollection,
    String? innerId,
  }) async {
    var ref = await AppConfig.getCollection(collectionRef);
    if (innerCollection == true) {
      ref = ref.doc(innerId).collection(collectionRef);
    }
    try {
      await ref.doc(data['id']).set(data);
      return apiSuccess(message: "data added successfully", data: data);
    } catch (e) {
      return apiServerError();
    }
  }

  Future<AppBaseResponse> baseUpdate({
    required Map<String, dynamic> data,
    required String collectionRef,
    bool? innerCollection,
    String? innerId,
  }) async {
    var ref = await AppConfig.getCollection(collectionRef);
    var image_ref = await AppConfig.getStorage(collectionRef);
    if (innerCollection == true) {
      ref = ref.doc(innerId).collection(collectionRef);
    }
    try {
      if (data['imageUrl'] != null) {
        if (!data['imageUrl'].startsWith('http')) {
          File categoryImage = File(data['imageUrl']);
          await image_ref.child(data['id']).putFile(categoryImage, metadata);
          String imgUrl = await image_ref.child(data['id']).getDownloadURL();
          data['imageUrl'] = imgUrl;
        }
        ref.doc(data['id']).update(data);
        return apiSuccess(message: "services.category.s_update", data: {});
      } else {
        ref.doc(data['id']).update(data);
        return apiSuccess(message: "services.category.s_update", data: {});
      }
    } catch (e) {
      return apiServerError();
    }
  }

  Future<AppBaseResponse> baseDelete({
    required String collectionRef,
    required String id,
    required bool hasImages,
    bool? innerCollection,
    String? innerId,
  }) async {
    bool itemExist = true;
    var ref = await AppConfig.getCollection(collectionRef);
    var image_ref = await AppConfig.getStorage(collectionRef);
    if (innerCollection == true) {
      ref = ref.doc(innerId).collection(collectionRef);
    }
    try {
      var res = await ref.where('id', isEqualTo: id).get();
      res.size > 0 ? itemExist = true : itemExist = false;
      logI([res.size, ref, id, hasImages, innerCollection, innerId]);
      if (!itemExist) return apiError(message: "services.category.e_delete", data: {});

      if (hasImages) {
        await image_ref.child(id).delete();
      }
      await ref.doc(id).delete();
      return apiSuccess(message: "data deleted successfully", data: {});
    } catch (e) {
      logI(e);
      return apiServerError();
    }
  }

  Future<AppBaseResponse> basePost({required Map<String, dynamic> data, required String urlPath, String? proposedUrl, bool? isSimpleHeaders, bool? encodeRequest}) async {
    logI(data);

    Uri url = Uri.parse(baseSMSUrl + urlPath);

    String string_res = jsonEncode(data);

    try {
      var response = await http.post(
        url,
        headers: {'accept': 'application/json'},
        body: encodeRequest == true ? string_res : data,
      );

      logI(["base post", response.body]);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return this.apiSuccess(message: "", data: jsonDecode(response.body));
      } else {
        return this.apiError(message: "", data: jsonDecode(response.body));
      }
    } catch (error) {
      return this.apiServerError();
    }
  }
}
