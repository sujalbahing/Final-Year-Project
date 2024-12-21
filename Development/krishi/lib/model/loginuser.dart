import 'dart:convert';

class LoginUser {
    final Token token;
    final String msg;

    LoginUser({
        required this.token,
        required this.msg,
    });

    factory LoginUser.fromRawJson(String str) => LoginUser.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
        token: Token.fromJson(json["token"]),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "token": token.toJson(),
        "msg": msg,
    };
}

class Token {
    final String refresh;
    final String access;

    Token({
        required this.refresh,
        required this.access,
    });

    factory Token.fromRawJson(String str) => Token.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Token.fromJson(Map<String, dynamic> json) => Token(
        refresh: json["refresh"],
        access: json["access"],
    );

    Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
    };
}
