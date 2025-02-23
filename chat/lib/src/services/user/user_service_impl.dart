import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class UserServiceImpl implements UserService {
  RethinkDb r;
  Connection c;

  UserServiceImpl({
    required this.r,
    required this.c,
  });

  @override
  Future<User> connect(User user) async {
    var data = user.toJson();
    // if (user.id != null) data['id'] = user.id;
    print("Sending data to db: $data");
    final result = await r.table("users").insert(data, {
      'conflict': 'update',
      'return_changes': true,
    }).run(c);
    print("Got: ${result['changes']}");
    return User.fromJson(result['changes'].first['new_val']);
  }

  @override
  Future<bool> disconnect(User user) async {
    try {
      await r.table("users").update({
        'id': user.id,
        'active': false,
        'last_seen': DateTime.now(),
      }).run(c);
      c.close();
      return true;
    } catch (err) {
      return false;
    }
  }

  @override
  Future<List<User>> online() async {
    Cursor users = await r.table("users").filter({'active': true}).run(c);
    final userList = await users.toList();
    return userList.map((item) => User.fromJson(item)).toList();
  }
}
