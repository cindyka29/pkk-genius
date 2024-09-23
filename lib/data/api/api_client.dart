import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pkk/data/model/cache_model.dart';

abstract class ApiClient {
  static final cacheManager = DefaultCacheManager();
  static final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  static const apiUrl = 'http://10.0.2.2:8000/api';

  static void initToken({required String bearerToken}) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer $bearerToken';
          return handler.next(options);
        },
        onError: (error, handler) {
          debugPrint('Request failed with error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

//  =============== GET DATA - START ===============
  static String _buildFullUrl(String baseUrl,
      {Map<String, String>? queryParameters}) {
    final uri = Uri.parse(baseUrl);
    if (queryParameters == null) return baseUrl;
    final newUri = uri.replace(queryParameters: queryParameters);
    return newUri.toString();
  }

  static Future<Response> getListData(
      {required String model,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    final result = await dio.get('$apiUrl/$model',
        queryParameters: queryParameters, options: options);
    return result;
  }

  static Future<Response> getListDataByUserID(
      {required String model, required String userID}) async {
    final result = await dio.get('$apiUrl/$model/user/$userID');

    return result;
  }

  static Future<Response> getDataById(
      {required String model, required String idData}) async {
    final result = await dio.get('$apiUrl/$model/$idData');
    return result;
  }

  static Future<Response> getiuranRekapDataByActivityID({required String activityID}) async {
    final result = await dio.get('$apiUrl/iuran/$activityID/activity');
    return result;
  }

  static Future<dynamic> useCache({
    required String model,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required Future<Response> Function(String model,
            Map<String, dynamic>? queryParameters, Options? options)
        onRequest,
  }) async {
    final fullUrl = _buildFullUrl('$apiUrl/$model',
        queryParameters:
            queryParameters?.map((k, v) => MapEntry(k, v.toString())));
    final [FileInfo? file, Response<dynamic> response] =
        await Future.wait<dynamic>([
      cacheManager.getFileFromCache(fullUrl),
      onRequest.call(model, queryParameters, options)
    ]);

    final cacheData = await () async {
      if (file == null || !(await file.file.exists())) return null;
      final cacheStr = await file.file.readAsString();
      final apiLastUpdate =
          DateTime.tryParse(response.headers.value('lastUpdate') ?? '');
      final cacheDataUpdated = CacheModel(
          data: response.data, dateUpdated: apiLastUpdate ?? DateTime.now());
      await cacheManager.putFile(
          fullUrl, utf8.encode(jsonEncode(cacheDataUpdated.toJson())));
      return CacheModel.fromJson(jsonDecode(cacheStr));
    }.call();
    if (file == null || !(await file.file.exists())) {
      if (response.statusCode != 200 && response.statusCode != 304) {
        throw Exception('CACHE ERROR: status code ${response.statusCode}');
      }
      await cacheManager.putFile(
          fullUrl, utf8.encode(jsonEncode(response.data)));
      return response.data;
    }

    if (response.statusCode != 200 && response.statusCode != 304) {
      throw Exception('CACHE ERROR: status code ${response.statusCode}');
    }

    final apiLastUpdate =
        DateTime.tryParse(response.headers.value('lastUpdate') ?? '');
    if (cacheData != null && apiLastUpdate == cacheData.dateUpdated) {
      return cacheData.data;
    }

    final cacheDataUpdated = CacheModel(
        data: response.data, dateUpdated: apiLastUpdate ?? DateTime.now());
    await cacheManager.putFile(
        fullUrl, utf8.encode(jsonEncode(cacheDataUpdated.toJson())));
    return response.data;
  }
//  =============== GET DATA - END ==================

//  =============== INSERT DATA - START ===============
  static Future<Response> insertDataToModel({
    required String model,
    Map<String, dynamic>? payload,
    FormData? formData,
    Options? options,
  }) async {
    final result = await dio.post('$apiUrl/$model',
        data: payload ?? formData, options: options);
    return result;
  }

  static Future<Response> action(
      {required String action,
      Map<String, dynamic>? payload,
      FormData? formData}) async {
    final result = await dio.post('$apiUrl/$action', data: payload ?? formData);
    return result;
  }
//  =============== INSERT DATA - END =================

//  =============== UPDATE DATA - START ===============
  static Future<Response> updateDataById(
      {required String model,
      required String idData,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? payload,
      FormData? formData}) async {
    final result = await dio.put('$apiUrl/$model/$idData',
        queryParameters: queryParameters, data: payload ?? formData);
    return result;
  }
//  =============== UPDATE DATA - END =================

//  =============== DELETE DATA - START ===============
  static Future<Response> deleteDataById(
      {required String model, required String idData}) async {
    final result = await dio.delete('$apiUrl/$model/$idData');
    return result;
  }
//  =============== DELETE DATA - END =================

//  =============== DOWNLOAD DATA - START =============
  static Future<Response> download(
      {required String model,
      Map<String, dynamic>? queryParameters,
      Options? options,
      required String fileName}) async {
    final directory = await getDownloadsDirectory();
    final filePath = '${directory?.path ?? ''}/$fileName';
    final result = await dio.download(
      '$apiUrl/$model',
      filePath,
      queryParameters: queryParameters,
      options: options,
    );
    Fluttertoast.showToast(msg: 'Berhasil download file');
    OpenFile.open(filePath);
    return result;
  }
//  =============== DOWNLOAD DATA - END ===============
}
