class User {
  final String id;
  final String email;
  final String password;
  final DateTime joinedDate;
  final int count;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.joinedDate,
    required this.count,
  });

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        email: json['email'] as String,
        password: json['password'] as String,
        joinedDate: DateTime.parse(json['joined_date'] as String),
        count: json['count'] as int,
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'joinedDate': joinedDate,
        'count': count,
      };
}
