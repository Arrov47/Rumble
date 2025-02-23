class User {
  String? get id => _id;
  String username;
  String photoUrl;
  String? _id;
  bool active;
  DateTime lastseen;

  User({
    required this.username,
    required this.photoUrl,
    required this.active,
    required this.lastseen,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": this.username,
      "photo_url": this.photoUrl,
      "active": this.active,
      "last_seen": this.lastseen.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      username: json["username"],
      photoUrl: json["photo_url"],
      active: json["active"],
      lastseen: DateTime.parse(json["last_seen"]),
    );
    user._id = json['id'];
    return user;
  }
}
