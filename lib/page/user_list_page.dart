import 'package:class12chatapp/auth/firebase_auth.dart';
import 'package:class12chatapp/providers/chat_room_provider.dart';
import 'package:class12chatapp/providers/user_providers.dart';
import 'package:class12chatapp/widgets/main_drawer.dart';
import 'package:class12chatapp/widgets/user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  static const String routeName = '/user_list';
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {

  bool isFirst = true;
  @override
  void didChangeDependencies() {
    if(isFirst){
      Provider.of<Userprovider>(context,listen: false)
          .getAllRemainingUsers(AuthService.user!.uid);
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: Consumer<Userprovider>(
        builder: (context,provider,_)=>ListView.builder(
          itemCount: provider.remainingUserList.length,
          itemBuilder: (context,index){
            final user = provider.remainingUserList[index];
            return UserItem(userModel: user);
          },
        ),
      ),
    );
  }
}
