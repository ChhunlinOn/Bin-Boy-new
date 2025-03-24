class User {
  final String id;
  final String userName;
  final String email;
  final String profileImageUrl;
  final String token;

  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.profileImageUrl,
    required this.token,
  });

  // Convert user data to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'token': token,
    };
  }

  // Create user data from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      token: json['token'] ?? '',
    );
  }
}