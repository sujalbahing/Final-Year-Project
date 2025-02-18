import 'dart:convert';

class UserProfile {
  final String fullName;
  final String email;

  UserProfile({required this.fullName, required this.email});

  factory UserProfile.fromRawJson(String str) => UserProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        fullName: json["full_name"], // Change this to "name" if using the `name` field
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName, // Change this to "name" if using `name`
        "email": email,
      };
}