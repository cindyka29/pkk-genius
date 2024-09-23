import 'package:flutter/material.dart';
import 'package:pkk/data/api/api_client.dart';
import 'package:pkk/data/preferences.dart';
import 'package:pkk/data/res/absence_response.dart';

abstract class AbsenceFunction {
  static Future<Data?> getUserAbsenceList(String activityId) async {
    try {
      final [userAbsenceData, userNotAbsenceData] = await Future.wait([
        ApiClient.useCache(
          model: 'absence/$activityId/activity',
          onRequest: (model, queryParameters, options) {
            return ApiClient.getListData(model: model);
          },
        ).then((data) {
          return AbsencesResponse.fromJson(data).data;
        }),
        ApiClient.useCache(
          model: 'absence/not/$activityId/activity',
          onRequest: (model, queryParameters, options) {
            return ApiClient.getListData(model: model);
          },
        ).then((data) {
          AbsencesResponse.fromJson2(data).data;
        }),
      ]);
      final userList = [
        ...userAbsenceData?.users?.where((e) => e.userId != null) ??
            <UserElement>[],
        ...userNotAbsenceData?.users?.where((e) => e.userId != null) ??
            <UserElement>[],
      ];
      return Data(
        activity: userAbsenceData?.activity,
        users: userList,
      );
    } catch (e, stacktrace) {
      debugPrint('Error when fetching List absen: $e\n$stacktrace');
    }
    return null;
  }

  static Future<bool> putUserAbsenceStatus(
      {required String id,
      required String userId,
      required String activityId,
      required bool isAttended}) async {
    try {
      final response = await ApiClient.updateDataById(
        model: 'absence',
        idData: id,
        payload: {
          "user_id": userId,
          "activity_id": activityId,
          "is_attended": isAttended,
        },
      );
      if (response.statusCode == null) return false;
      return response.statusCode! >= 200 || response.statusCode! < 300;
    } catch (e, stacktrace) {
      debugPrint('Error when updating user absence status: $e\n$stacktrace');
      return false;
    }
  }

  static Future<List<UserElement>?> getAbsenceByUserId() async {
    try {
      final response = await ApiClient.getListDataByUserID(
          model: 'absence', userID: Preferences.getUser()!.id!);
      if (response.statusCode == 200) {
        debugPrint(response.data.toString());
        // final listdataAbsenrespon = AbsencesResponse.fromJson(response.data);
        final listAbsen = Data.fromAbsence(response.data["data"]);
        return listAbsen.users;
      }
    } catch (e, stacktrace) {
      debugPrint('Error when getting user absence by user id: $e\n$stacktrace');
    }
    return [];
  }
}
