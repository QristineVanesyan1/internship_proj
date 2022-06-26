import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  UserModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.birthdate,
      this.username,
      this.password,
      this.email,
      this.phone});

  factory UserModel.shallowCopy(UserModel user) {
    return UserModel()
      ..firstName = user.firstName
      ..lastName = user.lastName
      ..birthdate = user.birthdate
      ..username = user.username
      ..password = user.password
      ..phone = user.phone ?? ""
      ..email = user.email ?? "";
  }
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map["id"],
        firstName: map['firstName'],
        lastName: map['lastName'],
        birthdate: map['birthdate'],
        username: map['username'],
        email: map['email'],
        password: map['password'],
        phone: map['phone']);
  }

  String? id;
  String? firstName;
  String? lastName;
  String? birthdate;
  String? username;
  String? email;
  String? password;
  String? phone;

  Map<String, dynamic> toMapUpdate() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email ?? "",
        "username": username,
        "birthdate":
            "DateFormat.yMMMd('en_US').format(birthdate ?? DateTime.now())",
        "password": password,
        "phone": phone ?? ""
      };

  Map<String, dynamic> toMap() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "birthdate": birthdate,
        "username": username,
        "email": email,
        "password": password,
        "phone": phone,
      };

  factory UserModel.fromJSON(Map<String, dynamic> map) {
    return UserModel(
        id: map["_id"],
        firstName: map['firstName'],
        lastName: map['lastName'],
        password: map['password'],
        email: map['email'],
        phone: map['phone'],
        username: map['name'],
        birthdate: map['birthDate']);
  }

  String toJsonString() =>
      '{"firstName": "$firstName", "lastName": "$lastName", "password": "$password", "email": "$email","phone": "$phone","name": "$username","birthDate": "$birthdate"}';

  @override
  String toString() {
    return "[firstname: $firstName, lastname: $lastName, birthdate: ${birthdate.toString()}, username: $username, email: $email, password: $password, phone: $phone]";
  }
}
