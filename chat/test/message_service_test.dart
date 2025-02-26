import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/message/message_service_contract.dart';
import 'package:chat/src/services/message/message_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'helper.dart';

void main() {
  RethinkDb r = RethinkDb();
  Connection? connection;
  MessageServiceContract? sut;

  setUp(() async {
    print("-------------SET_UP------------------");
    connection = await r.connect(host: "127.0.0.1", port: 28015);
    await createDb(r, connection!);
    sut = MessageServiceImpl(r: r, connection: connection!);
  });

  tearDown(() async {
    print("-------------TEAR_DOWN------------------");
    try {
      await cleanDb(r, connection!);
      await sut!.dispose();
    } catch (err) {
      print(err);
      rethrow;
    }
  });

  final user1 = User.fromJson({
    'id': '1111',
    'active': true,
    'last_seen': DateTime.now(),
  });

  final user2 = User.fromJson({
    'id': '2222',
    'active': true,
    'last_seen': DateTime.now(),
  });

  test("sent message successfully", () async {
    Message message = Message(
      from: 'user1',
      to: 'user2',
      contents: "3456",
      time_stamp: DateTime.now(),
    );
    try {
      final result = await sut!.send(message);
      print("Result: ${result}");
      expect(result, true);
    } catch (err) {
      print(err);
    }
  });

  test("successfully subscribe and receive messages", () async {
    sut!.messages(user2).listen(expectAsync1((message) {
          print("Received message: ${message.toJson()}");
          expect(message.to, user2.id);
          expect(message.id, isNotEmpty);
        }, count: 2));
    Message message = Message(
      from: user1.id!,
      to: user2.id!,
      contents: "This is a message",
      time_stamp: DateTime.now(),
    );
    Message message2 = Message(
      from: user1.id!,
      to: user2.id!,
      contents: "This is another message",
      time_stamp: DateTime.now(),
    );
    try {
      await sut!.send(message);
      await sut!.send(message2);
    } catch (err) {
      print(err);
    }
  });

  test("successfully subscribe and receive new messages", () async {
    Message message = Message(
      from: user1.id!,
      to: user2.id!,
      contents: "This is a message",
      time_stamp: DateTime.now(),
    );
    Message message2 = Message(
      from: user1.id!,
      to: user2.id!,
      contents: "This is another message",
      time_stamp: DateTime.now(),
    );
    try {
      await sut!.send(message);
      await sut!.send(message2).whenComplete(() {
        sut!.messages(user2).listen(expectAsync1((message) {
              print("Received message: ${message.toJson()}");
              expect(message.to, user2.id);
            }, count: 2));
      });
    } catch (err) {
      print(err);
    }
  });
}
