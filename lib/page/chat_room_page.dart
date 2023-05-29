import 'package:class12chatapp/providers/chat_room_provider.dart';
import 'package:class12chatapp/widgets/main_drawer.dart';
import 'package:class12chatapp/widgets/message_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatRoomPage extends StatefulWidget {
  static const String routeName = '/chat_room';

  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  bool isFirst = true;
  final txtController = TextEditingController();

  @override
  void dispose() {
    txtController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (isFirst) {
      Provider.of<chatRoomProvider>(context, listen: false)
          .getChatRoomMessages();
      isFirst = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey,
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Consumer<chatRoomProvider>(
        builder: (context, provider, _) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: provider.msgList.length,
                itemBuilder: (context, index){
                  final messageModel = provider.msgList[index];
                  return MessageItem(messageModel: messageModel);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: txtController,
                        decoration: InputDecoration(
                          // filled: true,
                          // fillColor: Colors.brown,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          hintText: 'Type your message here'
                        ),
                      ),
                  ),
                  IconButton(
                      onPressed: (){
                        if(txtController.text.isEmpty)return;
                        provider.addMessage(txtController.text);
                        txtController.clear();
                      },
                      icon: Icon(Icons.send,
                      color: Theme.of(context).primaryColor,),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
