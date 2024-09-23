import 'package:pkk/data/res/activities_response.dart';
import 'package:pkk/data/res/response.dart';
import 'package:pkk/data/res/user_response.dart';

class IuranResponse {
  Response? response;
  Data? data;

  IuranResponse({
    this.response,
    this.data,
  });

  factory IuranResponse.fromJson(Map<String, dynamic> json) => IuranResponse(
        response: Response.fromJson(json["response"]),
        data: Data.fromJson(json["data"]),
      );

  factory IuranResponse.fromJson2(Map<String, dynamic> json) => IuranResponse(
        response: Response.fromJson(json["response"]),
        data: Data.fromJson2(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response!.toJson(),
        "data": data!.toJson(),
      };
}

class Data {
  List<UserElement>? users;
  Activity? activity;

  Data({
    this.users,
    this.activity,
  });
  factory Data.fromIuran(Map<String, dynamic> json) => Data(
        users: List<UserElement>.from(
            json["records"].map((x) => UserElement.fromJson(x))),
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        users: List<UserElement>.from(
            json["users"].map((x) => UserElement.fromJson(x))),
        activity: Activity.fromJson(json["activity"]),
      );

  factory Data.fromJson2(Map<String, dynamic> json) => Data(
        users: List<UserElement>.from(json["users"].map(
          (x) => UserElement(
            isPaid: 0,
            userId: x["id"],
            user: User.fromJson(x ?? {}),
            activityId: json["activity"]["id"],
          ),
        )),
        activity: Activity.fromJson(json["activity"]),
      );

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users!.map((x) => x.toJson())),
        "activity": activity!.toJson(),
      };
}

class UserElement {
  int? isPaid;
  int? nominal;
  String? userId;
  User? user;
  String? activityId;
  Activity? activity;

  UserElement({
    this.isPaid,
    this.nominal,
    this.userId,
    this.user,
    this.activityId,
    this.activity,
  });

  factory UserElement.fromJson(Map<String, dynamic> json) => UserElement(
        isPaid: json["is_paid"],
        nominal: json["nominal"],
        userId: json["user_id"],
        user: User.fromJson(json["users"] ?? {}),
        activityId: json["activity_id"],
        activity: Activity.fromAbsence(json['activity']),
      );

  Map<String, dynamic> toJson() => {
        "is_paid": isPaid,
        "user_id": userId,
        "activity_id": activityId,
      };
}
