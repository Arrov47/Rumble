import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'helper.dart';

void main() {
  RethinkDb r = RethinkDb();
  Connection? connection;
  UserServiceImpl? sut;
  setUp(() async {
    print("-------------------------------");
    connection = await r.connect(host: "127.0.0.1", port: 28015);
    await createDb(r, connection!);
    sut = UserServiceImpl(r: r, c: connection!);
  });

  tearDown(() async {
    print("-------------------------------");
    try {
      if (connection != null) {
        await cleanDb(r, connection!);
      }
    } catch (err) {
      print("Err: $err");
      rethrow;
    }
  });
  test("Creates a new user document in database", () async {
    final user = User(
      username: "test",
      photoUrl: "url",
      active: true,
      lastseen: DateTime.now(),
    );
    try {
      if (sut != null) {
        final userWithId = await sut!.connect(user);
        expect(userWithId.id, isNotEmpty);
      }
    } catch (err) {
      print("Err: $err");
      rethrow;
    }
  });
  test("get all online users", () async {
    final user = User(
      username: "test",
      photoUrl: "url",
      active: true,
      lastseen: DateTime.now(),
    );

    try {
      if (sut != null) {
        await sut!.connect(user);

        final users = await sut!.online();

        expect(users.length, 1);
      }
    } catch (err) {
      print("Err: $err");
      rethrow;
    }
  });
}
