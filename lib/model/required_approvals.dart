
import 'dart:convert';

RequiredApproval requiredApprovalFromJson(String str) => RequiredApproval.fromJson(json.decode(str));

String requiredApprovalToJson(RequiredApproval data) => json.encode(data.toJson());

class RequiredApproval {
  String? recipientId;
  String? recipientName;
  String? recipientTitle;
  String? recipientEmail;
  int? orderId;
  String? recipientPrivilegeId;
  String? recipientPrivilegeName;
  String? recipientLastTimestamp;
  bool? recipientAction;

  RequiredApproval({
    required this.recipientId,
    required this.recipientName,
    required this.recipientTitle,
    required this.recipientEmail,
    required this.orderId,
    required this.recipientPrivilegeId,
    required this.recipientPrivilegeName,
    required this.recipientLastTimestamp,
    required this.recipientAction,
  });

  factory RequiredApproval.fromJson(Map<String, dynamic> json) => RequiredApproval(
    recipientId: json["recipient_id"],
    recipientName: json["recipient_name"],
    recipientTitle: json["recipient_title"],
    recipientEmail: json["recipient_email"],
    orderId: json["order_id"],
    recipientPrivilegeId: json["recipient_privilege_id"],
    recipientPrivilegeName: json["recipient_privilege_name"],
    recipientLastTimestamp: json["recipient_last_timestamp"],
    recipientAction: json["recipient_action"],
  );

  Map<String, dynamic> toJson() => {
    "recipient_id": recipientId,
    "recipient_name": recipientName,
    "recipient_title": recipientTitle,
    "recipient_email": recipientEmail,
    "order_id": orderId,
    "recipient_privilege_id": recipientPrivilegeId,
    "recipient_privilege_name": recipientPrivilegeName,
    "recipient_last_timestamp": recipientLastTimestamp,
    "recipient_action": recipientAction,
  };
}