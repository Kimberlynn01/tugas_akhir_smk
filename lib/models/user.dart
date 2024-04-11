class User {
  final int id;
  final String username;
  final String password;
  final String email;
  final String namaLengkap;
  final String alamat;

  User(
      {this.id = 0,
      required this.username,
      required this.password,
      required this.email,
      required this.namaLengkap,
      required this.alamat})
      : assert(id >= 0 || id == 0);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'] != null ? json['id'] as int : 0,
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      namaLengkap: json['namaLengkap'] ?? '',
      alamat: json['alamat'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'username': username,
      'password': password,
      'email': email,
      'namaLengkap': namaLengkap,
      'alamat': alamat,
    };
  }
}
