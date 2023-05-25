import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';
import 'package:passport_unifranz_web/services/services.dart';

class CafeApi {
  static final _dio = Dio();
  static Future<void> configureDio() async {
    // Base del url
    _dio.options.baseUrl = host();
    // Configurar Headers
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${LocalStorage.prefs.getString('mode') == 'admin' ? LocalStorage.prefs.getString('token') : LocalStorage.prefs.getString('tokenStudent')}"
    };
    // _dio.options.validateStatus = (status) => status! <= 500;
    // _dio.httpClientAdapter = IOHttpClientAdapter()
    //   ..onHttpClientCreate = (_) {
    //     final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
    //     client.badCertificateCallback = (cert, host, port) => true;
    //     return client;
    //   }
    //   ..validateCertificate = (cert, host, port) {
    //     return true;
    //   };
  }

  static Future<bool> verifyInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        throw ('Error en el GET');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future httpGet(String path) async {
    try {
      debugPrint('==========================================');
      debugPrint('== path $path');
      debugPrint('==========================================');
      final resp = await _dio.get(path);
      return resp;
    } on DioError catch (e) {
      debugPrint('${e.response}');
      rethrow;
    }
  }

  static Future post(String path, Map<String, dynamic> data) async {
    try {
      debugPrint('==========================================');
      debugPrint('== body $data');
      debugPrint('== path $path');
      debugPrint('==========================================');
      final resp = await _dio.post(path, data: data);
      debugPrint('== status ${resp.statusCode}');
      return resp;
    } on DioError catch (e) {
      debugPrint('err $e');
      // debugPrint('${e.response}');
      rethrow;
    }
  }

  static Future put(String path, Map<String, dynamic>? data) async {
    try {
      debugPrint('==========================================');
      debugPrint('== body $data');
      debugPrint('== path $path');
      debugPrint('==========================================');
      final resp = await _dio.put(path, data: data);
      debugPrint('== status ${resp.statusCode}');
      return resp;
    } on DioError catch (e) {
      debugPrint('${e.response}');
      rethrow;
    }
  }
}
