class User {
  String? get id => _id;
  final String username;
  final String photoUrl;
  String? _id;
  final bool active;
  final DateTime last_seen;

  User({
    required this.username,
    required this.photoUrl,
    required this.active,
    required this.last_seen,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": this.username,
      "photo_url": this.photoUrl,
      "active": this.active,
      "last_seen": this.last_seen,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      username: json["username"] ?? '',
      photoUrl: json["photo_url"] ?? '',
      active: json["active"] ?? '',
      last_seen: json["last_seen"],
    );
    user._id = json['id'];
    return user;
  }
}
