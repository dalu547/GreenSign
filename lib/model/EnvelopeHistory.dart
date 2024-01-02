import 'dart:convert';

EnvelopeHistory envHistoryFromJson(String str) => EnvelopeHistory.fromJson(json.decode(str));

String envHistoryToJson(EnvelopeHistory data) => json.encode(data.toJson());
class EnvelopeHistory {
  String? status;
  Data? data;

  EnvelopeHistory({this.status, this.data});

  EnvelopeHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? message;
  Result? result;

  Data({this.message, this.result});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? sId;
  String? envelopeName;
  String? groupId;
  String? groupName;
  String? senderId;
  String? from;
  bool? status;
  bool? signingOrder;
  String? timestamp;
  String? createdOn;
  String? statusId;
  String? presentStatusName;
  String? presentTimeStamp;
  String? dateCreated;
  String? expiringOn;
  List<String>? enclosedDocuments;
  List<String>? envelopeRecipients;
  String? dateSent;
  List<Activites>? activites;

  Result(
      {this.sId,
        this.envelopeName,
        this.groupId,
        this.groupName,
        this.senderId,
        this.from,
        this.status,
        this.signingOrder,
        this.timestamp,
        this.createdOn,
        this.statusId,
        this.presentStatusName,
        this.presentTimeStamp,
        this.dateCreated,
        this.expiringOn,
        this.enclosedDocuments,
        this.envelopeRecipients,
        this.dateSent,
        this.activites});

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    envelopeName = json['envelope_name'];
    groupId = json['group_id'];
    groupName = json['group_name'];
    senderId = json['sender_id'];
    from = json['from'];
    status = json['status'];
    signingOrder = json['signing_order'];
    timestamp = json['timestamp'];
    createdOn = json['created_on'];
    statusId = json['status_id'];
    presentStatusName = json['present_status_name'];
    presentTimeStamp = json['present_time_stamp'];
    dateCreated = json['date_created'];
    expiringOn = json['expiring_on'];
    enclosedDocuments = json['enclosed_documents'].cast<String>();
    envelopeRecipients = json['envelope_recipients'].cast<String>();
    dateSent = json['date_sent'];
    if (json['activites'] != null) {
      activites = <Activites>[];
      json['activites'].forEach((v) {
        activites!.add(new Activites.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['envelope_name'] = this.envelopeName;
    data['group_id'] = this.groupId;
    data['group_name'] = this.groupName;
    data['sender_id'] = this.senderId;
    data['from'] = this.from;
    data['status'] = this.status;
    data['signing_order'] = this.signingOrder;
    data['timestamp'] = this.timestamp;
    data['created_on'] = this.createdOn;
    data['status_id'] = this.statusId;
    data['present_status_name'] = this.presentStatusName;
    data['present_time_stamp'] = this.presentTimeStamp;
    data['date_created'] = this.dateCreated;
    data['expiring_on'] = this.expiringOn;
    data['enclosed_documents'] = this.enclosedDocuments;
    data['envelope_recipients'] = this.envelopeRecipients;
    data['date_sent'] = this.dateSent;
    if (this.activites != null) {
      data['activites'] = this.activites!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Activites {
  String? transactionId;
  String? userId;
  String? userName;
  String? statusId;
  String? action;
  String? timestamp;
  String? status;

  Activites(
      {this.transactionId,
        this.userId,
        this.userName,
        this.statusId,
        this.action,
        this.timestamp,
        this.status});

  Activites.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    statusId = json['status_id'];
    action = json['action'];
    timestamp = json['timestamp'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_id'] = this.transactionId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['status_id'] = this.statusId;
    data['action'] = this.action;
    data['timestamp'] = this.timestamp;
    data['status'] = this.status;
    return data;
  }
}
