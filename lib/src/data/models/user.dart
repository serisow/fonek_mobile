class User {
  final int id;
  final String phoneNumber;
  final String nickname;

  User({
    required this.id,
    required this.phoneNumber,
    required this.nickname,
  });

  // A factory constructor to create a User from JSON.
  // This is the translation work of the Liaison Agent.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'],
      phoneNumber: json['PhoneNumber'],
      nickname: json['Nickname'],
    );
  }
}