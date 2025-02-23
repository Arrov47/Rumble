import '../../models/user.dart';

abstract class UserService {
  Future<User> connect(User user);
  Future<List<User>> online();
  Future<bool> disconnect(User user);
}
