import 'package:class12chatapp/page/login_page.dart';
import 'package:class12chatapp/page/profile_page.dart';
import 'package:class12chatapp/page/user_list_page.dart';
import 'package:flutter/material.dart';

import '../auth/firebase_auth.dart';

class launcherPage extends StatefulWidget {
  static const String routeName = 'Launcher';
  const launcherPage({Key? key}) : super(key: key);

  @override
  State<launcherPage> createState() => _launcherPageState();
}

class _launcherPageState extends State<launcherPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      if(AuthService.user ==null){
        Navigator.pushReplacementNamed(context, loginPage.routeName);
      }else{
        Navigator.pushReplacementNamed(context, UserListPage.routeName);
      }
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(

        ),
      ),
    );
  }
}

