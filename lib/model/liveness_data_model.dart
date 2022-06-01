// To parse this JSON data, do
//
//     final livenesData = livenesDataFromJson(jsonString);

import 'dart:convert';

LivenesData livenesDataFromJson(String str) =>
    LivenesData.fromJson(json.decode(str));

String livenesDataToJson(LivenesData data) => json.encode(data.toJson());

class LivenesData {
  LivenesData({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  LivenesData copyWith({
    bool? error,
    String? message,
    Data? data,
  }) =>
      LivenesData(
        error: error ?? this.error,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LivenesData.fromJson(Map<String, dynamic> json) => LivenesData(
        error: json["error"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.completed,
    this.type,
    this.dialog,
    this.action,
    this.currentAction,
    this.totalActions,
  });

  bool? completed;
  String? type;
  Dialog? dialog;
  Action? action;
  int? currentAction;
  int? totalActions;

  Data copyWith({
    bool? completed,
    String? type,
    Dialog? dialog,
    Action? action,
    int? currentAction,
    int? totalActions,
  }) =>
      Data(
        completed: completed ?? this.completed,
        type: type ?? this.type,
        dialog: dialog ?? this.dialog,
        action: action ?? this.action,
        currentAction: currentAction ?? this.currentAction,
        totalActions: totalActions ?? this.totalActions,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        completed: json["completed"],
        type: json["type"],
        dialog: Dialog.fromJson(json["dialog"]),
        action: Action.fromJson(json["action"]),
        currentAction: json["current_action"],
        totalActions: json["total_actions"],
      );

  Map<String, dynamic> toJson() => {
        "completed": completed,
        "type": type,
        "dialog": dialog!.toJson(),
        "action": action!.toJson(),
        "current_action": currentAction,
        "total_actions": totalActions,
      };
}

class Action {
  Action({
    this.gaze,
    this.emotion,
    this.successful,
    this.message,
    this.translation,
  });

  String? gaze;
  String? emotion;
  bool? successful;
  String? message;
  String? translation;

  Action copyWith({
    String? gaze,
    String? emotion,
    bool? successful,
    String? message,
    String? translation,
  }) =>
      Action(
        gaze: gaze ?? this.gaze,
        emotion: emotion ?? this.emotion,
        successful: successful ?? this.successful,
        message: message ?? this.message,
        translation: translation ?? this.translation,
      );

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        gaze: json["gaze"],
        emotion: json["emotion"],
        successful: json["successful"],
        message: json["message"],
        translation: json["translation"],
      );

  Map<String, dynamic> toJson() => {
        "gaze": gaze,
        "emotion": emotion,
        "successful": successful,
        "message": message,
        "translation": translation,
      };
}

class Dialog {
  Dialog({
    this.title,
    this.content,
  });

  String? title;
  String? content;

  Dialog copyWith({
    String? title,
    String? content,
  }) =>
      Dialog(
        title: title ?? this.title,
        content: content ?? this.content,
      );

  factory Dialog.fromJson(Map<String, dynamic> json) => Dialog(
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
      };
}
