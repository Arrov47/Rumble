class Message {
  String? get id => _id;
  final String from;
  final String to;
  final DateTime time_stamp;
  final String contents;
  String? _id;

  Message({
    required this.from,
    required this.to,
    required this.contents,
    required this.time_stamp,
  });

  Map<String, dynamic> toJson() {
    return {
      "from": this.from,
      "to": this.to,
      "time_stamp": this.time_stamp,
      "contents": this.contents,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    final message = Message(
      from: json["from"],
      to: json["to"],
      time_stamp: json["time_stamp"],
      contents: json["contents"],
    );
    message._id = json['id'];
    return message;
  }
}
