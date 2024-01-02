
import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  String? status;
  Data? data;

  Profile({
    required this.status,
    required this.data,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  String? message;
  User? user;

  Data({
    required this.message,
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        message: json["message"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user": user?.toJson(),
      };
}

class User {
  String? id;
  String? role_id;
  String? first_name;
  String? last_name;
  String? email_address;
  String? digital_signature;
  String? profile_image;
  String? company;
  String? title;
  String? address;
  String? landline;
  String? country_code;
  String? mobile;
  String? desk_number;
  bool? status;
  String? timestamp;
  bool? deleted;
  String? role_name;

  User({
    required this.id,
    required this.role_id,
    required this.first_name,
    required this.last_name,
    required this.email_address,
    required this.digital_signature,
    required this.profile_image,
    required this.company,
    required this.title,
    required this.address,
    required this.landline,
    required this.country_code,
    required this.mobile,
    required this.desk_number,
    required this.status,
    required this.timestamp,
    required this.deleted,
    required this.role_name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        role_id: json["role_id"],
        first_name: json["first_name"],
        last_name: json["last_name"],
        email_address: json["email_address"],
        digital_signature: json["digital_signature"],
        profile_image: json["profile_image"],
        company: json["company"],
        title: json["title"],
        address: json["address"],
        landline: json["landline"],
        country_code: json["country_code"],
        mobile: json["mobile"],
        desk_number: json["desk_number"],
        status: json["status"],
        timestamp: json["timestamp"],
        deleted: json["deleted"],
        role_name: json["role_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": role_id,
        "first_name": first_name,
        "last_name": last_name,
        "email_address": email_address,
        "digital_signature": digital_signature,
        "profile_image": profile_image,
        "company": company,
        "title": title,
        "address": address,
        "landline": landline,
        "country_code": country_code,
        "mobile": mobile,
        "desk_number": desk_number,
        "status": status,
        "timestamp": timestamp,
        "deleted": deleted,
        "role_name": role_name,
      };
}
