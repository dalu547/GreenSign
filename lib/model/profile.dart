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
  String? group_id;
  bool? is_group_admin;
  String? emp_id;
  String? user_name;
  String? first_name;
  String? last_name;
  String? email_address;
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
  String? group_name;

  String? digital_signature;
  String? long_signature_1;
  String? long_signature_2;
  String? long_signature_3;
  String? long_signature_4;
  String? initial;
  String? initial_1;
  String? initial_2;
  String? initial_3;
  String? initial_4;

  User({
    required this.id,
    required this.role_id,
    required this.group_id,
    required this.is_group_admin,
    required this.emp_id,
    required this.user_name,
    required this.first_name,
    required this.last_name,
    required this.email_address,
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
    required this.digital_signature,
    required this.long_signature_1,
    required this.long_signature_2,
    required this.long_signature_3,
    required this.long_signature_4,
    required this.initial,
    required this.initial_1,
    required this.initial_2,
    required this.initial_3,
    required this.initial_4,
    required this.group_name,

  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        role_id: json["role_id"],
        group_id: json["group_id"],
        is_group_admin: json["is_group_admin"],
        emp_id: json["emp_id"],
        user_name: json["user_name"],
        first_name: json["first_name"],
        last_name: json["last_name"],
        email_address: json["email_address"],
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
        digital_signature: json["digital_signature"],
        long_signature_1: json["long_signature_1"],
        long_signature_2: json["long_signature_2"],
        long_signature_3: json["long_signature_3"],
        long_signature_4: json["long_signature_4"],
        initial: json["initial"],
        initial_1: json["initial_1"],
        initial_2: json["initial_2"],
        initial_3: json["initial_3"],
        initial_4: json["initial_4"],
        group_name: json["group_name"],
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": role_id,
        "group_id": group_id,
        "is_group_admin": is_group_admin,
        "emp_id": emp_id,
        "user_name": user_name,
        "first_name": first_name,
        "last_name": last_name,
        "email_address": email_address,
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
        "digital_signature": digital_signature,
        "long_signature_1": long_signature_1,
        "long_signature_2": long_signature_2,
        "long_signature_3": long_signature_3,
        "long_signature_4": long_signature_4,
        "initial": initial,
        "initial_1": initial_1,
        "initial_2": initial_2,
        "initial_3": initial_3,
        "group_name": group_name,
      };
}
