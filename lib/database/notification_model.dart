// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.id,
    required this.title,
    required this.content,
    required this.read,
    required this.date,
  });

  int? id;
  String title;
  String content;
  bool read;
  DateTime date;

  NotificationModel copyWith({
    int? id,
    String? title,
    String? content,
    bool? read,
    DateTime? date,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        read: read ?? this.read,
        date: date ?? this.date,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        read: json["read"] == 'true'?true:false,
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "read": read,
        "date": date.toIso8601String(),
      };
}
