import 'package:class12chatapp/auth/firebase_auth.dart';
import 'package:class12chatapp/db/DBHelper.dart';
import 'package:class12chatapp/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class chatRoomProvider extends ChangeNotifier {
  List<MessageModel> msgList = [];

  Future<void> addMessage(String msg) {
    final messageModel = MessageModel(
        userUid: AuthService.user!.uid,
        userImage: AuthService.user!.photoURL,
        userName: AuthService.user!.displayName,
        msgId: DateTime.now().microsecondsSinceEpoch,
        email: AuthService.user!.email!,
        msg: msg,
        timestamp: Timestamp.now(),
    );
    return DBHelper.addMsg(messageModel);
  }

  getChatRoomMessages(){
    DBHelper.getAllChatRoomMessages().listen((snapshot) {
      msgList = List.generate(snapshot.docs.length, (index) =>
          MessageModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
}