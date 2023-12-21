// To parse this JSON data, do
//
//     final envelopeCount = envelopeCountFromJson(jsonString);

import 'dart:convert';

MEnvelopeCount envelopeCountFromJson(String str) => MEnvelopeCount.fromJson(json.decode(str));

String envelopeCountToJson(MEnvelopeCount data) => json.encode(data.toJson());

class MEnvelopeCount {
  String status;
  Data data;

  MEnvelopeCount({
    required this.status,
    required this.data,
  });

  factory MEnvelopeCount.fromJson(Map<String, dynamic> json) => MEnvelopeCount(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  int inbox;
  int completed;
  int sent;
  int draft;
  int voided;
  int expired;
  int deleted;
  int declined;

  Data({
    required this.inbox,
    required this.completed,
    required this.sent,
    required this.draft,
    required this.voided,
    required this.expired,
    required this.deleted,
    required this.declined,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    inbox: json["inbox"],
    completed: json["completed"],
    sent: json["sent"],
    draft: json["draft"],
    voided: json["voided"],
    expired: json["expired"],
    deleted: json["deleted"],
    declined: json["declined"],
  );

  Map<String, dynamic> toJson() => {
    "inbox": inbox,
    "completed": completed,
    "sent": sent,
    "draft": draft,
    "voided": voided,
    "expired": expired,
    "deleted": deleted,
    "declined": declined,
  };
}
