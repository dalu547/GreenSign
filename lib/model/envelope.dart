// To parse this JSON data, do
//
//     final envelopeCount = envelopeCountFromJson(jsonString);

import 'dart:convert';

import 'package:DigiSign/model/required_approvals.dart';

import 'document.dart';

Envelope envelopeCountFromJson(String str) => Envelope.fromJson(json.decode(str));

String envelopeCountToJson(Envelope data) => json.encode(data.toJson());

class Envelope {
  String? id;
  String? envelopeId;
  int? orderId;
  String? userId;
  String? envelopeName;
  String? groupId;
  String? groupName;
  String? senderId;
  String? from;
  String? envelopePrivilege;
  String? envelopePrivilegeName;
  String? statusId;
  String? statusName;
  int? totalNumberDocuments;
  int? totalNumberRecipients;
  int? totalSignedDocuments;
  String? envelopeStatusType;
  String? timestamp;
  bool? status;
  bool? signingOrder;
  String? createdOn;
  String? expiringOn;
  bool? expiringSoon;

  List<Document>? documents;//

  String? sentOn;
  String? lastChanged;

  // List<From> to;

  String? lastChangedBy;

  List<RequiredApproval>? requiredApprovals;//

  Envelope({
    required this.id,
    required this.envelopeId,
    required this.orderId,
    required this.userId,
    required this.envelopeName,
    required this.groupId,
    required this.groupName,
    required this.senderId,
    required this.from,
    required this.envelopePrivilege,
    required this.envelopePrivilegeName,
    required this.statusId,
    required this.statusName,
    required this.totalNumberDocuments,
    required this.totalNumberRecipients,
    required this.totalSignedDocuments,
    required this.envelopeStatusType,
    required this.timestamp,
    required this.status,
    required this.signingOrder,
    required this.createdOn,
    required this.expiringOn,
    required this.expiringSoon,
    required this.documents,
    required this.sentOn,
    required this.lastChanged,
    // required this.to,
    required this.lastChangedBy,
    required this.requiredApprovals,
  });

  factory Envelope.fromJson(Map<String, dynamic> json) => Envelope(
    id: json["_id"],
    envelopeId: json["envelope_id"],
    orderId: json["order_id"],
    userId: json["user_id"],
    envelopeName: json["envelope_name"],
    groupId: json["group_id"],
    groupName:json["group_name"],
    senderId: json["sender_id"],
    from: json["from"],
    envelopePrivilege:json["envelope_privilege"],
    envelopePrivilegeName: json["envelope_privilege_name"],
    statusId:json["status_id"],
    statusName: json["status_name"],
    totalNumberDocuments: json["total_number_documents"],
    totalNumberRecipients: json["total_number_recipients"],
    totalSignedDocuments: json["total_signed_documents"],
    envelopeStatusType: json["envelope_status_type"],
    timestamp: json["timestamp"],
    status: json["status"],
    signingOrder: json["signing_order"],
    createdOn: json["created_on"],
    expiringOn: json["expiring_on"],
    expiringSoon: json["expiring_soon"],
    documents: List<Document>.from(json["documents"].map((x) => Document.fromJson(x))),
    sentOn: json["sent_on"],
    lastChanged: json["last_changed"],
    // to: List<From>.from(json["to"].map((x) => fromValues.map[x]!)),
    lastChangedBy: json["last_changed_by"],
    requiredApprovals: List<RequiredApproval>.from(json["required_approvals"].map((x) => RequiredApproval.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "envelope_id": envelopeId,
    "order_id": orderId,
    "user_id": userId,
    "envelope_name": envelopeName,
    "group_id": groupId,
    "group_name": groupName,
    "sender_id": senderId,
    "from": from,
    "envelope_privilege": envelopePrivilege,
    "envelope_privilege_name": envelopePrivilegeName,
    "status_id": statusId,
    "status_name": statusName,
    "total_number_documents": totalNumberDocuments,
    "total_number_recipients": totalNumberRecipients,
    "total_signed_documents": totalSignedDocuments,
    "envelope_status_type": envelopeStatusType,
    "timestamp": timestamp,
    "status": status,
    "signing_order": signingOrder,
    "created_on": createdOn,
    "expiring_on": expiringOn,
    "expiring_soon": expiringSoon,
    "documents": List<dynamic>.from(documents!.map((x) => x.toJson())),
    "sent_on": sentOn,
    "last_changed": lastChanged,
    // "to": List<dynamic>.from(to.map((x) => fromValues.reverse[x])),
    "last_changed_by": lastChangedBy,
    "required_approvals": List<dynamic>.from(requiredApprovals!.map((x) => x.toJson())),
  };
}
