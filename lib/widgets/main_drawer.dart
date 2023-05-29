import 'package:class12chatapp/auth/firebase_auth.dart';
import 'package:class12chatapp/page/chat_room_page.dart';
import 'package:class12chatapp/page/launcher_page.dart';
import 'package:class12chatapp/page/profile_page.dart';
import 'package:class12chatapp/page/user_list_page.dart';
import 'package:class12chatapp/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.blue.shade700,
          ),
          ListTile(
            onTap: () => Navigator.pushReplacementNamed(context, profilePage.routeName),
            leading: Icon(Icons.person),
            title: const Text('My Profile'),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacementNamed(context, UserListPage.routeName),
            leading: Icon(Icons.group),
            title: const Text('User List'),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacementNamed(context, ChatRoomPage.routeName),
            leading: Icon(Icons.chat),
            title: const Text('Chat Room'),
          ),
          ListTile(
            onTap: () async{
              await Provider.of<Userprovider>(context,listen: false)
              .updateprofile(AuthService.user!.uid, {'availabla' : false});
              AuthService.logout()
                  .then((value) =>
                  Navigator.pushReplacementNamed(context, launcherPage.routeName));
            },
            leading: Icon(Icons.logout),
            title: const Text('Log Out'),
          )
        ],
      ),
    );
  }
}
