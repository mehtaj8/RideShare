class UserModel {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String profilePic;
  String createdAt;
  String provider;
  String uid;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.profilePic,
      required this.createdAt,
      required this.provider,
      required this.uid});

  factory UserModel.fromMap(Map<String, dynamic>? map) {
    return UserModel(
        firstName: map?['firstName'] ?? '',
        lastName: map?['lastName'] ?? '',
        email: map?['email'] ?? '',
        phoneNumber: map?['phoneNumber'] ?? '',
        profilePic: map?['profilePic'] ?? '',
        createdAt: map?['createdAt'] ?? '',
        provider: map?['provider'] ?? '',
        uid: map?['uid'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "profilePic": profilePic,
      "createdAt": createdAt,
      "provider": provider,
      "uid": uid,
    };
  }
}
