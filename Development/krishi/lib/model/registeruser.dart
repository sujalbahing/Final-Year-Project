import 'dart:convert';

class RegisterUser {
    final String message;
    final User user;

    RegisterUser({
        required this.message,
        required this.user,
    });

    factory RegisterUser.fromRawJson(String str) => RegisterUser.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RegisterUser.fromJson(Map<String, dynamic> json) => RegisterUser(
        message: json["message"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "user": user.toJson(),
    };
}

class User {
    final int id;
    final String username;
    final String email;
    final String password;
    final dynamic phone;
    final dynamic address;
    final DateTime createdAt;
    final DateTime updatedAt;
    final bool isAdmin;
    final bool tc;

    User({
        required this.id,
        required this.username,
        required this.email,
        required this.password,
        required this.phone,
        required this.address,
        required this.createdAt,
        required this.updatedAt,
        required this.isAdmin,
        required this.tc,
    });

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        address: json["address"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isAdmin: json["is_admin"],
        tc: json["tc"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "phone": phone,
        "address": address,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_admin": isAdmin,
        "tc": tc,
    };
}
