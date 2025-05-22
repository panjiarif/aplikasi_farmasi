class UserModel {
  final int? id;
  final String username;
  final String passwordHash;

  UserModel({this.id, required this.username, required this.passwordHash});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': passwordHash,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      passwordHash: map['password'],
    );
  }
}
