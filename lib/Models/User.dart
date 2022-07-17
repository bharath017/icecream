import 'dart:convert';

class User {
  final String FirstName;
  final String LastName;
  final String EmailId;
  final String PhoneNumber;

  User(
      {required this.FirstName,
      required this.LastName,
      required this.EmailId,
      required this.PhoneNumber});

  Map<String, dynamic> toMap() {
    return {
      'FirstName': FirstName,
      'LastName': LastName,
      'EmailId': EmailId,
      'PhoneNumber': PhoneNumber,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        EmailId: json['EmailId'] as String,
        FirstName: json['FirstName'] as String,
        LastName: json['LastName'] as String,
        PhoneNumber: json['PhoneNumber'] as String);
  }

  @override
  String toString() {
    return 'User(FirstName: $FirstName, LastName: $LastName, EmailId: $EmailId, PhoneNumber: $PhoneNumber)';
  }
}
