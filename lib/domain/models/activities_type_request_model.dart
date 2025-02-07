import 'dart:convert';

class ActivitiesTypeRequestModel {
    int resId;
    int actId;
    int createUid;
    int userId;
    int userCreateId;
    bool active;
    String displayName;
    DateTime? createDate;
    DateTime? dateDeadline;
    int previousActivityTypeId;
    String note;
    int activityTypeId;

    ActivitiesTypeRequestModel({
      required this.resId,
      required this.actId,
      required this.userId,
        required this.createUid,
        required this.createDate,
        required this.active,
        required this.previousActivityTypeId,
        required this.displayName,
        required this.note,
        required this.activityTypeId,
        required this.dateDeadline,
        required this.userCreateId
    });

    factory ActivitiesTypeRequestModel.fromJson(String str) => ActivitiesTypeRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ActivitiesTypeRequestModel.fromMap(Map<String, dynamic> json) => ActivitiesTypeRequestModel(
      resId: json["resId"],
      actId: json["actId"],
        userId: json["user_id"],
        createUid: json["create_uid"],        
        createDate: json["create_date"] == null ? null : DateTime.parse(json["create_date"]),
        dateDeadline: json['date_deadline'] == null ? DateTime.now() : DateTime.parse(json['date_deadline']),
        active: json["active"],
        previousActivityTypeId: json["previous_activity_type_id"],
        displayName: json["display_name"],
        note: json["note"],
        activityTypeId: json["activity_type_id"],
        userCreateId: json["activity_type_id"],
    );

    factory ActivitiesTypeRequestModel.fromMap2(Map<String, dynamic> json) {

      return ActivitiesTypeRequestModel(
        actId: json["actId"],
        resId: json["resId"],
        userCreateId: json['user_id'],
        userId: json['user_id'],
        createUid: json['create_uid'],
        active: json['active'],
        createDate: json['create_date'] == null ? DateTime.now() : DateTime.parse(json['create_date']),
        dateDeadline: json['date_deadline'] == null ? DateTime.now() : DateTime.parse(json['date_deadline']),
        previousActivityTypeId: json["previous_activity_type_id"],
        displayName: json["display_name"],
        note: json["note"],
        activityTypeId: json["activity_type_id"]
      );
    }

    Map<String, dynamic> toJson2() {
    return {
      'actId': actId,
      'userCreateId': userCreateId,
      'user_id': userId,
      'create_uid': createUid,
      'active': active,
      'createDate': createDate?.toIso8601String(),      
      'date_deadline': dateDeadline?.toIso8601String(),      
      'previous_activity_type_id': previousActivityTypeId,
      'display_name': displayName,
      'note': note,
      'activity_type_id': activityTypeId
    };
  }

    Map<String, dynamic> toMap() => {
      'actId': actId,
      'userCreateId': userCreateId,
      'user_id': userId,
      'create_uid': createUid,
      'active': active,
      'createDate': createDate?.toIso8601String(),
      'date_deadline': dateDeadline?.toIso8601String(),      
      'previous_activity_type_id': previousActivityTypeId,
      'display_name': displayName,
      'note': note,
      'activity_type_id': activityTypeId
    };
}
