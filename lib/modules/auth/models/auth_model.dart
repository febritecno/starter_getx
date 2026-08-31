/// Sample model — mirrors the dummyjson `/auth/login` response, where the user
/// fields and the token live at the same (flat) level:
/// `{ "id", "username", "email", "firstName", "lastName", "image",
///    "accessToken", "refreshToken" }`.
class AuthModel {
  final String? token;
  final UserModel? user;

  AuthModel({this.token, this.user});

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        token: (json['accessToken'] ?? json['token'])?.toString(),
        user: UserModel.fromJson(json),
      );
}

class UserModel {
  final String? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? image;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.image,
  });

  String get fullName => [firstName, lastName].whereType<String>().join(' ');

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id']?.toString(),
        username: json['username']?.toString(),
        email: json['email']?.toString(),
        firstName: json['firstName']?.toString(),
        lastName: json['lastName']?.toString(),
        image: json['image']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'image': image,
      };
}
