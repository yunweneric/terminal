import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static final _storage = FirebaseStorage.instance;
  static final _db = FirebaseFirestore.instance;

  static Future<bool> isProd() async {
    String? app_mode = dotenv.env['APP_MODE'];
    return app_mode == "PROD" ? true : false;
  }

  static Future<Reference> getStorage(String title) async {
    // bool isProd = await AppConfig.isProd();
    return _storage.ref(title);
    // return isProd ? _storage.ref(title) : _storage.ref("test_${title}");
  }

  static Future<CollectionReference<Map<String, dynamic>>> getCollection(String field) async {
    // bool isProd = await AppConfig.isProd();
    return _db.collection(field);
    // return isProd ? _db.collection(field) : _db.collection("test_db").doc("test_db").collection("test_${field}");
  }
}
