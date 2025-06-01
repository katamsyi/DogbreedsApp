// models/profile_model.dart
class ProfileModel {
  int? id;
  String? username;
  String? name;
  String? nim;
  String? email;
  String? birthDate;
  String? motto;
  String? profileImagePath;

  ProfileModel({
    this.id,
    required this.username,
    this.name,
    this.nim,
    this.email,
    this.birthDate,
    this.motto,
    this.profileImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'nim': nim,
      'email': email,
      'birthDate': birthDate,
      'motto': motto,
      'profileImagePath': profileImagePath,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      username: map['username'],
      name: map['name'],
      nim: map['nim'],
      email: map['email'],
      birthDate: map['birthDate'],
      motto: map['motto'],
      profileImagePath: map['profileImagePath'],
    );
  }

  @override
  String toString() {
    return 'ProfileModel{id: $id, username: $username, name: $name, nim: $nim, email: $email, birthDate: $birthDate, motto: $motto, profileImagePath: $profileImagePath}';
  }
}
