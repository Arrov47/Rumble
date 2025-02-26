import '../../models/message.dart';
import '../../models/user.dart';

abstract class MessageServiceContract {
  Future<bool> send(Message message);

  Stream<Message> messages(User activeUser);

  dispose();
}
