import 'dart:convert';

Document documentFromJson(String str) => Document.fromJson(json.decode(str));

String documentToJson(Document data) => json.encode(data.toJson());

class Document {
  String id;
  String documentName;
  String document;
  //Cordinates cordinates;
  String timestamp;
  bool signature;
  bool status;

  Document({
    required this.id,
    required this.documentName,
    required this.document,
    //required this.cordinates,
    required this.timestamp,
    required this.signature,
    required this.status,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["_id"],
        documentName: json["document_name"],
        document: json["document"],
        //cordinates: Cordinates.fromJson(json["cordinates"]),
        timestamp: json["timestamp"],
        signature: json["signature"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "document_name": documentName,
        "document": document,
        //"cordinates": cordinates.toJson(),
        "timestamp": timestamp,
        "signature": signature,
        "status": status,
      };
}

class Cordinates {
  double x;
  double? y;
  int? page;
  double? x1;
  double? y1;

  Cordinates({
    required this.x,
    this.y,
    this.page,
    this.x1,
    this.y1,
  });

  factory Cordinates.fromJson(Map<String, dynamic> json) => Cordinates(
        x: json["x"]?.toDouble(),
        y: json["y"]?.toDouble(),
        page: json["page"],
        x1: json["x1"]?.toDouble(),
        y1: json["y1"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
        "page": page,
        "x1": x1,
        "y1": y1,
      };
}
