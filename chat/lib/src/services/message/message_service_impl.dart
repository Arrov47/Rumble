import 'dart:async';

import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'message_service_contract.dart';

class MessageServiceImpl implements MessageServiceContract {
  RethinkDb r;
  Connection connection;
  final _controller = StreamController<Message>.broadcast();
  StreamSubscription? _changeFeed;

  MessageServiceImpl({
    required this.r,
    required this.connection,
  });

  @override
  dispose() {
    connection.close();
    if (_changeFeed != null) _changeFeed!.cancel();
  }

  @override
  Stream<Message> messages(User activeUser) {
    _startReceivingMessages(activeUser);
    return _controller.stream;
  }

  @override
  Future<bool> send(Message message) async {
    final Map record =
        await r.table('messages').insert(message.toJson()).run(connection);
    return record['inserted'] == 1;
  }

  void _startReceivingMessages(User user) async {
    _changeFeed = r
        .table('messages')
        .filter({'to': user.id})
        .changes({"include_initial": true})
        .run(connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event.forEach((feedData) {
            if (feedData['new_val'] == null) return;
            final message = _messageFromFeed(feedData);
            _controller.sink.add(message);
            _removeDeliveredMessage(message);
          }).catchError((err) => print(err));
        });
  }

  Message _messageFromFeed(feedData) {
    return Message.fromJson(feedData['new_val']);
  }

  void _removeDeliveredMessage(Message message) {
    r
        .table('messages')
        .get(message.id)
        .delete({"return_changes": false}).run(connection);
  }
}
