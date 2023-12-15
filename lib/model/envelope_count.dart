// To parse this JSON data, do
//
//     final envelopeCount = envelopeCountFromJson(jsonString);

import 'dart:convert';

EnvelopeCount envelopeCountFromJson(String str) => EnvelopeCount.fromJson(json.decode(str));

String envelopeCountToJson(EnvelopeCount data) => json.encode(data.toJson());

class EnvelopeCount {
  String status;
  Data data;

  EnvelopeCount({
    required this.status,
    required this.data,
  });

  factory EnvelopeCount.fromJson(Map<String, dynamic> json) => EnvelopeCount(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  int actionRequired;
  int waitingForOthers;
  int expiringSoon;
  int completed;

  Data({
    required this.actionRequired,
    required this.waitingForOthers,
    required this.expiringSoon,
    required this.completed,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    actionRequired: json["action_required"],
    waitingForOthers: json["waiting_for_others"],
    expiringSoon: json["expiring_soon"],
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "action_required": actionRequired,
    "waiting_for_others": waitingForOthers,
    "expiring_soon": expiringSoon,
    "completed": completed,
  };
}
