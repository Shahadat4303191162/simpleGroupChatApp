import 'package:class12chatapp/auth/firebase_auth.dart';
import 'package:class12chatapp/models/message_model.dart';
import 'package:class12chatapp/models/usermodel.dart';
import 'package:flutter/material.dart';
import '../utils/helper_function.dart';

class MessageItem extends StatelessWidget {
  final MessageModel messageModel;

  const MessageItem({Key? key, required this.messageModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Color backgroundColorMsg = messageModel.userUid == AuthService.user!.uid?
    Theme.of(context).primaryColor!
        : Colors.grey[700]!;
    return Column(
      children: [
        Text(
          getFormattedDate(messageModel.timestamp.toDate(), 'HH:mm'),
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        // if(messageModel.userUid != AuthService.user!.uid)
        //   CircleAvatar(
        //     backgroundImage: messageModel.image == null
        //         ? AssetImage('images/person.png')
        //         : NetworkImage(messageModel.image!) as ImageProvider<Object>,
        //   ),
        Container(
          padding: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: messageModel.userUid == AuthService.user!.uid ? 0 : 24,
            right: messageModel.userUid == AuthService.user!.uid ? 24 : 0,
          ),
          alignment: messageModel.userUid == AuthService.user!.uid
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            margin: messageModel.userUid == AuthService.user!.uid
                ? const EdgeInsets.only(left: 120)
                : const EdgeInsets.only(right: 120),
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: messageModel.userUid == AuthService.user!.uid
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                color: messageModel.userUid == AuthService.user!.uid
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ListTile(
                //   title: Text(
                //     messageModel.msg,
                //     textAlign: TextAlign.start,
                //     style: TextStyle(
                //       fontSize: 13,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white,
                //       backgroundColor: backgroundColorMsg,
                //       //letterSpacing: -0.5
                //     ),
                //   ),
                if (messageModel.userUid != AuthService.user!.uid)
                  Text(
                    messageModel.userName ?? messageModel.email,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                Text(
                  messageModel.msg,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    //letterSpacing: -0.5
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    //   Chip(
    //   label: Padding(
    //     padding: const EdgeInsets.all(2.0),
    //     child: Column(
    //       crossAxisAlignment: messageModel.userUid ==
    //          AuthService.user!.uid ? CrossAxisAlignment.end:
    //       CrossAxisAlignment.start,
    //       children: [
    //         Text(messageModel.userName ?? messageModel.email,style: TextStyle(color: Colors.blue,fontSize: 12),),
    //         Text(getFormattedDate(messageModel.timestamp.toDate(), 'HH:mm'),style: TextStyle(color: Colors.grey,fontSize: 12),),
    //         Text(messageModel.msg,style: TextStyle(color: Colors.black,fontSize: 14),textAlign: TextAlign.justify,),
    //       ],
    //     ),
    //   ),
    // );
  }

  textMessage() {
    if (messageModel.userUid != AuthService.user!.uid) {
      Text(
        messageModel.userName ?? messageModel.email,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
        textAlign: TextAlign.start,
      );
    }
    Text(
      messageModel.msg,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        //letterSpacing: -0.5
      ),
    );
  }
}
