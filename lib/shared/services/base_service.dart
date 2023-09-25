import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:xoecollect/config/app_config.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';

// String baseUrl = 'http://google.com';

class BaseService {
  String baseUrl = 'http://44.215.178.10:3000';
  final metadata = SettableMetadata(contentType: "image/jpeg");

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
}
